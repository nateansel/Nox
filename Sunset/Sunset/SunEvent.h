//
//  SunEvent.h
//  Sunset
//
//  Created by Nathan Ansel on 5/15/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#ifndef Sunset_SunEvent_h
#define Sunset_SunEvent_h


@import CoreLocation;
#import "KosherCocoa.h"
#import <UIKit/UIKit.h>

@interface SunEvent : NSObject <CLLocationManagerDelegate> {
  KCAstronomicalCalendar *calendar;
  KCGeoLocation *location;
  CLLocation *currentLocation;
  NSUserDefaults *myDefaults;
  NSMutableDictionary *data;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

- (SunEvent *)init;
- (void)locationManager:(CLLocationManager *) manager
        didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error;
- (void)updateCalendar;
- (void)updateLocation;
- (void)stopUpdatingLocation;
- (NSDate *)getTodaySunsetDate;
- (NSDate *)getTodaySunriseDate;
- (NSDate *)getTomorrowSunriseDate;
- (NSDate *)getTomorrowSunsetDate;
- (NSString *)getRiseOrSetTimeString;
- (NSString *)getTimeLeftString: (NSDate *) date;
- (BOOL)hasSunRisenToday;
- (BOOL)hasSunSetToday;
- (double)getLatitude;
- (double)getLongitude;
- (NSMutableDictionary *)updateDictionary;
- (NSDate *)getNextEvent;
- (void)setNotificationsWithSeconds: (int) seconds andSunset: (BOOL) sunset andSunrise: (BOOL) sunrise;
- (NSString *)makeStringFromSeconds: (int) seconds;
- (NSDate *)getNextSunrise;
- (NSDate *)getNextSunset;

@end



#endif
