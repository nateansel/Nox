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
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
