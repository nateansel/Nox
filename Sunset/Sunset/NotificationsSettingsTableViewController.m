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
  [self dismissViewControllerAnimated:YES completion:^{[self notificationChange];}];
  
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
 * When the sunrise notification switch is triggered, this function updates the settings in myDefaults.
 * @author Nate
 *
 */
- (IBAction)changeSunriseNotificationSetting:(id)sender {
  // Check to see if notifications are allowed or not
  [self checkNotifications];
  
  // Change the settings in myDefaults based on the switch's position
  if ([sunriseNotificationSetting isOn]) {
    sunriseNotificationCount.textColor = [UIColor blackColor];
    [myDefaults setBool:YES forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  } else {
    sunriseNotificationCount.textColor = [UIColor grayColor];
    [myDefaults setBool:NO forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  }
}

/**
 * When the sunset notification switch is triggered, this function updates the settings in myDefaults.
 * @author Nate
 *
 */
- (IBAction)changeSunsetNotificationSetting:(id)sender {
  // Check to see if notifications are allowed or not
  [self checkNotifications];
  
  // Change the settings in myDefaults based on the switch's position
  if ([sunsetNotificationSetting isOn]) {
    sunsetNotificationCount.textColor = [UIColor blackColor];
    [myDefaults setBool:YES forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  } else {
    sunsetNotificationCount.textColor = [UIColor grayColor];
    [myDefaults setBool:NO forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  }
}

/**
 * Check to see if notifications are enabled, if not set the switches to "off" and notify the user that they cannot turn on notifications.
 * @author Chase
 *
 */
- (void)checkNotifications {
  // If notifications are not enabled in Settings.app, notify the user and turn the switches back off.
  if(![self notificationsEnabled]) {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"You have notifications disabled. Please turn them on in Settings.app and try again."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
    sunsetNotificationSetting.on = NO;
    sunriseNotificationSetting.on = NO;
    [errorAlert show];
  }
}

/**
 * Used to test if a the user has allowed notifications for this app.
 * @author Chase
 *
 * @return A bool valued for notifications being enabled
 */
- (BOOL)notificationsEnabled {
  // Check to see if notifications are enabled in Settings.app for this app
  UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
  
  if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone)) {
    return NO;
  }
  return YES;
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

/**
 * Updates notifications when a user makes a change to the settings.
 * @author Chase
 *
 */
- (void)notificationChange {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"setNotifications"
                                                      object:nil];
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
  
  // check the switch values
  if ([myDefaults boolForKey:@"sunriseNotificationSetting"]) {
    sunriseNotificationSetting.on = YES;
  } else {
    sunriseNotificationSetting.on = NO;
    sunriseNotificationCount.textColor = [UIColor grayColor];
  }
  
  // check the switch values
  if ([myDefaults boolForKey:@"sunsetNotificationSetting"]) {
    sunsetNotificationSetting.on = YES;
  } else {
    sunsetNotificationSetting.on = NO;
    sunsetNotificationCount.textColor = [UIColor grayColor];
  }
  
  statusBarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeStatusBarColor) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  int count = 0;
  // show the count for sunrise notifications
  if ([myDefaults objectForKey:@"sunriseNotificationsArray"] == nil) {
    [myDefaults setObject:[[NSArray alloc] initWithObjects:@"60", nil] forKey:@"sunriseNotificationsArray"];
    [myDefaults synchronize];
  }
  sunriseNotificationCount.text = [NSString stringWithFormat:@"%d",(int) [[myDefaults objectForKey:@"sunriseNotificationsArray"] count]];
  
  // show the count for sunset notifications
  if ([myDefaults objectForKey:@"sunsetNotificationsArray"] == nil) {
    [myDefaults setObject:[[NSArray alloc] initWithObjects:@"60", nil] forKey:@"sunsetNotificationsArray"];
    [myDefaults synchronize];
  }
  
  count = 0;
  for (int i = 1; i < 13; i++) {
    if ([[[myDefaults objectForKey:@"newSunsetNotificationsArray"] objectAtIndex:i] boolValue]) {
      count++;
    }
  }
  sunsetNotificationCount.text = [NSString stringWithFormat:@"%d", count];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
