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
  
  timeLabel.text = [self getTimeString:[sunEventObject getNextEvent]];
  NSLog(@"*****%@*****\n", [data objectForKey:@"time"]);
  timeUntil.text = [data objectForKey:@"timeLeft"];
  willSet.text = [data objectForKey:@"riseOrSet"];
  
  bool isSet = [[data objectForKey:@"isSet"] boolValue];
  bool updateColors = [[data objectForKey:@"updateColors"] boolValue];
  bool updateStatusBar = [myDefaults boolForKey:@"updateStatusBar"];
  
  if (isSet && updateColors && updateStatusBar) {
    orangeGradientLayer.hidden = true;
    blueGradientLayer.hidden = false;
    // Set status bar to light color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
  } else if (!(isSet) && updateColors && updateStatusBar) {
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
  
  [sunEventObject refreshUpcomingSunEvents];
  
//  if (!(self.isViewLoaded && self.view.window)) {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//  }
  
//  if (!(self.isViewLoaded)) {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//  }
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
  NSLog(@"Set Notifications");
  [sunEventObject setNotificationsWithSeconds: (int) (60 * [myDefaults doubleForKey:@"notificationTimeCustomization"])
                                    andSunset: [myDefaults boolForKey:@"sunsetNotificationSetting"]
                                   andSunrise: [myDefaults boolForKey:@"sunriseNotificationSetting"]];
}

- (void)refreshNotifications {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [self setNotifications];
}

- (NSString *)getTimeString:(NSDate *)date {
  NSString *hourString, *minuteString, *amOrPM;
  int hours;
  BOOL isAM = YES;
  unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [calendar components:unitFlags fromDate:date];
  
  minuteString = [NSString stringWithFormat:@"%d", (int) [components minute]];
  if ([components minute] < 10) {
    minuteString = [@"0" stringByAppendingString:minuteString];
  }
  
  // format the time for 24h time
  if ([myDefaults boolForKey:@"24h"]) {
    hourString = [NSString stringWithFormat:@"%d", (int) [components hour]];
    if ([components hour] < 10) {
      hourString = [@"0" stringByAppendingString:hourString];
    }
    return [hourString stringByAppendingString:[@":" stringByAppendingString:minuteString]];
  }
  
  // format the time for 12h time
  hours = (int) [components hour];
  minuteString = [NSString stringWithFormat:@"%d", (int) [components minute]];
  if (hours >= 12) {
    hourString = [NSString stringWithFormat:@"%d", hours - 12];
    isAM = NO;
  } else if (hours == 0) {
    hourString = [NSString stringWithFormat:@"%d", 12];
  } else {
    hourString = [NSString stringWithFormat:@"%d", hours];
  }
  amOrPM = (isAM) ? @" AM" : @" PM";
  if ([components minute] < 10) {
    minuteString = [@"0" stringByAppendingString:minuteString];
  }
  
  return [hourString stringByAppendingString:[@":" stringByAppendingString:[minuteString stringByAppendingString:amOrPM]]];
}

- (void)viewWillAppear:(BOOL)animated {
  [self updateView:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noLocationWarning) name:@"location" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWarning) name:@"noLocation" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"refreshView" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotifications) name:@"setNotifications" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLaunchView) name:@"launchView" object:nil];
  
  NSArray *timeDisplaySettings = @[
                                    @{ UIFontFeatureTypeIdentifierKey: @(6),
                                       UIFontFeatureSelectorIdentifierKey: @(1)
                                       },
                                    @{ UIFontFeatureTypeIdentifierKey: @(17),
                                       UIFontFeatureSelectorIdentifierKey: @(1)
                                       }];
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
  UIFontDescriptor *originalDescriptor = [font fontDescriptor];
  UIFontDescriptor *timerDescriptor =[originalDescriptor fontDescriptorByAddingAttributes: @{ UIFontDescriptorFeatureSettingsAttribute: timeDisplaySettings }];
  UIFont *timeFont = [UIFont fontWithDescriptor: timerDescriptor size:0.0];
  
  timeLabel.font = timeFont;
  
  if (sunEventObject == nil) {
    sunEventObject = [[SunEvent alloc] init];
  }
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  [myDefaults setBool:YES forKey:@"updateStatusBar"];
  
  [self setupGradients];
  [self refresh];
  
  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
  
  [self updateView:nil];
  
  self.view.layer.cornerRadius = 8;
  self.view.clipsToBounds = YES;
  
}

- (void) viewDidAppear:(BOOL)animated {
  [self updateView:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
