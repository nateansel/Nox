//
//  ViewController.m
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (IBAction)getLocation:(id)sender {
  [locationManager startUpdatingLocation];
  [self getTimeOfSunset];
  [self getTimeUntilSunset];
}

- (void)getTimeOfSunset {
  KCGeoLocation *currentLocation = [[KCGeoLocation alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude andTimeZone:[NSTimeZone systemTimeZone]];
  
  KCAstronomicalCalendar *calendar = [[KCAstronomicalCalendar alloc] initWithLocation:currentLocation];
  
  // This was declared as an instance variable, but never allocated and inited
  // does it need to be?
  sunset = [calendar sunset];
  NSDateFormatter *datFormatter = [[NSDateFormatter alloc] init];
  [datFormatter setDateFormat:@"h:mm a"];
  
  // Set the timeLabel with the sunset time
  timeLabel.text = [datFormatter stringFromDate:sunset];
  
  // Add this time to myDefaults and synchronize to make it available to
  // the today widget
  [myDefaults setObject:[datFormatter stringFromDate:sunset] forKey:@"date"];
  [myDefaults synchronize];
}

- (void)getTimeUntilSunset {
  NSDate *currentTime = [NSDate date];
    NSTimeInterval timeBetweenDates = [sunset timeIntervalSinceDate:currentTime];
  double secondsInAnHour = 3600;
  double secondsInAMinute = 60;
  
  // These variables hold the hours OR minutes until the sunset
  double hoursBetweenDates = timeBetweenDates / secondsInAnHour;
  double minutesBetweenDates = timeBetweenDates / secondsInAMinute;
  
  // If less than an hour remains
  if (hoursBetweenDates < 1.0 && hoursBetweenDates > 0.0) {
    isSet = NO;
    // Gradient
    orangeGradientLayer.hidden = false;
    blueGradientLayer.hidden = true;
    
    // Set status bar to dark color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    timeUntil.text = [NSString stringWithFormat:@"%.0f minutes of daylight left", minutesBetweenDates];
    willSet.text = @"the sun will set at";
    
    // Set objects and keys in myDefaults, and synchronize to make them available to
    // the today widget
    [myDefaults setObject:@"NO" forKey:@"isSet"];
    [myDefaults setObject:@"NO" forKey:@"inHours"];
    [myDefaults setObject:@"YES" forKey:@"inMinutes"];
    [myDefaults setObject:[NSString stringWithFormat:@"%.0f", minutesBetweenDates] forKey:@"minutes"];
    [myDefaults synchronize];
  }
  else if (hoursBetweenDates > 1.0) { // More than an hour remains
    isSet = NO;
    // Gradient
    orangeGradientLayer.hidden = false;
    blueGradientLayer.hidden = true;
    
    // Set status bar to dark color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    timeUntil.text = [NSString stringWithFormat:@"%.1f hours of daylight left", hoursBetweenDates];
    willSet.text = @"the sun will set at";
    
    [myDefaults setObject:@"NO" forKey:@"isSet"];
    [myDefaults setObject:@"YES" forKey:@"inHours"];
    [myDefaults setObject:@"No" forKey:@"inMinutes"];
    [myDefaults setObject:[NSString stringWithFormat:@"%.1f", hoursBetweenDates] forKey:@"hours"];
    [myDefaults synchronize];
  }
  else { // The sun has set
    isSet = YES;
    // Gradient
    orangeGradientLayer.hidden = true;
    blueGradientLayer.hidden = false;
    
    // Set status bar to light color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    timeUntil.text = [NSString stringWithFormat:@"The sun has set"];
    willSet.text = @"the sun went down at";
    
    [myDefaults setObject:@"YES" forKey:@"isSet"];
    [myDefaults synchronize];
  }
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

// Get's the user's location and then calls getTimeOfSunset and getTimeUntilSunset
// Want to uypdate the information whenever the location is fetched, so I put those method calls here
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  // If it's a relatively recent event, turn off updates to save power.
  location = [locations lastObject];
  NSDate* eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (fabs(howRecent) < 15.0) {
    // If the event is recent, do something with it.
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    latLabel.text = [NSString stringWithFormat:@"Lat: %+.6f", location.coordinate.latitude];
    longLabel.text = [NSString stringWithFormat:@"Long: %+.5f", location.coordinate.longitude];
    [self getTimeOfSunset];
    [self getTimeUntilSunset];
  }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [errorAlert show];
  NSLog(@"Error: %@",error.description);
}

// Starts the locationManager with ALWAYS authorization
-(void) refresh {
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  locationManager.distanceFilter = 500; // meters
  [locationManager requestAlwaysAuthorization];
  [locationManager startUpdatingLocation];
}

// I use this for cases when the app is closed or the background refresh ends
// and the location service needs to be stopped
-(void)stopLocation {
  [locationManager stopUpdatingLocation];
}

// This is for background updates. Needs to be left here, but you can change
// up the code inside as long as it works the same and you leave in the completion handler
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [self refresh];
  [self stopLocation];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  // This code creates the rounded button corners. Can be removed if we decide to
  // remove the button entirely (right now it's just hidden)
  CALayer *btnLayer = [roundedButton layer];
  [btnLayer setMasksToBounds:YES];
  [btnLayer setCornerRadius:5.0f];
  
  // This initializes the myDefaults dictionary. This can be done elsewhere, but
  // it has to be initialized this way.
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  [self setupGradients];
  [self refresh];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
