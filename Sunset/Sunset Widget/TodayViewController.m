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
  
    NSArray *timeDisplaySettings = @[
                                   @{ UIFontFeatureTypeIdentifierKey: @(6),
                                      UIFontFeatureSelectorIdentifierKey: @(1)
                                      },
                                   @{ UIFontFeatureTypeIdentifierKey: @(17),
                                      UIFontFeatureSelectorIdentifierKey: @(1)
                                      }];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:50];
    UIFontDescriptor *originalDescriptor = [font fontDescriptor];
    UIFontDescriptor *timerDescriptor =[originalDescriptor fontDescriptorByAddingAttributes: @{ UIFontDescriptorFeatureSettingsAttribute: timeDisplaySettings }];
    UIFont *timeFont = [UIFont fontWithDescriptor: timerDescriptor size:0.0];
  
    timeLabel.font = timeFont;

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
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  BOOL sunriseNext = YES;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"h:mm a"];
  NSDate *sunEventDate;
  
  for (int i = 0; i < 61; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0
        && [[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow]
           > [[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow]) {
      sunEventDate = [upcomingSunrises objectAtIndex:i];
      sunriseNext = YES;
      break;
    } else if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      sunEventDate = [upcomingSunsets objectAtIndex:i];
      sunriseNext = NO;
      break;
    }
  }
  
  countdown.text = [self getTimeLeftString: sunEventDate];
  timeLabel.text = [dateFormatter stringFromDate:sunEventDate];
  if ([self isSunriseNext]) {
    willSet.text = @"The sun will rise at";
  } else {
    willSet.text = @"The sun will set at";
  }
  
  expired.hidden = YES;
  
  if ([self isExpired]) {
    willSet.hidden = YES;
    timeLabel.hidden = YES;
    countdown.hidden = YES;
    expired.hidden = NO;
  } else {
    willSet.hidden = NO;
    timeLabel.hidden = NO;
    countdown.hidden = NO;
    expired.hidden = YES;
  }
  
  completionHandler(NCUpdateResultNewData);
}

/**
 * Updates the values in myDefaults and returns a string representation of the countdown to the next sun event.
 * @author Nate
 *
 * @return NSString representation of the countdown to the next sun event
 */
- (NSString *)getTimeLeftString:(NSDate *)date {
  // declare some variables
  double tempTimeNum;
  int hours, minutes;
  NSString *minuteString, *riseOrSet;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"h:mm a"];
  
//  if ([self isSunriseNext]) {
//    date = [myDefaults objectForKey:@"nextSunrise"];
//    riseOrSet = @"until the sun rises";
//    [myDefaults setObject:@"The sun will rise at" forKey:@"riseOrSet"];
//  } else {
//    date = [myDefaults objectForKey:@"nextSunset"];
//    riseOrSet = @"of sunlight left";
//    [myDefaults setObject:@"The sun will set at" forKey:@"riseOrSet"];
//  }
                     //
//  [myDefaults setObject:[dateFormatter stringFromDate:date] forKey:@"time"];
//  [myDefaults synchronize];
  
  if ([self isSunriseNext]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
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
  // cycle through both arrays to determine which event is coming next
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  for (int i = 0; i < 61; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0
        && [[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow]
           > [[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow]) {
      return YES;
    } else if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      return NO;
    }
  }
  
  // just to appease the compiler
  return NO;
}

/**
 * Determines if the stored sunrise and sunset data are in the past,
 * and have thus expired.
 *
 * @author Chase
 *
 * @return BOOl if the data is expired
 */
- (BOOL)isExpired {
  // cycle through both arrays to determine which event is coming next
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  if ([[upcomingSunrises objectAtIndex:59] timeIntervalSinceNow] > 0) {
    return NO;
  }
  if ([[upcomingSunsets objectAtIndex:59] timeIntervalSinceNow] > 0) {
    return NO;
  }
  
  return YES;
}

@end
