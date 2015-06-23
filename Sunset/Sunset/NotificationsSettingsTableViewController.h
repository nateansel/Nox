//
//  NotificationsSettingsTableViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 5/24/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundLayer.h"

@interface NotificationsSettingsTableViewController : UITableViewController {
  IBOutlet UISwitch *hourSetting;
  IBOutlet UISwitch *sunriseNotificationSetting;
  IBOutlet UISwitch *sunsetNotificationSetting;
  IBOutlet UILabel *sunriseNotificationCount;
  IBOutlet UILabel *sunsetNotificationCount;
  
  IBOutlet UITableViewCell *sunriseNotificationCell;
  IBOutlet UITableViewCell *sunsetNotificationCell;
  
  IBOutlet UILabel *sunriseLabel;
  IBOutlet UILabel *sunsetLabel;
  
  NSUserDefaults *myDefaults;
  NSTimer *statusBarTimer;
  
  UIColor *originalBarColor;
}

- (IBAction)changeHourSetting:(id)sender;
- (IBAction)changeSunriseNotificationSetting:(id)sender;
- (IBAction)changeSunsetNotificationSetting:(id)sender;
- (IBAction)dismissSettingsView:(id)sender;
- (void)changeStatusBarColor;
- (void)checkNotifications;
- (BOOL)notificationsEnabled;
- (void)notificationChange;

@end
