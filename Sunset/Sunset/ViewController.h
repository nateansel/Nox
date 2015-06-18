//
//  ViewController.h
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundLayer.h"
#import "SunEvent.h"

@interface ViewController : UIViewController {
  IBOutlet UILabel *timeLabel;
  IBOutlet UILabel *timeUntil;
  IBOutlet UILabel *willSet;
  IBOutlet UILabel *noLocation;
  
  NSUserDefaults *myDefaults;
  
  CALayer* orangeGradientLayer;
  CALayer* blueGradientLayer;
  
  // SunEvent object that contains all the code for calculating sunset/sunrise
  // times as well as the location of the device
  SunEvent *sunEventObject;
}

// Starts the location service
- (void)refresh;

// Stops the location service
- (void)stopLocation;

- (void)updateView:(NSNotification *) notification;

- (void)locationWarning;
- (void)noLocationWarning;

// Initialize the gradient layers
- (void)setupGradients;

// This is for background updates
- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (BOOL)getNotificationSetting;
- (void)setNotifications;
- (void)setupLaunchView;

- (void)refreshNotifications;
- (NSString *)getTimeString:(NSDate *)date;

@end

