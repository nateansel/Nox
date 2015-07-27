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
- (SunEvent *)init {
  // Always initialize the superclass
  self =  [super init];
  
  // Set up myDefaults and initialize the data
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  data = [[NSMutableDictionary alloc] init];
  
  // Update the location and calendar immediately
  [self updateLocation];
  [self updateCalendar];
  return self;
}





- (void)locationManager:(CLLocationManager *) manager
     didUpdateLocations:(NSArray *)locations{
  currentLocation = [locations lastObject];
  [self updateCalendar];
  [self updateDictionary];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"location"
                                                        object:nil];
  [data setValue:@"YES" forKey:@"updateColors"];
  
  [data setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] forKey:@"lat"];
  [data setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] forKey:@"long"];
  
  [myDefaults setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] forKey:@"lat"];
  [myDefaults setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] forKey:@"long"];
  [myDefaults synchronize];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView"
                                                      object:nil];
  
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView"
                                                        object:nil];
  }

  // Display error message as a popup alert
  NSLog(@"Error: %@",error.description);
}





/**
 * Update the KCAstronomicalCalendar objects.
 * @author Nate
 */
- (void)updateCalendar {
  // Had to put this stuff here because calendar was coming up nil in the old location
  location = [[KCGeoLocation alloc] initWithLatitude:currentLocation.coordinate.latitude
                                        andLongitude:currentLocation.coordinate.longitude
                                         andTimeZone:[NSTimeZone systemTimeZone]];
  calendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
  calculationsCalendar = [[KCAstronomicalCalendar alloc] initWithLocation:location];
}





/**
 * Updates the location via the locationManager.
 * @author Chase
 */
- (void)updateLocation {
  _locationManager = [[CLLocationManager alloc] init];
  _locationManager.delegate = self;
  _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  _locationManager.distanceFilter = 500; // meters
  [self.locationManager requestAlwaysAuthorization];
  
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"launchView"
                                                        object:nil];
    [data setValue:@"NO" forKey:@"updateColors"];
    [self.locationManager requestAlwaysAuthorization];
  }
  else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
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
  
  
  [self.locationManager startUpdatingLocation];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView"
                                                      object:nil];
}





-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusNotDetermined) {
    [self.locationManager requestAlwaysAuthorization];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noLocation"
                                                        object:nil];
    [data setValue:@"NO" forKey:@"updateColors"];
  }
  else {
    [self.locationManager startUpdatingLocation];
  }
}





/**
 * Tells the locaiton manager to stop updating the location.
 * @author Chase
 */
- (void)stopUpdatingLocation {
  [self.locationManager stopUpdatingLocation];
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
 * Retrieve a NSDate object of tomorrow's sunset.
 * @author Nate
 *
 * @return A NSDate object of tomorrow's sunset
 */
- (NSDate *)getTomorrowSunsetDate {
  [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
  return [calendar sunset];
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
    return [dateFormatter stringFromDate:[self getTodaySunriseDate]];
    
  } else if (![self hasSunSetToday]) {
    // the sun has not set today
    return [dateFormatter stringFromDate:[self getTodaySunsetDate]];
    
  } else {
    // the sun has already set today
    return [dateFormatter stringFromDate:[self getTomorrowSunriseDate]];
  }
}





/**
 * Creates and returns a string representation of the time left until the next sun event.
 * @author Nate
 *
 * @param date A date to compare to the current time/date
 * @return A string representation of the difference in time between now and the date passed in
 */
- (NSString *)getTimeLeftString: (NSDate*) date {
  // declare some variables
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  
  tempTimeNum = [date timeIntervalSinceNow];      // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;             // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  
  // Determine the end of the string
  if (![self hasSunRisenToday] || [self hasSunSetToday]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
  // Determine how to display the minutes
  if (minutes > 45) {
    hours++;                  // Increase the hour variable to compensate for not showing minutes
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




/**
 * Determine if the sun has risen yet or not.
 * @author Nate
 *
 * @return True if the sun has risen today, false otherwise
 */
- (BOOL)hasSunRisenToday {
  return ([[self getTodaySunriseDate] timeIntervalSinceNow] < 0);
}




/**
 * Determine if the sun has set yet or not.
 * @author Nate
 *
 * @return True if the sun has set today, false otherwise
 */
- (BOOL)hasSunSetToday {
  return ([[self getTodaySunsetDate] timeIntervalSinceNow] < 0);
}




/**
 * Returns the current latitude of the user's device
 * @author Nate
 *
 * @return A double of the current latitude of the device.
 */
- (double)getLatitude {
  return currentLocation.coordinate.latitude;
}




/**
 * Returns the current longitude of the user's device
 * @author Nate
 *
 * @return A double of the current longitude of the device.
 */
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




/**
 * Returns the next Sun Event to occur.
 * @author Nate
 *
 * @return A NSDate object of the next sun event
 */
- (NSDate *)getNextEvent {
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
    return nextSunrise;
  }
  return nextSunset;
}





/**
 * Sets notifications before sunsets and sunrises in the future a set amount of seconds before each event
 * @author Nate
 *
 * @param seconds The number of seconds before the sun events which the notificications should be set
 * @param sunset If notifications should be set for sunsets
 * @param sunrise If notificaitons should be set for sunrises
 */
- (void)setNotificationsWithSeconds: (int) seconds andSunset: (BOOL) sunset andSunrise: (BOOL) sunrise {
  [self setNotifications];
}





/**
 * Returns a string representation of an amount of seconds (in hours and minutes).
 * @author Nate
 *
 * @param seconds The number of seconds to convert to a string format
 * @return A NSString object of the seconds converted to hours and minutes - Ex. "2 hours and 30 minutes"
 */
- (NSString *)makeStringFromSeconds: (int) seconds {
  int minutes = seconds / 60;
  int hours = minutes / 60;
  minutes -= (hours * 60);
  
  if (hours == 0) {
    return [NSString stringWithFormat:@"%d minutes", minutes];
  } else {
    if (minutes == 0) {
      if (hours == 1) {
        return @"1 hour";
      } else {
        return [NSString stringWithFormat:@"%d hours", hours ];
      }
    } else {
      if (hours == 1) {
        return [NSString stringWithFormat:@"1 hour and %d minutes", minutes ];
      } else {
        return [NSString stringWithFormat:@"%d hours and %d minutes", hours, minutes ];
      }
    }
  }
}





/**
 * Finds the next sunrise to occur and returns it.
 * @author Nate
 *
 * @return A NSDate object of the next sunrise to occur
 */
- (NSDate *)getNextSunrise {
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSDate *nextSunrise;
  
  // find the next sunrise
  for (int i = 0; i < upcomingSunrises.count; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunrise = [upcomingSunrises objectAtIndex:i];
      break;
    }
  }
  return nextSunrise;
}




/**
 * Finds the next sunset to occur and returns it.
 * @author Nate
 *
 * @return A NSDate object of the next sunrise to occur
 */
- (NSDate *)getNextSunset {
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  NSDate *nextSunset;
  
  // find the next sunset
  for (int i = 0; i < upcomingSunsets.count; i++) {
    if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunset = [upcomingSunsets objectAtIndex:i];
      break;
    }
  }
  return nextSunset;
}




/**
 * Refreshes the values in myDefaults for upcomingSunrises and upcomingSunsets.
 * @author Nate
 */
- (void)refreshUpcomingSunEvents {
  NSLog(@"refreshUpcomingSunEvents");
  
  NSMutableArray *upcomingSunrises = [[NSMutableArray alloc] init];
  NSMutableArray *upcomingSunsets = [[NSMutableArray alloc] init];
  int daysSkipped = 0;      // this variable keeps up with how many days have been
                            //   skipped because of invalidity. These skipped days
                            //   are then added on to the end of the of the array
                            //   so that there are always 60 sun events in each array
  
  
  for (int i = 0; i < (16 + daysSkipped); i++) {
    // if this day is valid, add it to the array
    if ([self isValidSunEventForNumDaysFromNow:i andSunrise:YES]) {
      [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * i)]];
      [upcomingSunrises addObject:[calendar sunrise]];
    } else {
      daysSkipped++;        // increment daysSkipped to account for this skipped day
    }
  }

  daysSkipped = 0;          // reset daysSkipped for use with sunsets
  for (int i = 0; i < (16 + daysSkipped); i++) {
    if ([self isValidSunEventForNumDaysFromNow:i andSunrise:NO]) {
      [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * i)]];
      [upcomingSunsets addObject:[calendar sunset]];
    } else {
      daysSkipped++;
    }
  }
  
  [myDefaults setObject:upcomingSunrises forKey:@"upcomingSunrises"];
  [myDefaults setObject:upcomingSunsets forKey:@"upcomingSunsets"];
  [myDefaults synchronize];
}




/**
 * Checks to see if a sun event for a number of days from today is valid
 * @author Nate
 *
 * @param dayNum The number of days from now to test (positive or negative)
 * @param testSunrise Whether or not you are testing the sunrise
 * @return A boolean value of the validaty of the sun event
 */
- (BOOL)isValidSunEventForNumDaysFromNow: (int) dayNum andSunrise: (BOOL) testSunrise {
//  static int methodCounter = 0;
//  methodCounter++;
//  NSLog(@"isValid %d",methodCounter);
  
  [calendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * dayNum)]];
  
  // if the sunrise and sunset is the same date they are invalid
  if ([[calendar sunrise] isEqualToDate:[calendar sunset]]) {
    return NO;
  }
  
  // set up the calculations calendar for the day before the day testing and a dateformatter
  [calculationsCalendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * (dayNum - 1))]];
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"HH:mm:ss"];
  
  // if you are testing for a sunrise
  if (testSunrise) {
    // test to see if the sunrise for this day matches with the time of the sunset from the day before, if so the day is invalid
    if ([[df stringFromDate:[calendar sunrise]] isEqualToString:[df stringFromDate:[calculationsCalendar sunset]]]) {
      return NO;
    }
    // test to see if the sunrise for this day match with the time for the sunset for the day after, if so the day is invalid
    [calculationsCalendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * (dayNum + 1))]];
    if ([[df stringFromDate:[calendar sunrise]] isEqualToString:[df stringFromDate:[calculationsCalendar sunset]]]) {
      return NO;
    }
  } else {
    // same for if you're testing sunset, compare it to the time of the opposite sun event of the previous day
    if ([[df stringFromDate:[calendar sunset]] isEqualToString:[df stringFromDate:[calculationsCalendar sunrise]]]) {
      return NO;
    }
    // same as above, compare the sunset of today with the sunrise of tomorrow.
    [calculationsCalendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:(86400 * (dayNum + 1))]];
    if ([[df stringFromDate:[calendar sunset]] isEqualToString:[df stringFromDate:[calculationsCalendar sunrise]]]) {
      return NO;
    }
  }
  
  // if you get to this point then it must be a valid sun event
  return YES;
}




/**
 * Cancels all previous notifications and sets the new notifications.
 * @author Nate
 */
- (void)setNotifications {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
  UILocalNotification *notification;
  NSArray *sunriseNotificationsArray = [myDefaults objectForKey:@"newSunriseNotificationsArray"];
  NSArray *sunsetNotificationsArray = [myDefaults objectForKey:@"newSunsetNotificationsArray"];
  NSArray *upcomingSunrise = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunset = [myDefaults objectForKey:@"upcomingSunsets"];
  int sunriseNotificationNum = 0;
  int sunsetNotificationNum = 0;
  if ([myDefaults boolForKey:@"sunriseNotificationSetting"]) {
    for (int i = 1; i < 13; i++) {
      if ([[sunriseNotificationsArray objectAtIndex:i] boolValue]) {
        sunriseNotificationNum++;
      }
    }
  }
  if ([myDefaults boolForKey:@"sunsetNotificationSetting"]) {
    for (int i = 1; i < 13; i++) {
      if ([[sunsetNotificationsArray objectAtIndex:i] boolValue]) {
        sunsetNotificationNum++;
      }
    }
  }
  
  if (sunriseNotificationNum != 0 || sunsetNotificationNum != 0) {
    int numNotificationsPerEvent = 60 / (sunriseNotificationNum + sunsetNotificationNum);
    if (numNotificationsPerEvent > 15) {
      numNotificationsPerEvent = 15;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
    NSString *sunriseTestString = @"Sunrise -- ";
    NSString *sunsetTestString = @"Sunset  -- ";
    
    if ([myDefaults boolForKey:@"sunriseNotificationSetting"]) {
      // for each possible notification
      for (int i = 1; i < 13; i++) {
        // see if it's turned on
        if ([[sunriseNotificationsArray objectAtIndex:i] boolValue]) {
          // if so set the correct number of notifications
          for (int j = 0; j < numNotificationsPerEvent; j++) {
            notification = [[UILocalNotification alloc] init];
            notification.fireDate = [[upcomingSunrise objectAtIndex:j] dateByAddingTimeInterval:(i * 15 * -60)];
            notification.alertBody = [[self makeStringFromSeconds:(i * 15 * 60)] stringByAppendingString:@" until sunrise."];
            notification.soundName = UILocalNotificationDefaultSoundName;
            if ([notification.fireDate timeIntervalSinceNow] > 0) {
              [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
          }
        }
      }
    }
    
    // same logic as before, this time for sunsets
    if ([myDefaults boolForKey:@"sunsetNotificationSetting"]) {
      for (int i = 1; i < 13; i++) {
        if ([[sunsetNotificationsArray objectAtIndex:i] boolValue]) {
          for (int j = 0; j < numNotificationsPerEvent; j++) {
            notification = [[UILocalNotification alloc] init];
            notification.fireDate = [[upcomingSunset objectAtIndex:j] dateByAddingTimeInterval:( i * 15 * -60)];
            notification.alertBody = [[self makeStringFromSeconds:((int) i * 15 * 60)] stringByAppendingString:@" of sunlight left."];
            notification.soundName = UILocalNotificationDefaultSoundName;
            if ([notification.fireDate timeIntervalSinceNow] > 0) {
              [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
          }
        }
      }
    }
    
    // after all notifications have fired remind the user to open the app to continue recieving notifications
    NSDate *fireDate = [notification.fireDate dateByAddingTimeInterval:7200];
    notification = [[UILocalNotification alloc] init];
    notification.fireDate = fireDate;
    notification.alertBody = @"Please open the app to refresh the data and continue receiving notifications.";
    notification.soundName = UILocalNotificationDefaultSoundName;
    if ([notification.fireDate timeIntervalSinceNow] > 0) {
      [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
  }
  
  // update the next time to set notifications
  [myDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:86400] forKey:@"scheduleNotificationsOnDate"];
}

@end


