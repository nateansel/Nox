//
//  NotificationsSettingsTableViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 5/24/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsSettingsTableViewController : UITableViewController {
  IBOutlet UISwitch *sunsetNotificationsSwitch;
  IBOutlet UISwitch *sunriseNotificationsSwitch;
  IBOutlet UILabel *sunriseNotificationCount;
  IBOutlet UILabel *sunsetNotificationCount;
  
  NSUserDefaults *myDefaults;
  NSTimer *statusBarTimer;
}

- (IBAction)dismissSettingsView:(id)sender;
- (void)changeStatusBarColor;

@end
