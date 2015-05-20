//
//  sunEvent.m
//  Sunset Countdown
//
//  Created by Nathan Ansel on 5/14/15.
//  Copyright (c) 2015 Nathan Ansel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SunEvent.h"

@implementation SunEvent

- (SunEvent*) init {
  self = [super init];
  NSLog(@"init");
  [self updateLocation];
  return self;
}

- (void)locationManager:(CLLocationManager*) manager
     didUpdateLocations:(NSArray*) locations {
  // If it's a relatively recent event, turn off updates to save power.
  currentLocation = [locations lastObject];
  NSDate* eventDate = currentLocation.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (fabs(howRecent) < 15.0) {
    // If the event is recent, do something with it.
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          currentLocation.coordinate.latitude,
          currentLocation.coordinate.longitude);
    
    currentGeoLocation = [[KCGeoLocation alloc] initWithLatitude:currentLocation.coordinate.latitude
                                                    andLongitude:currentLocation.coordinate.longitude
                                                     andTimeZone:[NSTimeZone systemTimeZone]];
    astronomicalCalendar = [[KCAstronomicalCalendar alloc]
                            initWithLocation:currentGeoLocation];
  }
}

- (void)locationManager: (CLLocationManager*) manager
       didFailWithError: (NSError*) error {
  UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                      message:@"There was an error retrieving your location"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
  // Display error message as a popup alert
  [errorAlert show];
  NSLog(@"Error: %@",error.description);
}

- (void) updateLocation {
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  locationManager.distanceFilter = 500; // meters
  [locationManager requestWhenInUseAuthorization];
  [locationManager startUpdatingLocation];
}

- (NSDate*) getTodaySunset {
  [astronomicalCalendar setWorkingDate:[NSDate date]];
  return [astronomicalCalendar sunset];
}

- (NSDate*)getTodaySunrise {
  [astronomicalCalendar setWorkingDate:[NSDate date]];
  return [astronomicalCalendar sunrise];
}

- (NSDate*)getTomorrowSunrise {
  [astronomicalCalendar setWorkingDate:[NSDate dateWithTimeIntervalSinceNow:86400*1]];
  return [astronomicalCalendar sunrise];
}

- (BOOL)hasSunRisenToday {
  return ([[self getTodaySunrise] timeIntervalSinceNow] < 0);
}

- (BOOL)hasSunSetToday {
  return ([[self getTodaySunset] timeIntervalSinceNow] < 0);
}

- (double) getLatitude {
  return currentLocation.coordinate.latitude;
}

- (double) getLongitude {
  return currentLocation.coordinate.longitude;
}

@end
















