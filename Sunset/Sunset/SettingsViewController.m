//
//  SettingsViewController.m
//  Sunset
//
//  Created by Nathan Ansel on 5/19/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (IBAction)dismissSettingsView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
  [statusBarTimer invalidate];
  
  bool isSet = [[myDefaults objectForKey:@"isSet"] boolValue];
  
  if(isSet) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
  }
  else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
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
    [myDefaults setBool:YES forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  } else {
    [myDefaults setBool:NO forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
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
    [myDefaults setBool:YES forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  } else {
    [myDefaults setBool:NO forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  }
}

/**
 * Check to see if notifications are enabled, if not set the switches to "off" and notify the user that they cannot turn on notifications.
 * @author Nate
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
 * @author Nate
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
  latitide.text = [NSString stringWithFormat:@"Lat: %.5f", [myDefaults doubleForKey:@"lat"]];
  longitude.text = [NSString stringWithFormat:@"Long: %.5f", [myDefaults doubleForKey:@"long"]];
}

/**
 * Load the view and initialize all functions and states for objects.
 * @author Nate
 *
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  // If there are no values for some settings in myDefaults, initialize them
  // The default values for BOOL values in myDefaults is NO, which is the default values
  //   for our switches, no reason to initialize them here
  if ([myDefaults doubleForKey:@"notificationTimeCustomization"] == 0) {
    [myDefaults setDouble:60.0 forKey:@"notificationTimeCustomization"];
    [myDefaults synchronize];
  }
  
  // Set the initial state for on-screen objects and labels
  sunsetNotificationSetting.on = [myDefaults boolForKey:@"sunsetNotificationSetting"];
  sunriseNotificationSetting.on = [myDefaults boolForKey:@"sunriseNotificationSetting"];
  latitide.text = [NSString stringWithFormat:@"Lat: %.5f", [myDefaults doubleForKey:@"lat"]];
  longitude.text = [NSString stringWithFormat:@"Long: %.5f", [myDefaults doubleForKey:@"long"]];
  
  // Quick check to see if notifications are enabled, if not turn off all notifications
  if(![self notificationsEnabled]) {
    sunsetNotificationSetting.on = NO;
    sunriseNotificationSetting.on = NO;
  }
  
  // set the value of the stepper to the saved value in myDefaults
  stepper.value = [myDefaults doubleForKey:@"notificationTimeCustomization"];
  
  // Fix for off colored status bar in settings page
  UIView *fixItView = [[UIView alloc] init];
  fixItView.frame = CGRectMake(0, 0, 320, 20);
  fixItView.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1]; //change this to match your navigation bar
  [self.view addSubview:fixItView];

  notificationTime.text = [self makeStringFromMinuteInt:(int) stepper.value];
  
  statusBarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeStatusBarColor) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * Detects when the stepper value is changed and updates the notificationTime label to match.
 * @author Nate
 *
 */
- (IBAction)stepperChange:(id)sender {
  notificationTime.text = [self makeStringFromMinuteInt:(int) stepper.value];
  [myDefaults setDouble:stepper.value forKey:@"notificationTimeCustomization"];
  [myDefaults synchronize];
}

/**
 * Creates a string representation of the time from minutes to hours and minutes.
 * @author Nate
 *
 * @param Minutes to be converted to a string
 * @return A string representation of those minutes
 */
- (NSString *)makeStringFromMinuteInt: (int) minutes {
  // If less than an hour, display minutes, otherwise display "1 hour" for 60 minutes and hour and minutes for everything else
  if (minutes < 60) {
    return [NSString stringWithFormat:@"%d minutes", minutes];
  } else if (minutes == 60) {
    return @"1 hour";
  }
  return [NSString stringWithFormat:@"1 hour and %d minutes", (minutes - 60)];
}

/**
 * A hidden gem! Click it (x2) to see what it is!
 * @author Chase
 *
 */
- (IBAction)bishopButton:(id)sender {
  NSString *URL = @"http://d.pr/i/13KHZ+";
  NSURL *myURL = [NSURL URLWithString:URL];
  [[UIApplication sharedApplication] openURL:myURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
