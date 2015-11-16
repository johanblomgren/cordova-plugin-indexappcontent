#import "Cordova/CDV.h"
#import "Cordova/CDVViewController.h"
#import "UIKit/UITouch.h"
#import "IndexAppContent.h"

@implementation IndexAppContent

- (void)deviceIsReady:(CDVInvokedUrlCommand *)command {
  self.initDone = YES;
}

- (void)setItems:(CDVInvokedUrlCommand *)command {
    NSDictionary *items = [command.arguments objectAtIndex:0];
    
    NSMutableArray *searchableItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in items) {
        NSString *domain = [item objectForKey:@"domain"];
        NSString *identifier = [item objectForKey:@"identifier"];
        NSString *title = [item objectForKey:@"title"];
        NSString *description = [item objectForKey:@"description"];
        NSString *url = [item objectForKey:@"url"];
        
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeText];
        
        attributes.title = title;
        attributes.contentDescription = description;
        attributes.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; // Synchronous, rewrite!
        
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:domain attributeSet:attributes];
        
        [searchableItems addObject:item];
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[searchableItems] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        } else {
            NSLog(@"Index saved");
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
        }
    }];
}

@end
