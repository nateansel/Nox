//
//  NotificationsSettingsTableViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 5/24/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsSettingsTableViewController : UITableViewController {
  IBOutlet UISwitch *sunriseNotificationSetting;
  IBOutlet UISwitch *sunsetNotificationSetting;
  IBOutlet UILabel *sunriseNotificationCount;
  IBOutlet UILabel *sunsetNotificationCount;
  
  NSUserDefaults *myDefaults;
  NSTimer *statusBarTimer;
}

- (IBAction)changeSunriseNotificationSetting:(id)sender;
- (IBAction)changeSunsetNotificationSetting:(id)sender;
- (IBAction)dismissSettingsView:(id)sender;
- (void)changeStatusBarColor;
- (void)checkNotifications;
- (BOOL)notificationsEnabled;
- (void)notificationChange;

@end
