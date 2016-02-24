//
//  AppDelegate+IndexAppContent.h
//
//  Created by Johan Blomgren on 12/02/16.
//
//

#import "AppDelegate.h"

@interface AppDelegate (IndexAppContent)

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler;

@end
