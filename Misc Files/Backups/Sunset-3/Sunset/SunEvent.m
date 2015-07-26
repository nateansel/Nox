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

/**
 * Set up the instance of SunEvent, update the location and calendar.
 * @author Nate
 *
 * @return A newly created SunEvent instance
 */
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
  [self updateCalendar];
  [self updateDictionary];

  // ISSUE: Need to run this notication every minute. Probably will have to use a timer
  // If I do use a timer, maybe just updateView in the timer?
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView"
                                        object:nil];
  
  [data setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] forKey:@"lat"];
  [data setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude]forKey:@"long"];
}

- (void)locationManager:(CLLocationManager*)manager
        didFailWithError:(NSError *)error {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
      || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noLocation"
                                                        object:nil];
    [data setValue:@"NO" forKey:@"updateColors"];
  }
  else {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"There was an error retrieving your location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
    [errorAlert show];
  }

  // Display error message as a popup alert
  NSLog(@"Error: %@",error.description);
}

/**
 * Update the KCAstronomicalCalendar object.
 * @author Nate
 */
- (void)updateCalendar {
  // Had to put this stuff here because calendar was coming up nil in the old location
  location = [[KCGeoLocation alloc] initWithLatitude:currentLocation.coordinate.latitude
                                    andLongitude:currentLocation.coordinate.longitude
                                    andTimeZone:[NSTimeZone systemTimeZone]];
  calendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
}

/**
 * Updates the location via the locationManager.
 * @author Nate
 */
- (void)updateLocation {
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  locationManager.distanceFilter = 500; // meters
  [locationManager requestAlwaysAuthorization];
  
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
      || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noLocation"
                                                        object:nil];
    [data setValue:@"NO" forKey:@"updateColors"];
  }
  else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"location"
                                                        object:nil];
    [data setValue:@"YES" forKey:@"updateColors"];
  }
  
  [locationManager startUpdatingLocation];
}

/**
 * Tells the locaiton manager to stop updating the location.
 * @author Nate
 */
- (void)stopUpdatingLocation {
  [locationManager stopUpdatingLocation];
}

/**
 * Retrieve a NSDate object of today's sunset.
 * @author Nate
 *
 * @return A NSDate object of today's sunset
 */
- (NSDate *)getTodaySunsetDate {
  [calendar setWorkingDate:[NSDate date]];
  return [calendar sunset];
}

/**
 * Retrieve a NSDate object of today's sunrise.
 * @author Nate
 *
 * @return A NSDate object of today's sunrise
 */
- (NSDate *)getTodaySunriseDate {
  [calendar setWorkingDate:[NSDate date]];
  return [calendar sunrise];
}

/**
 * Retrieve a NSDate object of tomorrow's sunrise.
 * @author Nate
 *
 * @return A NSDate object of tomorrow's sunrise
 */
- (NSDate *)getTomorrowSunriseDate {
  [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
  return [calendar sunrise];
}

/**
 * Retreve the time that the sun will either rise or set at.
 * @author Nate
 *
 * @return A string representation of the time the sun will rise or set in the "h:mm a" format
 */
- (NSString *)getRiseOrSetTimeString {
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

/**
 * Creates and returns a string representation of the time left until the next sun event.
 * @author Nate
 *
 * @param A date to compare to the current time/date
 * @return A string representation of the difference in time between now and the date passed in
 */
- (NSString *)getTimeLeftString: (NSDate*) date {
  // declare some variables
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  
  tempTimeNum = [date timeIntervalSinceNow];  // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;  // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  
  if (![self hasSunRisenToday] || [self hasSunSetToday]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
  // Determine how to display the minutes
  if (minutes > 45) {
    // Increase the hour variable to compensate for not showing minutes
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
      return [NSString stringWithFormat:@"%d%@ hour %@.", hours, minuteString, riseOrSet];
    }
    return [NSString stringWithFormat:@"%d%@ hours %@.", hours, minuteString, riseOrSet];
  }
  
  // If the sunrise or sunset is about to happen
  if (minutes < 5) {
    if (![self hasSunRisenToday] || [self hasSunSetToday]) {
      return @"Sunrise is imminent";
    } else {
      return @"Sunset is imminent";
    }
  }
  
  // If there is less than an hour but more than 4 minutes left before the sunrise or sunset
  return [NSString stringWithFormat:@"%d minutes %@", minutes, riseOrSet];
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

/**
 * Creates a temporary dictionary with values pertaining to information about sunrise and sunset times.
 * @author Nate
 *
 * @return A dictionary with time, timeLeft, riseOrSet, and isSet values
 */
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

- (NSDate *)getNextEvent {
  if (![self hasSunRisenToday]) {
    // the sun hasn't risen today
    return [self getTodaySunriseDate];
  } else if (![self hasSunSetToday]) {
    // the sun has not set today
    return [self getTodaySunsetDate];
  } else {
    // the sun has set today
    return [self getTomorrowSunriseDate];
  }
}

- (void)setNotificationsWithSeconds: (int) seconds andSunset: (BOOL) sunset andSunrise: (BOOL) sunrise {
  UILocalNotification *notification;
  int sunriseStartDate, sunsetStartDate;
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
  NSString *sunriseTestString = @"Sunrise -- ";
  NSString *sunsetTestString = @"Sunset  -- ";
  
  // Determines the first day on which a notification will be scheduled
  // 0 = today
  // 1 = tomorrow
  if (![self hasSunRisenToday] && ([[self getTodaySunriseDate] timeIntervalSinceNow] > 3600)) {
    sunriseStartDate = 0;
  } else {
    sunriseStartDate = 1;
  }
    
  if (![self hasSunSetToday] && ([[self getTodaySunsetDate] timeIntervalSinceNow] > 3600)) {
    sunsetStartDate = 0;
  } else {
    sunsetStartDate = 1;
  }
  
  if (sunrise) {
    for (int i = sunriseStartDate; i < 30; i++) {
      notification = [[UILocalNotification alloc] init];
      [calendar setWorkingDate:[[NSDate date] dateByAddingTimeInterval:(86400 * i)]];
      notification.fireDate = [[calendar sunrise] dateByAddingTimeInterval:-seconds];
      notification.alertBody = [[self makeStringFromSeconds:seconds] stringByAppendingString:@" until sunrise."];
      notification.soundName = UILocalNotificationDefaultSoundName;
      [[UIApplication sharedApplication] scheduleLocalNotification:notification];
      NSLog([sunriseTestString stringByAppendingString:[dateFormatter stringFromDate:[[calendar sunrise] dateByAddingTimeInterval:-seconds]]]);
    }
  }
  
  if (sunset) {
    for (int j = sunsetStartDate; j < 30; j++) {
      notification = [[UILocalNotification alloc] init];
      [calendar setWorkingDate:[[NSDate date] dateByAddingTimeInterval:(86400 * j)]];
      notification.fireDate = [[calendar sunset] dateByAddingTimeInterval:-seconds];
      notification.alertBody = [[self makeStringFromSeconds:seconds] stringByAppendingString:@" of sunlight left."];
      notification.soundName = UILocalNotificationDefaultSoundName;
      [[UIApplication sharedApplication] scheduleLocalNotification:notification];
      NSLog([sunsetTestString stringByAppendingString:[dateFormatter stringFromDate:[[calendar sunset] dateByAddingTimeInterval:-seconds]]]);
    }
  }
}

- (NSString *)makeStringFromSeconds: (int) seconds {
  int minutes = seconds / 60;
  
  if (minutes < 60) {
    return [NSString stringWithFormat:@"%d minutes", minutes];
  } else if (minutes == 60) {
    return @"1 hour";
  }
  return [NSString stringWithFormat:@"1 hour and %d minutes",(minutes - 60)];
}

@end


