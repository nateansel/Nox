//
//  TodayViewController.m
//  Sunset Widget
//
//  Created by Chase McCoy on 5/13/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
  return UIEdgeInsetsZero;
}

- (IBAction)openApp:(id)sender {
  NSURL *appURL = [NSURL URLWithString:@"sunset://"];
  [self.extensionContext openURL:appURL completionHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
  // Perform any setup necessary in order to update the view.
  
  // If an error is encountered, use NCUpdateResultFailed
  // If there's no update required, use NCUpdateResultNoData
  // If there's an update, use NCUpdateResultNewData
  
  countdown.text = [self getTimeLeftString];
  timeLabel.text = [myDefaults objectForKey:@"time"];
  willSet.text = [myDefaults objectForKey:@"riseOrSet"];
  
  if ([self isExpired]) {
    countdown.text = @"Open the app to refresh.";
  }
  else {
    countdown.text = [self getTimeLeftString];
    //countdown.text = @"Open the app to refresh.";
  }
  
  completionHandler(NCUpdateResultNewData);
}

/**
 * Updates the values in myDefaults and returns a string representation of the countdown to the next sun event.
 * @author Nate
 *
 * @return NSString representation of the countdown to the next sun event
 */
- (NSString *)getTimeLeftString {
  // declare some variables
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  NSDate *date;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"h:mm a"];
  
  if ([self isSunriseNext]) {
    date = [myDefaults objectForKey:@"nextSunrise"];
    riseOrSet = @"until the sun rises";
    [myDefaults setObject:@"The sun will rise at" forKey:@"riseOrSet"];
  } else {
    date = [myDefaults objectForKey:@"nextSunset"];
    riseOrSet = @"of sunlight left";
    [myDefaults setObject:@"The sun will set at" forKey:@"riseOrSet"];
  }
  
  [myDefaults setObject:[dateFormatter stringFromDate:date] forKey:@"time"];
  [myDefaults synchronize];
  
  tempTimeNum = [date timeIntervalSinceNow];      // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;             // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  
  // Determine how to display the minutes
  if (minutes > 45) {
    // Increase the hour variable to compensate for not showing minutes (rounding up an hour)
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
  
  // If the sunrise or sunset is about to happen (4 or less minutes to event)
  if (minutes < 5) {
    if ([self isSunriseNext]) {
      return @"Sunrise is imminent";
    } else {
      return @"Sunset is imminent";
    }
  }
  
  // If there is less than an hour but more than 4 minutes left before the sunrise or sunset
  return [NSString stringWithFormat:@"%d minutes %@", minutes, riseOrSet];
}

/**
 * Determines if a sunrise is the next sun event to occur.
 * @author Nate
 *
 * @return BOOL if the sunrise is next
 */
- (BOOL)isSunriseNext {
  // make sure nextSunrise is in the future
  // make sure nextSunrise is closer to present than nextSunset
  // if both of those conditions are met, then the next sun event to occur is sunrise
  return ([[myDefaults objectForKey:@"nextSunrise"] timeIntervalSinceNow] > 0)
         && [[myDefaults objectForKey:@"nextSunset"] timeIntervalSinceNow] >
            [[myDefaults objectForKey:@"nextSunrise"] timeIntervalSinceNow];
}

/**
 * Determines if the stored sunrise and sunset data are in the past,
 * and have thus expired.
 *
 * @author Chase
 *
 * @return BOOL if the data is expired
 */
- (BOOL)isExpired {
  return ([[myDefaults objectForKey:@"nextSunrise"] timeIntervalSinceNow] < 0)
          && ([[myDefaults objectForKey:@"nextSunset"] timeIntervalSinceNow] < 0);
}

@end
