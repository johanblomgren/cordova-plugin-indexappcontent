//
//  IndexAppContent.h
//
//  Created by Johan Blomgren on 12/02/16.
//
//

#import <Cordova/CDVPlugin.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

UIKIT_EXTERN NSString *kIndexAppContentDelayExecutionNotification;
UIKIT_EXTERN NSString *kIndexAppContentExecutionDelayKey;

@interface IndexAppContent : CDVPlugin

@property BOOL initDone;
@property BOOL ready;

- (void)deviceIsReady:(CDVInvokedUrlCommand *)command;
- (void)setItems:(CDVInvokedUrlCommand *)command;
- (void)clearItemsForDomains:(CDVInvokedUrlCommand *)command;
- (void)setIndexingInterval:(CDVInvokedUrlCommand *)command;

@end
