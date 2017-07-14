//
//  AppDelegate.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //高德地图key
//    [AMapServices sharedServices].apiKey = @"Your-AMap-API-Key";
    [AMapServices sharedServices].apiKey = @"a9f770ae0b2a67ef4c7b56a07ad83272";
    
    //UI
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor grayColor];
    UINavigationController *NaviVC = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    NaviVC.interactivePopGestureRecognizer.enabled = NO;
    [NaviVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBack"] forBarMetrics:UIBarMetricsDefault];
    NaviVC.navigationBar.tintColor = [UIColor whiteColor];
    [NaviVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _window.rootViewController = NaviVC;
    [_window makeKeyAndVisible];
    
    [SDKManager defaultManager].appstartDate = [NSDate date];
    
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
