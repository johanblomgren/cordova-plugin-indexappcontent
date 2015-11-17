#import <Cordova/CDVPlugin.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

@interface IndexAppContent : CDVPlugin

@property BOOL initDone;

- (void)deviceIsReady:(CDVInvokedUrlCommand *)command;

- (void)setItems:(CDVInvokedUrlCommand *)command;
- (void)clearItemsForDomains:(CDVInvokedUrlCommand *)command;

@end
