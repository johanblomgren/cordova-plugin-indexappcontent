//
//  IndexAppContent.h
//
//  Created by Johan Blomgren on 12/02/16.
//
//

#import <Cordova/CDVPlugin.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

@interface IndexAppContent : CDVPlugin

- (void)isIndexingAvailable:(CDVInvokedUrlCommand *)command;
- (void)setItems:(CDVInvokedUrlCommand *)command;
- (void)clearItemsForDomains:(CDVInvokedUrlCommand *)command;
- (void)clearItemsForIdentifiers:(CDVInvokedUrlCommand *)command;
- (void)setIndexingInterval:(CDVInvokedUrlCommand *)command;

@end
