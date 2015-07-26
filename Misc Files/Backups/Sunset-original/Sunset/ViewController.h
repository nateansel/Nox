//
//  ViewController.h
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KosherCocoa.h"
#import "BackgroundLayer.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
  // Is the sun set?
  BOOL isSet;
  
  // These labeles display lat and long, which are hidden in the app right now
  // they can be removed, but make sure to delete them from the storyboard if you do
  IBOutlet UILabel *latLabel;
  IBOutlet UILabel *longLabel;
  
  // Displays the time of the sunset
  IBOutlet UILabel *timeLabel;
  
  // Time until the sun sets
  IBOutlet UILabel *timeUntil;
  
  // "the sun will set at" or "the sun went down at"
  IBOutlet UILabel *willSet;
  
  // Outlet for the refresh button, which is currently hidden on the storyboard
  __weak IBOutlet UIButton *roundedButton;
  
  // These hold the time for the sunrise and sunset
  NSDate *sunrise;
  NSDate *sunset;
  
  // This object is a dictionary that holds data to be shared with the today widget
  NSUserDefaults *myDefaults;
  
  // Location stuff
  CLLocationManager *locationManager;
  CLLocation* location;
  
  // These layers hold the pretty gradienrs
  CALayer* orangeGradientLayer;
  CALayer* blueGradientLayer;
}

// This method refreshes when the button us pressed
- (IBAction)getLocation:(id)sender;

// Starts the location service
- (void)refresh;

// Stops the location service
- (void)stopLocation;

// Gets time of sunset, updates the timeLabel, and adds the time to myDefaults
- (void)getTimeOfSunset;

// This one is a beast. It calculates the remaining daylight, and then updates
// timeUntil, willSet, myDefaults, and also switches the gradients and status bar colors
- (void)getTimeUntilSunset;

// Initialize the gradient layers
- (void)setupGradients;

// Setup location stuff
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

// This is for background updates
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;


@end

