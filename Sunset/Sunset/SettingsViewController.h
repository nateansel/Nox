//
//  SettingsViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 5/19/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
  IBOutlet UISwitch *sunsetNotificationSetting;
  IBOutlet UISwitch *sunriseNotificationSetting;
  IBOutlet UILabel *latitide;
  IBOutlet UILabel *longitude;
  IBOutlet UILabel *notificationTime;
  IBOutlet UIStepper *stepper;
  NSTimer *statusBarTimer;
  NSUserDefaults *myDefaults;
  
  IBOutlet UISwitch *backgroundNotifications;
}

- (IBAction)dismissSettingsView:(id)sender;
- (IBAction)changeSunsetNotificationSetting:(id)sender;
- (IBAction)changeSunriseNotificationSetting:(id)sender;
- (IBAction)stepperChange:(id)sender;
- (void)checkNotifications;
- (BOOL)notificationsEnabled;
- (NSString *)makeStringFromMinuteInt: (int) minutes;
- (IBAction)bishopButton:(id)sender;
- (void)changeStatusBarColor;

- (IBAction)changeBackgroundNotificationsSetting:(id)sender;

@end
