//
//  AppDelegate.m
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@import CoreLocation;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
  
  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  }
  
  return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
  ViewController *viewController = (ViewController *)self.window.rootViewController;
  
  [viewController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
    completionHandler(result);
  }];
  
  [self setNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  ViewController *viewController = (ViewController *)self.window.rootViewController;
  
  // Set up local notification for the next sun event if the switch is on
  [self setNotifications];
  
  [viewController stopLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
  ViewController *viewController = (ViewController *)self.window.rootViewController;
  
  [viewController refresh];
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  
  // Set up local notification for the next sun event if the switch is on
  [self setNotifications];
}

- (void)setNotifications {
  NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  if ([[myDefaults objectForKey:@"scheduleNotificationsOnDate"] timeIntervalSinceNow] < 0) {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    ViewController *viewController = (ViewController *)self.window.rootViewController;
    
    [viewController setNotifications];
  }
}

@end
