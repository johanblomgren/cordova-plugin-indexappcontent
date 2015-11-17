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
#define kDEFAULT_INDEXING_INTERVAL 1

@implementation IndexAppContent

- (void)deviceIsReady:(CDVInvokedUrlCommand *)command {
  self.initDone = YES;
}

- (void)setItems:(CDVInvokedUrlCommand *)command {
    
    if (![self _shouldUpdateIndex]) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Will not update index"] callbackId:command.callbackId];
        
        return;
    }
    
    _group = dispatch_group_create();
    _queue = dispatch_queue_create("com.appindexcontent.group", NULL);
    
    NSDictionary *items = [command.arguments objectAtIndex:0];
    
    __block NSMutableArray *searchableItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in items) {
        dispatch_group_async(_group, _queue, ^{
            NSString *domain = [item objectForKey:@"domain"];
            NSString *identifier = [item objectForKey:@"identifier"];
            NSString *title = [item objectForKey:@"title"];
            NSString *description = [item objectForKey:@"description"];
            NSString *url = [item objectForKey:@"url"];
            
            NSLog(@"Indexing %@", title);
            
            CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeText];
            
            attributes.title = title;
            attributes.contentDescription = description;
            attributes.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; // Synchronous, rewrite!
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:domain attributeSet:attributes];
            [searchableItems addObject:item];
        });
    }
    
    dispatch_group_notify(_group, _queue, ^{
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            } else {
                NSLog(@"Indexing complete");
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
    NSDateComponents *minuteComponent = [[NSDateComponents alloc] init];
    minuteComponent.minute = [self _indexingInterval];
    
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:minuteComponent toDate:[NSDate date] options:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:nextDate forKey:kINDEX_TIMESTAMP_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)_getTimestamp
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kINDEX_TIMESTAMP_KEY];
}

- (NSInteger)_indexingInterval
{
    NSDictionary *settings = self.commandDelegate.settings;
    NSInteger interval = [[settings objectForKey:@"com.appindexcontent.indexinterval"] integerValue];
    
    return interval ? interval : kDEFAULT_INDEXING_INTERVAL;
}

@end
