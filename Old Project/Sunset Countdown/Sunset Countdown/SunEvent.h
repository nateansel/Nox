//
//  SunEvent.h
//  Sunset Countdown
//
//  Created by Nathan Ansel on 5/14/15.
//  Copyright (c) 2015 Nathan Ansel. All rights reserved.
//

//#ifndef Sunset_Countdown_SunEvent_h
//#define Sunset_Countdown_SunEvent_h

#import <CoreLocation/CoreLocation.h>
#import "KosherCocoa.h"
#import <UIKit/UIKit.h>


@interface SunEvent : NSObject {
  CLLocationManager *locationManager;
  KCAstronomicalCalendar *astronomicalCalendar;
  KCGeoLocation *currentGeoLocation;
  CLLocation *currentLocation;
}

- (SunEvent*) init;
- (void) locationManager:(CLLocationManager*) manager
      didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError *)error;
- (void)updateLocation;
- (NSDate*)getTodaySunset;
- (NSDate*)getTodaySunrise;
- (NSDate*)getTomorrowSunrise;
- (BOOL)hasSunRisenToday;
- (BOOL)hasSunSetToday;
- (double)getLatitude;
- (double)getLongitude;

@end

//#endif
