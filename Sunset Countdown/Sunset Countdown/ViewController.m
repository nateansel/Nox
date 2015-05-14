//
//  ViewController.m
//  Sunset Countdown
//
//  Created by Nathan Ansel on 5/12/15.
//  Copyright (c) 2015 Nathan Ansel. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  double tempTimeNum;
  int hours, minutes;
  
  // If it's a relatively recent event, turn off updates to save power.
  CLLocation* location = [locations lastObject];
  NSDate* eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (fabs(howRecent) < 15.0) {
    // If the event is recent, do something with it.
//    NSLog(@"latitude %+.6f, longitude %+.6f\n",
//          location.coordinate.latitude,
//          location.coordinate.longitude);
    lat.text = [NSString stringWithFormat:@"%+.6f", location.coordinate.latitude];
    lon.text = [NSString stringWithFormat:@"%+.6f", location.coordinate.longitude];
    
    GeoLocation* currentLocation = [[GeoLocation alloc] initWithName:@"CURRENT"
                                     andLatitude:location.coordinate.latitude
                                     andLongitude:location.coordinate.longitude
                                     andTimeZone:[NSTimeZone systemTimeZone]];
    AstronomicalCalendar* astronomicalCalendar = [[AstronomicalCalendar alloc]
                                                   initWithLocation:currentLocation];
    NSDate *sunset = [astronomicalCalendar sunset];
    NSDate *todaySunrise = [astronomicalCalendar sunrise];
    
    astronomicalCalendar.workingDate = [NSDate dateWithTimeIntervalSinceNow:kSecondsInADay*1];
    NSDate *tomorrowSunrise = [astronomicalCalendar sunrise];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    if ([todaySunrise timeIntervalSinceNow] > 0) {
      // the sun has not risen today
      sunsetOrSunriseLabel.text = @"The sun will rise at:";
      timeLabel.text = [dateFormatter stringFromDate:todaySunrise];
      tempTimeNum = [todaySunrise timeIntervalSinceNow];
      hours = tempTimeNum / 3600;
      minutes = (tempTimeNum - (hours * 3600)) / 60;
      timeUntilSunEvent.text = [NSString stringWithFormat:@"%d:%d until the sun rises.", hours, minutes];
    } else if ([sunset timeIntervalSinceNow] > 0) {
      // the sun has not set today
      sunsetOrSunriseLabel.text = @"The sun will set at:";
      timeLabel.text = [dateFormatter stringFromDate:sunset];
      tempTimeNum = [sunset timeIntervalSinceNow];
      hours = tempTimeNum / 3600;
      minutes = (tempTimeNum - (hours * 3600)) / 60;
      timeUntilSunEvent.text = [NSString stringWithFormat:@"%d:%d until the sun sets.", hours, minutes];
    } else {
      // the sun has already set today
      sunsetOrSunriseLabel.text = @"The sun will rise tomorrow at:";
      timeLabel.text = [dateFormatter stringFromDate:tomorrowSunrise];
      tempTimeNum = [tomorrowSunrise timeIntervalSinceNow];
      hours = tempTimeNum / 3600;
      minutes = (tempTimeNum - (hours * 3600)) / 60;
      timeUntilSunEvent.text = [NSString stringWithFormat:@"%d:%d until the sun rises.", hours, minutes];
    }
  }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                              message:@"There was an error retrieving your location"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
  [errorAlert show];
  NSLog(@"Error: %@",error.description);
}

- (IBAction)buttonPressed:(id)sender {
  [locationManager startUpdatingLocation];
}



- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  locationManager.distanceFilter = 500; // meters
  [locationManager requestWhenInUseAuthorization];
  [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
