//
//  SunEvent.m
//  Sunset
//
//  Created by Nathan Ansel on 5/15/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SunEvent.h"

@implementation SunEvent

- (SunEvent*)init {
  // Always initialize the superclass
  self =  [super init];
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  if (data == nil) {
    data = [[NSMutableDictionary alloc] init];
  }
  [self updateLocation];
  [self updateCalendar];
  return self;
}

- (void)locationManager:(CLLocationManager*) manager
        didUpdateLocations:(NSArray *)locations{
  currentLocation = [locations lastObject];
  NSDate* eventDate = currentLocation.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  [self updateCalendar];
  [self updateDictionary];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
}

- (void)locationManager:(CLLocationManager*)manager
        didFailWithError:(NSError *)error {
  UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                message:@"There was an error retrieving your location"
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
  // Display error message as a popup alert
  [errorAlert show];
  NSLog(@"Error: %@",error.description);
}

- (void)updateCalendar {
  // Had to put this stuff here because calendar was coming up nil in the old location
  location = [[KCGeoLocation alloc] initWithLatitude:currentLocation.coordinate.latitude
                                        andLongitude:currentLocation.coordinate.longitude
                                         andTimeZone:[NSTimeZone systemTimeZone]];
  calendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
  sunrise = [calendar sunrise];
  sunset = [calendar sunset];

}

- (void)updateLocation {
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  locationManager.distanceFilter = 500; // meters
  [locationManager requestAlwaysAuthorization];
  [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
  [locationManager stopUpdatingLocation];
}

- (NSDate*)getTodaySunsetDate {
  [calendar setWorkingDate:[NSDate date]];
  sunset = [calendar sunset];
  return sunset;
}

- (NSDate*)getTodaySunriseDate {
  [calendar setWorkingDate:[NSDate date]];
  sunrise = [calendar sunrise];
  return sunrise;
}

- (NSDate*)getTomorrowSunriseDate {
  [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
  sunrise = [calendar sunrise];
  return sunrise;
}

- (NSString*)getRiseOrSetTimeString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"h:mm a"];
  
  if (![self hasSunRisenToday]) {
    // the sun hasn't risen today
    return [NSString stringWithFormat:@"%@",
            [dateFormatter stringFromDate:[self getTodaySunriseDate]]];
    
  } else if (![self hasSunSetToday]) {
    // the sun has not set today
    return [NSString stringWithFormat:@"%@",
            [dateFormatter stringFromDate:[self getTodaySunsetDate]]];
    
  } else {
    // the sun has already set today
    return [NSString stringWithFormat:@"%@",
            [dateFormatter stringFromDate:[self getTomorrowSunriseDate]]];
  }
}

- (NSString*)getTimeLeftString: (NSDate*) date {
  // declare some variables
  double tempTimeNum;
  int hours, minutes, totalMinutes;
  NSString *minuteString, *riseOrSet;
  
  tempTimeNum = [date timeIntervalSinceNow];  // the time difference between event and now in seconds
  hours = tempTimeNum / 3600;  // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  totalMinutes = tempTimeNum / 60;
  
  if (![self hasSunRisenToday] || [self hasSunSetToday]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
  if (minutes > 45) {
    minuteString = @"";
  } else if (minutes > 30) {
    minuteString = @"¾";
  } else if (minutes > 15) {
    minuteString = @"½";
  } else if (minutes > 5 ){
    minuteString = @"¼";
  } else {
    minuteString = @"";
  }

  
  if (hours >= 1) {
    return [NSString stringWithFormat:@"%d%@ hours %@.", hours, minuteString, riseOrSet];
  }
  
  return [NSString stringWithFormat:@"%d minutes %@", totalMinutes, riseOrSet];
}

- (BOOL)hasSunRisenToday {
  return ([[self getTodaySunriseDate] timeIntervalSinceNow] < 0);
}

- (BOOL)hasSunSetToday {
  return ([[self getTodaySunsetDate] timeIntervalSinceNow] < 0);
}

- (double)getLatitude {
  return currentLocation.coordinate.latitude;
}

- (double)getLongitude {
  return currentLocation.coordinate.longitude;
}

- (NSMutableDictionary*)updateDictionary {
  NSDate *tempDate;
  NSString *riseOrSet;
  NSString *isSet;
  
  if (![self hasSunRisenToday]) {
    // the sun hasn't risen today
    tempDate = [self getTodaySunriseDate];
    riseOrSet = @"The sun will rise at";
    isSet = @"YES";
  } else if (![self hasSunSetToday]) {
    // the sun has not set today
    tempDate = [self getTodaySunsetDate];
    riseOrSet = @"The sun will set at";
    isSet = @"NO";
  } else {
    // the sun has set today
    tempDate = [self getTomorrowSunriseDate];
    riseOrSet = @"The sun will rise at";
    isSet = @"YES";
  }
  
  [data setObject:[self getRiseOrSetTimeString] forKey:@"time"];
  [data setObject:[self getTimeLeftString: tempDate] forKey:@"timeLeft"];
  [data setObject:riseOrSet forKey:@"riseOrSet"];
  [data setObject:isSet forKey:@"isSet"];
  
  [myDefaults setObject:[self getRiseOrSetTimeString] forKey:@"time"];
  [myDefaults setObject:[self getTimeLeftString: tempDate] forKey:@"timeLeft"];
  [myDefaults setObject:riseOrSet forKey:@"riseOrSet"];
  [myDefaults setObject:isSet forKey:@"isSet"];
  [myDefaults synchronize];
  
  return data;
}

@end


