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
    }
    
    return YES;
}

- (void)callJavascriptFunctionWhenAvailable:(NSString *)function {
    IndexAppContent *indexAppContent = [self.viewController getCommandInstance:@"IndexAppContent"];
    
        if (indexAppContent.initDone && indexAppContent.ready) {
            [self sendCommand:function webView:indexAppContent.webView];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kCALL_DELAY_MILLISECONDS * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                [self callJavascriptFunctionWhenAvailable:function];
            });
        }
}

- (void)sendCommand:(NSString *)command webView:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:command];
}

@end
