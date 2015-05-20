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
  
  bool isSet = [[myDefaults objectForKey:@"isSet"] boolValue];
  
  timeLabel.text = [myDefaults objectForKey:@"time"];
  willSet.text = [myDefaults objectForKey:@"riseOrSet"];
  countdown.text = [self getTimeLeftString: [myDefaults objectForKey:@"nextSunEvent"]];
  
  if (isSet) {
    [countdown setHidden:NO];
  }
  
    completionHandler(NCUpdateResultNewData);
}

- (NSString *)getTimeLeftString: (NSString *) nextTimeString {
  // Set up the date formatter to change the string to a NSDate object for proper calculations
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
  
  // declare some variables
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  NSDate *nextSunEvent = [formatter dateFromString:nextTimeString];
  
  tempTimeNum = [nextSunEvent timeIntervalSinceNow];  // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;  // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  
  if ([[myDefaults objectForKey:@"isSet"] boolValue]) {
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
    if ([[myDefaults objectForKey:@"isSet"] boolValue]) {
      return @"Sunrise is imminent";
    } else {
      return @"Sunset is imminent";
    }
  }
  
  // If there is less than an hour but more than 4 minutes left before the sunrise or sunset
  return [NSString stringWithFormat:@"%d minutes %@", minutes, riseOrSet];
}

@end
