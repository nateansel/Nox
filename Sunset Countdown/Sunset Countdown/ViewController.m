//
//  ViewController.m
//  Sunset Countdown
//
//  Created by Nathan Ansel on 5/12/15.
//  Copyright (c) 2015 Nathan Ansel. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

- (void)updateView {
  [sunEvent updateLocation];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"h:mm a"];
  
  if (![sunEvent hasSunRisenToday]) {
    NSDate *todaySunrise = [sunEvent getTodaySunrise];
    sunsetOrSunriseLabel.text = @"The sun will rise at:";
    timeLabel.text = [dateFormatter stringFromDate:todaySunrise];
    timeUntilSunEvent.text = [self getTimeDifference:todaySunrise];
  } else if (![sunEvent hasSunSetToday]) {
    // the sun has not set today
    NSDate *todaySunset = [sunEvent getTodaySunset];
    sunsetOrSunriseLabel.text = @"The sun will set at:";
    timeLabel.text = [dateFormatter stringFromDate:todaySunset];
    timeUntilSunEvent.text = [self getTimeDifference:todaySunset];
  } else {
    // the sun has already set today
    NSDate *tomorrowSunrise = [sunEvent getTomorrowSunrise];
    sunsetOrSunriseLabel.text = @"The sun will rise tomorrow at:";
    timeLabel.text = [dateFormatter stringFromDate:tomorrowSunrise];
    timeUntilSunEvent.text = [self getTimeDifference:tomorrowSunrise];
  }
  
  lat.text = [NSString stringWithFormat:@"%.6f", [sunEvent getLatitude]];
  lon.text = [NSString stringWithFormat:@"%.6f", [sunEvent getLongitude]];
}


- (NSString*) getTimeDifference: (NSDate*) date {
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  
  tempTimeNum = [date timeIntervalSinceNow];
  hours = tempTimeNum / 3600;
  minutes = (tempTimeNum - (hours * 3600)) / 60;
  
  if (![sunEvent hasSunRisenToday] || [sunEvent hasSunSetToday]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sun left";
  }
  
  if (hours > 0) {
    if (minutes > 45) {
      minuteString = @"";
    } else if (minutes > 30) {
      minuteString = @"¾";
    } else if (minutes > 15) {
      minuteString = @"½";
    } else {
      minuteString = @"¼";
    }
    
    return [NSString stringWithFormat:@"%d%@ hours %@.", hours, minuteString, riseOrSet];
  }
  
  return [NSString stringWithFormat:@"%d minutes %@", minutes, riseOrSet];
}

- (IBAction)buttonPressed:(id)sender {
  [self updateView];
}



- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  sunEvent = [[SunEvent alloc] init];
  [self updateView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
