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
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView"
                                                      object:nil];
  [self dismissViewControllerAnimated:YES completion:nil];
  [statusBarTimer invalidate];
}

- (IBAction)changeSunsetNotificationSetting:(id)sender {
  [self checkNotifications];
  
  if ([sunsetNotificationSetting isOn]) {
    [myDefaults setObject:@"YES" forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  } else {
    [myDefaults setObject:@"NO" forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  }
}

- (IBAction)changeSunriseNotificationSetting:(id)sender {
  [self checkNotifications];
  
  if ([sunriseNotificationSetting isOn]) {
    [myDefaults setObject:@"YES" forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  } else {
    [myDefaults setObject:@"NO" forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  }
}

- (void)checkNotifications {
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

- (BOOL)notificationsEnabled {
  UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
  
  if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone)) {
    return NO;
  }
  return YES;
}

- (void)changeStatusBarColor {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  if ([myDefaults objectForKey:@"sunsetNotificationSetting"] == nil) {
    [myDefaults setObject:@"NO" forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  }
  if ([myDefaults objectForKey:@"sunriseNotificationSetting"] == nil) {
    [myDefaults setObject:@"NO" forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  }
  if ([myDefaults objectForKey:@"notificationTimeCustomization"] == nil) {
    [myDefaults setObject:@"60" forKey:@"notificationTimeCustomization"];
    [myDefaults synchronize];
  }
  
  sunsetNotificationSetting.on = [[myDefaults objectForKey:@"sunsetNotificationSetting"] boolValue];
  sunriseNotificationSetting.on = [[myDefaults objectForKey:@"sunriseNotificationSetting"] boolValue];
  
  latitide.text = [NSString stringWithFormat:@"Lat: %.5f", [[myDefaults objectForKey:@"lat"] doubleValue]];
  longitude.text = [NSString stringWithFormat:@"Long: %.5f", [[myDefaults objectForKey:@"long"] doubleValue]];
  
  if(![self notificationsEnabled]) {
    sunsetNotificationSetting.on = NO;
    sunriseNotificationSetting.on = NO;
  }
  
  stepper.value = [[myDefaults objectForKey:@"notificationTimeCustomization"] doubleValue];
  
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

- (IBAction)stepperChange:(id)sender {
  notificationTime.text = [self makeStringFromMinuteInt:(int) stepper.value];
  [myDefaults setObject:[NSString stringWithFormat:@"%d",(int) stepper.value] forKey:@"notificationTimeCustomization"];
  [myDefaults synchronize];
}

- (NSString *)makeStringFromMinuteInt: (int) minutes {
  if (minutes < 60) {
    return [NSString stringWithFormat:@"%d minutes", minutes];
  } else if (minutes == 60) {
    return @"1 hour";
  }
  return [NSString stringWithFormat:@"1 hour and %d minutes",(minutes - 60)];
}

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
