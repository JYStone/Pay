//
//  AppDelegate.m
//  iOS 支付封装
//
//  Created by 金靖媛 on 2017/8/8.
//  Copyright © 2017年 LY. All rights reserved.
//
/*
 *  微信、支付宝、银联
 *  苹果内购、京东钱包、百度钱包
 */
#import "AppDelegate.h"
#import "JYPayManager.h"
#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:@"wxb4ba3c02aa476ea1"];
//    [JYPayManager WXPayRegisterAppWithAppId:@"wxb4ba3c02aa476ea1"];
    return YES;
}

#pragma mark -
#pragma mark -   支付

//iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [JYPayManager handleOpenAppUrl:url];
    return YES;
}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    //[JYPayManager handleOpenAppUrl:url];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
