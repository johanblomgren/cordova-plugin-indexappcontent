#import "AppDelegate+IndexAppContent.h"
#import "IndexAppContent.h"
#import <objc/runtime.h>
#import "MainViewController.h"

@implementation AppDelegate (IndexAppContent)

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        // Get the item identifier and send it
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        
        NSString *jsFunction = @"IndexAppContent.onItemPressed";
        NSString *params = [NSString stringWithFormat:@"{'identifier':'%@'}", identifier];
        NSString *result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params];
        [self callJavascriptFunctionWhenAvailable:result];
    }
    
    return YES;
}

- (void)callJavascriptFunctionWhenAvailable:(NSString *)function {
    IndexAppContent *indexAppContent = [self.viewController getCommandInstance:@"IndexAppContent"];
    
        if (indexAppContent.initDone) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self sendCommand:function webView:indexAppContent.webView];
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 25 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                [self callJavascriptFunctionWhenAvailable:function];
            });
        }
}

- (void)sendCommand:(NSString *)command webView:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:command];
}

@end
