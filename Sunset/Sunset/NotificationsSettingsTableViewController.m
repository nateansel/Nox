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
  
  [myDefaults setBool:YES forKey:@"updateStatusBar"];
  [myDefaults synchronize];
}

////////////////////////////////////////////////////////////////////////////////

/**
 *
 * @author Nate
 *
 * @param
 * @return
 */
- (IBAction)changeHourSetting:(id)sender {
  [myDefaults setBool:hourSetting.on forKey:@"24h"];
  [myDefaults synchronize];
}


////////////////////////////////////////////////////////////////////////////////

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
    sunriseNotificationCount.textColor = [UIColor whiteColor];
    sunriseLabel.textColor = [UIColor whiteColor];
    [sunriseNotificationCell setUserInteractionEnabled:YES];
    [myDefaults setBool:YES forKey:@"sunriseNotificationSetting"];
    [myDefaults synchronize];
  } else {
    sunriseNotificationCount.textColor = [UIColor lightGrayColor];
    sunriseLabel.textColor = [UIColor lightGrayColor];
    [sunriseNotificationCell setUserInteractionEnabled:NO];
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
    sunsetNotificationCount.textColor = [UIColor darkTextColor];
    sunsetLabel.textColor = [UIColor whiteColor];
    [sunsetNotificationCell setUserInteractionEnabled:YES];
    [myDefaults setBool:YES forKey:@"sunsetNotificationSetting"];
    [myDefaults synchronize];
  } else {
    sunsetNotificationCount.textColor = [UIColor lightGrayColor];
    sunsetLabel.textColor = [UIColor lightGrayColor];
    [sunsetNotificationCell setUserInteractionEnabled:NO];
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
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
  
//  CGFloat topLayoutGuide = self.topLayoutGuide.length;
//  self.tableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
//  CALayer *gradientLayer = [BackgroundLayer blueGradient];
//  //gradientLayer.frame = self.view.bounds;
//  UIWindow* theWindow = [[UIApplication sharedApplication] keyWindow];
//  UIViewController *rvc = theWindow.rootViewController;
//  gradientLayer.frame = rvc.view.bounds;
//  [self.view.layer insertSublayer:gradientLayer atIndex:0];
//  
//  originalBarColor = self.navigationController.navigationBar.barTintColor;

//  CALayer *gradientLayer = [BackgroundLayer blueGradient];
//  gradientLayer.frame = self.view.bounds;
//  [self.tableView.layer insertSublayer:gradientLayer atIndex:0];
  
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

  originalBarColor = self.navigationController.navigationBar.barTintColor;
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  // check the switch values
  if ([myDefaults boolForKey:@"sunriseNotificationSetting"]) {
    sunriseNotificationSetting.on = YES;
  } else {
    sunriseNotificationSetting.on = NO;
    sunriseNotificationCount.textColor = [UIColor lightGrayColor];
    sunriseLabel.textColor = [UIColor lightGrayColor];
    [sunriseNotificationCell setUserInteractionEnabled:NO];
  }
  
  // check the switch values
  if ([myDefaults boolForKey:@"sunsetNotificationSetting"]) {
    sunsetNotificationSetting.on = YES;
  } else {
    sunsetNotificationSetting.on = NO;
    sunsetNotificationCount.textColor = [UIColor lightGrayColor];
    sunsetLabel.textColor = [UIColor lightGrayColor];
    [sunsetNotificationCell setUserInteractionEnabled:NO];
    
//    sunsetNotificationCell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  // check value for 24h switch
  hourSetting.on = [myDefaults boolForKey:@"24h"];
  
  int count = 0;
  // show the count for sunrise notifications
  if ([myDefaults objectForKey:@"newSunriseNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:1],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],] forKey:@"newSunriseNotificationsArray"];
    [myDefaults synchronize];
  }
  
  // show the count for sunset notifications
  if ([myDefaults objectForKey:@"newSunsetNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:1],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],] forKey:@"newSunsetNotificationsArray"];
    [myDefaults synchronize];
  }
  
  count = 0;
  for (int i = 1; i < 13; i++) {
    if ([[[myDefaults objectForKey:@"newSunriseNotificationsArray"] objectAtIndex:i] boolValue]) {
      count++;
    }
  }
  sunriseNotificationCount.text = [NSString stringWithFormat:@"%d", count];
  
  count = 0;
  for (int i = 1; i < 13; i++) {
    if ([[[myDefaults objectForKey:@"newSunsetNotificationsArray"] objectAtIndex:i] boolValue]) {
      count++;
    }
  }
  sunsetNotificationCount.text = [NSString stringWithFormat:@"%d", count];
  
  statusBarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeStatusBarColor) userInfo:nil repeats:YES];
  
//  [self addGradientLayer];
  
//  orangeGradientLayer = [BackgroundLayer orangeGradient];
//  blueGradientLayer = [BackgroundLayer blueGradient];
//  orangeGradientLayer.frame = self.view.bounds;
//  blueGradientLayer.frame = self.view.bounds;
//  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
//  [self.view.layer insertSublayer:blueGradientLayer atIndex:1];
//  
//  blueGradientLayer.hidden = YES;
//  orangeGradientLayer.hidden = NO;
//  orangeGradientLayer = [BackgroundLayer orangeGradient];
  //  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.navigationController.navigationBar setHidden:NO];
  
//  [self.navigationController.navigationBar setBarTintColor:originalBarColor];
//  [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:0.47843137254901963 blue:1 alpha:1]];
//  [self.navigationController.navigationBar setTranslucent:YES];

  
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
  [myDefaults setBool:NO forKey:@"updateStatusBar"];
  [myDefaults synchronize];
}

- (UIView *)addGradientLayer {
  UIView* backView = [[UIView alloc] initWithFrame:self.view.frame];
  orangeGradientLayer = [BackgroundLayer orangeGradient];
  [backView.layer addSublayer:orangeGradientLayer];
//  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
  //  UIBezierPath *path = [UIBezierPath bezierPathWithRect:backView.bounds];
  //  [backView.layer addSublayer:[BackgroundLayer orangeGradient]];
  //  backView.layer.masksToBounds = NO;
  //  backView.layer.shadowColor = [UIColor blackColor].CGColor;
  //  backView.layer.shadowOpacity = 1;
  //  backView.layer.shadowOffset = CGSizeMake(-5,-5);
  //  backView.layer.shadowRadius = 20;
  //  backView.layer.shadowPath = path.CGPath;
  //  backView.layer.shouldRasterize = YES;
  //  [self.view.superview addSubview:backView];
//  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
  orangeGradientLayer.hidden = NO;
  
  //  [self.view.superview bringSubviewToFront:self.view];
  return backView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
//  self.view.backgroundColor = [UIColor clearColor];
//  [self addGradientLayer];
//  [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//  [self.navigationController.navigationBar setTranslucent:NO];
//  [self.navigationController.navigationBar setOpaque:NO];
//  [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//  [self.tableView setBackgroundView:nil];
//  [self.tableView setBackgroundColor:[UIColor clearColor]];
  
  //UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  UIImageView *backView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  backView.image = [UIImage imageNamed:@"tableViewBackground"];
  //  UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
  //  navView.image = [UIImage imageNamed:@"navBarBackground"];
  self.tableView.backgroundView = backView;
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];
  orangeGradientLayer.hidden = NO;
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [self.navigationController.navigationBar setHidden:NO];
  
  int count = 0;
  // show the count for sunrise notifications
  if ([myDefaults objectForKey:@"newSunriseNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:1],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],] forKey:@"newSunriseNotificationsArray"];
    [myDefaults synchronize];
  }
  
  // show the count for sunset notifications
  if ([myDefaults objectForKey:@"newSunsetNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:1],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],] forKey:@"newSunsetNotificationsArray"];
    [myDefaults synchronize];
  }
  
  count = 0;
  for (int i = 1; i < 13; i++) {
    if ([[[myDefaults objectForKey:@"newSunriseNotificationsArray"] objectAtIndex:i] boolValue]) {
      count++;
    }
  }
  sunriseNotificationCount.text = [NSString stringWithFormat:@"%d", count];
  
  count = 0;
  for (int i = 1; i < 13; i++) {
    if ([[[myDefaults objectForKey:@"newSunsetNotificationsArray"] objectAtIndex:i] boolValue]) {
      count++;
    }
  }
  sunsetNotificationCount.text = [NSString stringWithFormat:@"%d", count];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
