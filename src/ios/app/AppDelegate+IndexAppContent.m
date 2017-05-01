//
//  AppDelegate+IndexAppContent.m
//
//  Created by Johan Blomgren on 12/02/16.
//
//

#import "AppDelegate+IndexAppContent.h"
#import "IndexAppContent.h"
#import <objc/runtime.h>

#define kCALL_DELAY_MILLISECONDS 25

@implementation AppDelegate (IndexAppContent)

/*
 handle the case that another category or class in the class hierachy of AppDelegate already implements the UIApplicationDelegate and handOff method "application:continueUserActivity:restorationHandler:"
 Use method swizzling to archieve the following:
 - call the original implementation (which handles other use cases like universal links)
 - call our own implementation to handle CSSearchableItemActionType (if userActivity was not yet handled)
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL originalHandOffSEL, swizzledHandOffSEL, spotlightHandOffSEL;
        Method originalHandOffMethod, swizzledHandOffMethod, spotlightHandOffMethod;

        Class thisClass = [self class];

        originalHandOffSEL = @selector(application:continueUserActivity:restorationHandler:);
        swizzledHandOffSEL = @selector(swizzledHandOff:continueUserActivity:restorationHandler:);
        spotlightHandOffSEL = @selector(indexAppContent_application:continueUserActivity:restorationHandler:);

        BOOL originalHandOffExists = [self instancesRespondToSelector:originalHandOffSEL];

        originalHandOffMethod = class_getInstanceMethod(thisClass, originalHandOffSEL);
        swizzledHandOffMethod = class_getInstanceMethod(thisClass, swizzledHandOffSEL);
        spotlightHandOffMethod = class_getInstanceMethod(thisClass, spotlightHandOffSEL);

        BOOL didAddMethod = class_addMethod(thisClass, originalHandOffSEL, method_getImplementation(swizzledHandOffMethod), method_getTypeEncoding(swizzledHandOffMethod));

        if (didAddMethod) {
            if (!originalHandOffExists) {
                class_replaceMethod(thisClass, swizzledHandOffSEL, method_getImplementation(spotlightHandOffMethod), method_getTypeEncoding(spotlightHandOffMethod));
            } else {
                class_replaceMethod(thisClass, swizzledHandOffSEL, method_getImplementation(originalHandOffMethod), method_getTypeEncoding(originalHandOffMethod));
            }
        } else {
            method_exchangeImplementations(originalHandOffMethod, swizzledHandOffMethod);
        }
    });
}

- (BOOL)swizzledHandOff:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler {

    BOOL orginalHandOffImplementedHandledCase = [self swizzledHandOff:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    if (orginalHandOffImplementedHandledCase == NO) {
        return [self indexAppContent_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    } else {
      NSLog(@"Another implementation (e.g. plugin) already handled that userActivity");
      return YES;
    }
}

- (BOOL)indexAppContent_application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        NSString *jsFunction = @"window.plugins.indexAppContent.onItemPressed";
        NSString *params = [NSString stringWithFormat:@"{'identifier':'%@'}", identifier];
        NSString *result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params];
        [self callJavascriptFunctionWhenAvailable:result];
        return YES;
    } else {
        NSLog(@"userActivity is not related to spotlight and therefore does not get handled");
        return NO;
    }
}

- (void)callJavascriptFunctionWhenAvailable:(NSString *)function {

    __weak __typeof(self) weakSelf = self;
    __block NSString *command = function;

    __block void (^checkAndExecute)( ) = ^void( ) {
        NSString *check = @"(window && window.plugins && window.plugins.indexAppContent && typeof window.plugins.indexAppContent.onItemPressed == 'function') ? true : false";
        IndexAppContent *indexAppContent = [weakSelf.viewController getCommandInstance:@"IndexAppContent"];
        [weakSelf sendCommand:check webViewEngine:indexAppContent.webViewEngine completionHandler:^(id returnValue, NSError * error) {
            if (error || [returnValue boolValue] == NO) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kCALL_DELAY_MILLISECONDS * NSEC_PER_MSEC), dispatch_get_main_queue(), checkAndExecute);
            } else if ([returnValue boolValue] == YES) {
                [self sendCommand:command webViewEngine:indexAppContent.webViewEngine completionHandler:nil];
            }
        }];
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_MSEC), dispatch_get_main_queue(), checkAndExecute);
}

- (void)sendCommand:(NSString *)command webViewEngine:(id<CDVWebViewEngineProtocol>)webViewEngine completionHandler:(void (^)(id, NSError*))completionHandler
{
    [webViewEngine evaluateJavaScript:command completionHandler:completionHandler];
}

@end
