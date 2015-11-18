#import "Cordova/CDV.h"
#import "Cordova/CDVViewController.h"
#import "UIKit/UITouch.h"
#import "IndexAppContent.h"

@interface IndexAppContent () {
    dispatch_group_t _group;
    dispatch_queue_t _queue;
}

@end

#define kINDEX_TIMESTAMP_KEY @"kINDEX_TIMESTAMP_KEY"
#define kINDEXING_INTERVAL_KEY @"kINDEXING_INTERVAL_KEY"

#define kDEFAULT_INDEXING_INTERVAL 1440 // Minutes

@implementation IndexAppContent

#pragma mark - Public

- (void)deviceIsReady:(CDVInvokedUrlCommand *)command
{
  self.initDone = YES;
}

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)setItems:(CDVInvokedUrlCommand *)command
{
    
    if (![self _shouldUpdateIndex]) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Will not update index"] callbackId:command.callbackId];
        
        return;
    }
    
    _group = dispatch_group_create();
    _queue = dispatch_queue_create("com.appindexcontent.group", NULL);
    
    NSArray *items = [command.arguments objectAtIndex:0];
    
    __block NSMutableArray *searchableItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in items) {
        dispatch_group_async(_group, _queue, ^{
            NSString *domain = [item objectForKey:@"domain"];
            NSString *identifier = [item objectForKey:@"identifier"];
            NSString *title = [item objectForKey:@"title"];
            NSString *description = [item objectForKey:@"description"];
            NSString *url = [item objectForKey:@"url"];
            
            // Optional
            NSNumber *rating = [NSNumber numberWithInteger:[[item objectForKey:@"rating"] integerValue]];
            NSArray *keywords = [item objectForKey:@"keywords"];
            NSInteger lifetime = [[item objectForKey:@"lifetime"] integerValue];
            
            NSLog(@"Indexing %@", title);
            
            CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeText];
            
            attributes.title = title;
            attributes.contentDescription = description;
            attributes.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            attributes.displayName = title;
            attributes.rating = rating;
            attributes.keywords = keywords;
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:domain attributeSet:attributes];
            item.expirationDate = lifetime ? [self _dateByMinuteOffset:lifetime] : nil;
            
            [searchableItems addObject:item];
        });
    }
    
    dispatch_group_notify(_group, _queue, ^{
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            } else {
                NSLog(@"Indexing complete. Next indexing at %@", [self _getTimestamp]);
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
            }
        }];
    });
}

- (void)clearItemsForDomains:(CDVInvokedUrlCommand *)command
{
    NSArray *domains = [command.arguments objectAtIndex:0];
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:domains completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        } else {
            NSLog(@"Index removed for domains %@", domains);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
        }
    }];
}

- (void)setIndexingInterval:(CDVInvokedUrlCommand *)command
{
    NSInteger interval = [[command.arguments objectAtIndex:0] integerValue];
    
    if ([self _setIndexingInterval:interval]) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }
}

#pragma mark - Notifications

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification
{
    self.initDone = NO;
}

#pragma mark - Private

- (BOOL)_shouldUpdateIndex
{
    NSDate *updatedAt = [self _getTimestamp];
    BOOL shouldUpdate = YES;
    
    if (updatedAt && [updatedAt compare:[NSDate date]] == NSOrderedDescending) {
        NSLog(@"Will not update index. Last update: %@", updatedAt);
        shouldUpdate = NO;
    } else {
        [self _setTimestamp];
    }
    
    return shouldUpdate;
}

- (void)_setTimestamp
{
    NSDate *nextDate = [self _dateByMinuteOffset:[self _getIndexingInterval]];
    
    [[NSUserDefaults standardUserDefaults] setObject:nextDate forKey:kINDEX_TIMESTAMP_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)_dateByMinuteOffset:(NSInteger)minuteOffset
{
    NSDateComponents *minuteComponent = [[NSDateComponents alloc] init];
    minuteComponent.minute = minuteOffset;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:minuteComponent toDate:[NSDate date] options:0];
}

- (NSDate *)_getTimestamp
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kINDEX_TIMESTAMP_KEY];
}

- (NSInteger)_getIndexingInterval
{
    NSInteger interval = [[[NSUserDefaults standardUserDefaults] objectForKey:kINDEXING_INTERVAL_KEY] integerValue];
    
    return interval ? interval : kDEFAULT_INDEXING_INTERVAL;
}

- (BOOL)_setIndexingInterval:(NSInteger)interval
{
    if (!interval) {
        return NO;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(interval) forKey:kINDEXING_INTERVAL_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
