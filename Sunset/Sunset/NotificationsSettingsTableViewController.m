//
//  NotificationsSettingsTableViewController.m
//  Sunset
//
//  Created by Nathan Ansel on 5/24/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "NotificationsSettingsTableViewController.h"

@interface NotificationsSettingsTableViewController ()

@end

@implementation NotificationsSettingsTableViewController

- (IBAction)dismissSettingsView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
  
  bool isSet = [[myDefaults objectForKey:@"isSet"] boolValue];
  
  [statusBarTimer invalidate];
  
  if(isSet) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
  }
  else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
  }

}

/**
 * Changes the status bar color every second while in the Settings View.
 * (A fix for the root view refreshing while the Settings View is still pulled up)
 * @author Chase
 *
 */
- (void)changeStatusBarColor {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  // show the count for sunrise notifications
  if ([myDefaults objectForKey:@"sunriseNotificationsArray"] == nil) {
    sunriseNotificationCount.text = @"0";
  } else {
    sunriseNotificationCount.text = [NSString stringWithFormat:@"%lu",(unsigned long) [[myDefaults objectForKey:@"sunriseNotificationsArray"] count]];
  }
  
  // show the count for sunset notifications
  if ([myDefaults objectForKey:@"sunsetNotificationsArray"] == nil) {
    sunsetNotificationCount.text = @"0";
  } else {
    sunsetNotificationCount.text = [NSString stringWithFormat:@"%lu",(unsigned long) [[myDefaults objectForKey:@"sunsetNotificationsArray"] count]];
  }
  
  statusBarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeStatusBarColor) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // show the count for sunrise notifications
  if ([myDefaults objectForKey:@"sunriseNotificationsArray"] == nil) {
    [myDefaults setObject:[[NSArray alloc] initWithObjects:@"60", nil] forKey:@"sunriseNotificationsArray"];
    [myDefaults synchronize];
  }
  sunriseNotificationCount.text = [NSString stringWithFormat:@"%lu",(unsigned long) [[myDefaults objectForKey:@"sunriseNotificationsArray"] count]];
  
  // show the count for sunset notifications
  if ([myDefaults objectForKey:@"sunsetNotificationsArray"] == nil) {
    [myDefaults setObject:[[NSArray alloc] initWithObjects:@"60", nil] forKey:@"sunsetNotificationsArray"];
    [myDefaults synchronize];
  }
  sunsetNotificationCount.text = [NSString stringWithFormat:@"%lu",(unsigned long) [[myDefaults objectForKey:@"sunsetNotificationsArray"] count]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
