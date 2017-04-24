//
//  AppDelegate+IndexAppContent.m
//
//  Created by Johan Blomgren on 12/02/16.
//
//

#import "AppDelegate+IndexAppContent.h"
#import "IndexAppContent.h"

#define kCALL_DELAY_MILLISECONDS 25

@implementation AppDelegate (IndexAppContent)

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        // Get the item identifier and use it
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];

        NSString *jsFunction = @"window.plugins.indexAppContent.onItemPressed";
        NSString *params = [NSString stringWithFormat:@"{'identifier':'%@'}", identifier];
        NSString *result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params];
        [self callJavascriptFunctionWhenAvailable:result];
        return YES;
    } else {
        // non spotlight related user activities might be handled by other plugins so check if other implementations exist and invoke them
        if ([[self superclass] instancesRespondToSelector:NSSelectorFromString(@"application:continueUserActivity:restorationHandler:")]) {
            return [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
        } else {
            return NO;
        }
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
