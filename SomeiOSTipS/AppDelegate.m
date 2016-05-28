//
//  AppDelegate.m
//  SomeiOSTipS
//
//  Created by tunsuy on 9/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertAction = @"Testing notification";
    localNoti.alertBody = @"it works";
    localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
    
    /** 显示默认本地通知 */
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil]];
    
    /** 自定义本地通知策略 */
    UIMutableUserNotificationAction *notificationActionOk = [[UIMutableUserNotificationAction alloc] init];
    notificationActionOk.identifier = @"completeRemindRater";
    notificationActionOk.title = @"再工作一会";
    notificationActionOk.destructive = false;
    notificationActionOk.authenticationRequired = false;
    notificationActionOk.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationAction *notificationActionResetNow = [[UIMutableUserNotificationAction alloc] init];
    notificationActionResetNow.identifier = @"relaxNow";
    notificationActionResetNow.title = @"休息";
    notificationActionResetNow.destructive = false;
    notificationActionResetNow.authenticationRequired = false;
    notificationActionResetNow.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"category";
    
//    [category setActions:@[notificationActionOk, notificationActionResetNow] forContext:UIUserNotificationActionContextDefault];
//    [category setActions:@[notificationActionOk, notificationActionResetNow] forContext:UIUserNotificationActionContextMinimal];
//    
//    localNoti.category = @"category";
//    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:[NSSet setWithObject:category]]];
    
    /** 回复通知 */
//    UIMutableUserNotificationAction *replyNotiAction = [[UIMutableUserNotificationAction alloc] init];
//    replyNotiAction.identifier = @"reply";
//    replyNotiAction.title = @"回复";
//    replyNotiAction.destructive = false;
//    replyNotiAction.authenticationRequired = false;
//    replyNotiAction.behavior = UIUserNotificationActionBehaviorTextInput;
//    replyNotiAction.activationMode = UIUserNotificationActivationModeBackground;
//    
//    [category setActions:@[replyNotiAction] forContext:UIUserNotificationActionContextDefault];
//    [category setActions:@[replyNotiAction] forContext:UIUserNotificationActionContextMinimal];
//    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:[NSSet setWithObject:category]]];
//    
//    localNoti.category = @"category";
//    [application scheduleLocalNotification:localNoti];
    
    return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    NSLog(@"你的选择是：%@", identifier);
    if ([identifier isEqualToString:@"completeRemindRater"]) {
        [application scheduleLocalNotification:notification];
    }
    else if ([identifier isEqualToString:@"relaxNow"]) {
        
    }
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    NSString *response = responseInfo[UIUserNotificationActionResponseTypedTextKey];
    if (response) {
        NSLog(@"response is : %@",response);
    }
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
