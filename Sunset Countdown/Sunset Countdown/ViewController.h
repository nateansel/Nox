//
//  ViewController.h
//  Sunset Countdown
//
//  Created by Nathan Ansel on 5/12/15.
//  Copyright (c) 2015 Nathan Ansel. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "AstronomicalCalendar.h"
#import "GeoLocation.h"

@interface ViewController : UIViewController {
  IBOutlet UILabel *lat;
  IBOutlet UILabel *lon;
  IBOutlet UILabel *timeLabel;
  IBOutlet UILabel *sunsetOrSunriseLabel;
  IBOutlet UILabel *timeUntilSunEvent;
  CLLocationManager *locationManager;
}

- (IBAction)buttonPressed:(id)sender;
- (void) locationManager:(CLLocationManager*) manager
      didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager*)manager
      didFailWithError:(NSError *)error;

@end
