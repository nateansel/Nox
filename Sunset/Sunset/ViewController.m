//
//  ViewController.m
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)updateView:(NSNotification *) notification {
  NSMutableDictionary *data = [sunEventObject updateDictionary];
  
  timeLabel.text = [data objectForKey:@"time"];
  NSLog(@"*****%@*****\n", [data objectForKey:@"time"]);
  timeUntil.text = [data objectForKey:@"timeLeft"];
  willSet.text = [data objectForKey:@"riseOrSet"];
  
  bool isSet = [[data objectForKey:@"isSet"] boolValue];
  bool updateColors = [[data objectForKey:@"updateColors"] boolValue];
  
  if (isSet && updateColors) {
    orangeGradientLayer.hidden = true;
    blueGradientLayer.hidden = false;
    // Set status bar to light color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
  } else {
    orangeGradientLayer.hidden = false;
    blueGradientLayer.hidden = true;
    // Set status bar to dark color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
  }
    
//  [myDefaults setDouble:[[data objectForKey:@"lat"] doubleValue] forKey:@"lat"];
//  [myDefaults setDouble:[[data objectForKey:@"long"] doubleValue] forKey:@"long"];
  
  // make a string representation of the next sun event for the today widget
//  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//  [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
//  NSLog([formatter stringFromDate:[sunEventObject getNextEvent]]);
//  [myDefaults setObject:[sunEventObject getNextEvent] forKey:@"nextSunEvent"];
  
  [myDefaults setObject:[sunEventObject getNextSunrise] forKey:@"nextSunrise"];
  [myDefaults setObject:[sunEventObject getNextSunset] forKey:@"nextSunset"];
  
  // synchronize the settings
  [myDefaults synchronize];
  
  ViewController *viewController = self;
  if (!(viewController.isViewLoaded && viewController.view.window)) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
  }
}

- (void)noLocationWarning {
  noLocation.hidden = YES;
  timeLabel.hidden = NO;
  timeUntil.hidden = NO;
  willSet.hidden = NO;
}

- (void)locationWarning {
  noLocation.text = @"You need to enable location services in Settings for the app to work properly.";
  noLocation.hidden = NO;
  timeLabel.hidden = YES;
  timeUntil.hidden = YES;
  willSet.hidden = YES;
}

- (void)setupLaunchView {
  noLocation.hidden = YES;
  timeLabel.hidden = YES;
  timeUntil.hidden = YES;
  willSet.hidden = YES;
}

// Sets up the gradient layers
- (void)setupGradients {
  orangeGradientLayer = [BackgroundLayer orangeGradient];
  blueGradientLayer = [BackgroundLayer blueGradient];
  orangeGradientLayer.frame = self.view.bounds;
  blueGradientLayer.frame = self.view.bounds;
  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
  [self.view.layer insertSublayer:blueGradientLayer atIndex:1];
  
  blueGradientLayer.hidden = true;
  orangeGradientLayer.hidden = false;
}

// Starts the locationManager with ALWAYS authorization
-(void)refresh {
  [sunEventObject updateLocation];
  [sunEventObject updateDictionary];
  [sunEventObject refreshUpcomingSunEvents];
  // [self updateView:nil];
}

// I use this for cases when the app is closed or the background refresh ends
// and the location service needs to be stopped
-(void)stopLocation {
  [sunEventObject stopUpdatingLocation];
}

// This is for background updates. Needs to be left here, but you can change
// up the code inside as long as it works the same and you leave in the completion handler
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [self refresh];
  [self stopLocation];
  NSLog(@"BACKGROUND REFRESH\n");
  completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)getNotificationSetting {
  return [myDefaults boolForKey:@"notificationSetting"];
}

- (void)setNotifications {
  [sunEventObject setNotificationsWithSeconds: (int) (60 * [myDefaults doubleForKey:@"notificationTimeCustomization"])
                                    andSunset: [myDefaults boolForKey:@"sunsetNotificationSetting"]
                                   andSunrise: [myDefaults boolForKey:@"sunriseNotificationSetting"]];
}

- (void)refreshNotifications {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [self setNotifications];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noLocationWarning) name:@"location" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWarning) name:@"noLocation" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"refreshView" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotifications) name:@"setNotifications" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLaunchView) name:@"launchView" object:nil];
  
 if (sunEventObject == nil) {
    sunEventObject = [[SunEvent alloc] init];
 }
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  [self setupGradients];
  [self refresh];
  
  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
  
  [self updateView:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
