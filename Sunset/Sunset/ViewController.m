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
  if (myDefaults == nil) {
    myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  }
  NSMutableDictionary *data = [sunEventObject updateDictionary];
  
  // Set up the variables to be used to determine the next sun event
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  NSDate *sunEventDate, *nextSunrise, *nextSunset;
  
  // find the next sunrise and the next sunset
  for (int i = 0; i < upcomingSunrises.count; i++) {
    // 68.48889 16.67833  --  Norway coordinates to test this code
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunrise = [upcomingSunrises objectAtIndex:i];
      break;
    }
  }
  for (int i = 0; i < upcomingSunsets.count; i++) {
    if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunset = [upcomingSunsets objectAtIndex:i];
      break;
    }
  }
  
  // compare the next sunrise against the next sunset to see which comes first
  if ([nextSunrise timeIntervalSinceNow] < [nextSunset timeIntervalSinceNow]) {
    sunEventDate = nextSunrise;
  } else {
    sunEventDate = nextSunset;
  }
  
  timeLabel.text = [self getTimeString:sunEventDate];
  timeUntil.text = [self getTimeLeftString:sunEventDate];
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
  
  [myDefaults setObject:[sunEventObject getNextSunrise] forKey:@"nextSunrise"];
  [myDefaults setObject:[sunEventObject getNextSunset] forKey:@"nextSunset"];
  [myDefaults synchronize];
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





/**
 * Sets up the gradients to be used in the main screen
 * @author Chased
 */
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




/**
 * Returns the notification setting held in myDefaults.
 * @author Nate
 *
 * @return A boolean as to the setting's state
 */
- (BOOL)getNotificationSetting {
  return [myDefaults boolForKey:@"notificationSetting"];
}





/**
 * Tells the SunEvent object to create notifications
 * @author Nate
 */
- (void)setNotifications {
  NSLog(@"Set Notifications");
  [sunEventObject setNotificationsWithSeconds: (int) (60 * [myDefaults doubleForKey:@"notificationTimeCustomization"])
                                    andSunset: [myDefaults boolForKey:@"sunsetNotificationSetting"]
                                   andSunrise: [myDefaults boolForKey:@"sunriseNotificationSetting"]];
}




/**
 * Clear all previously scheduled notifications and set new ones.
 * @author Nate
 */
- (void)refreshNotifications {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [self setNotifications];
}




/**
 * Returns the time from a date object in a string format.
 * @author Nate
 *
 * @param date A NSDate object of the time to be converted
 * @return A string representation of the time that was converted
 */
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





/**
 * Updates the values in myDefaults and returns a string representation of the countdown to the next sun event.
 * @author Nate
 *
 * @return NSString representation of the countdown to the next sun event
 */
- (NSString *)getTimeLeftString:(NSDate *)date {
  // declare some variables
  double tempTimeNum;
  int days, hours, minutes;
  NSString *dayString, *minuteString, *riseOrSet;
  
  // Let's start building a string! Starting with the end first? Okay!
  if ([self isSunriseNext]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
  // Do some calculations!
  tempTimeNum = [date timeIntervalSinceNow];      // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;             // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  days = hours / 24;
  hours -= days * 24;
  
  // Determine how many days left
  if (days > 0) {
    if (days == 1) {
      dayString = @"1 day ";
    } else {
      dayString = [NSString stringWithFormat:@"%d days ",days];
    }
  } else {
    dayString = @"";
  }
  
  // Determine how to display the minutes in fractions
  if (minutes > 45) {
    // Increase the hour variable to compensate for not showing minutes (rounding up an hour)
    hours++;
    minuteString = @"";
  } else if (minutes > 30) {
    minuteString = @"¾";
  } else if (minutes > 15) {
    minuteString = @"½";
  } else {
    minuteString = @"¼";
  }
  
  // If more than 45 minutes left until the sunrise or sunset
  if (hours > 0) {
    if (hours == 1 && minutes > 45) {
      return [NSString stringWithFormat:@"%@%d%@ hour %@.", dayString, hours, minuteString, riseOrSet];
    }
    return [NSString stringWithFormat:@"%@%d%@ hours %@.", dayString, hours, minuteString, riseOrSet];
  }
  
  // If the sunrise or sunset is about to happen (4 or less minutes to event)
  if (minutes < 5) {
    if ([self isSunriseNext]) {
      return @"Sunrise is imminent";
    } else {
      return @"Sunset is imminent";
    }
  }
  
  // If there is less than an hour but more than 4 minutes left before the sunrise or sunset
  return [NSString stringWithFormat:@"%d minutes %@", minutes, riseOrSet];
}





/**
 * Determines if a sunrise is the next sun event to occur.
 * @author Nate
 *
 * @return BOOL if the sunrise is next
 */
- (BOOL)isSunriseNext {
  BOOL sunriseNext = YES;
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  NSDate *nextSunrise, *nextSunset;
  
  // find the next sunrise and the next sunset
  for (int i = 0; i < upcomingSunrises.count; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunrise = [upcomingSunrises objectAtIndex:i];
      break;
    }
  }
  for (int i = 0; i < upcomingSunsets.count; i++) {
    if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunset = [upcomingSunsets objectAtIndex:i];
      break;
    }
  }
  
  // compare the next sunrise against the next sunset to see which comes first
  if ([nextSunrise timeIntervalSinceNow] < [nextSunset timeIntervalSinceNow]) {
    sunriseNext = YES;
  } else {
    sunriseNext = NO;
  }
  
  return sunriseNext;
}





- (void)viewWillAppear:(BOOL)animated {
  // myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  [super viewWillAppear:animated];
}





- (void)viewDidLoad {
  [super viewDidLoad];
  
  // set up notification handlers
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noLocationWarning) name:@"location" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWarning) name:@"noLocation" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"refreshView" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotifications) name:@"setNotifications" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLaunchView) name:@"launchView" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:UIApplicationWillEnterForegroundNotification object:nil];
  
  NSArray *timeDisplaySettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(6),
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
  [super viewDidAppear:animated];
  [self updateView:nil];
}





- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
