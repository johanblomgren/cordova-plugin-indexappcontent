#import "AppDelegate+IndexAppContent.h"
#import "IndexAppContent.h"
#import <objc/runtime.h>
#import "MainViewController.h"

#define kINTERVAL 25

@implementation AppDelegate (IndexAppContent)

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        // Get the item identifier and use it
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        
        NSString *jsFunction = @"IndexAppContent.onItemPressed";
        NSString *params = [NSString stringWithFormat:@"{'identifier':'%@'}", identifier];
        NSString *result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params];
        [self callJavascriptFunctionWhenAvailable:result];
    }
}

- (void)callJavascriptFunctionWhenAvailable:(NSString *)function {
  IndexAppContent *indexAppContent = [self.viewController getCommandInstance:@"IndexAppContent"];
    
  if (indexAppContent.initDone) {
    [indexAppContent.webView stringByEvaluatingJavaScriptFromString:function];
  } else {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kINTERVAL * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
      [self callJavascriptFunctionWhenAvailable:function];
    });
  }
}

@end