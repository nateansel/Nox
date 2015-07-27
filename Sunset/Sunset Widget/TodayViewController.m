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
  NSDate *sunEventDate, *nextSunrise, *nextSunset;
  
  // find the next sunrise and the next sunset
  for (int i = 0; i < upcomingSunrises.count; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunrise = [upcomingSunrises objectAtIndex:i];
      break;
    }
  }
  for (int i = 0; i < upcomingSunsets.count; i++) {
    if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunset = [upcomingSunsets objectAtIndex:i];
      break;
    }
  }
  
  // compare the next sunrise against the next sunset to see which comes first
  if ([nextSunrise timeIntervalSinceNow] < [nextSunset timeIntervalSinceNow]) {
    sunEventDate = nextSunrise;
  } else {
    sunEventDate = nextSunset;
  }
  
  countdown.text = [self getTimeLeftString: sunEventDate];
  timeLabel.text = [self getTimeString:sunEventDate];
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
  int days, hours, minutes;
  NSString *dayString, *minuteString, *riseOrSet;
  
  if ([self isSunriseNext]) {
    riseOrSet = @"until the sun rises";
  } else {
    riseOrSet = @"of sunlight left";
  }
  
  tempTimeNum = [date timeIntervalSinceNow];      // the time difference between event and now in seconds
  hours = ((int) tempTimeNum) / 3600;             // integer division with total seconds / seconds per hour
  minutes = (tempTimeNum - (hours * 3600)) / 60;  // integer division with the remaining seconds / seconds per minute
  days = hours / 24;
  hours -= days * 24;
  
  // Determine how many days left
  if (days > 0) {
    dayString = [NSString stringWithFormat:@"%d days ",days];
  } else {
    dayString = @"";
  }
  
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
      return [NSString stringWithFormat:@"%@%d%@ hour %@.", dayString, hours, minuteString, riseOrSet];
    }
    return [NSString stringWithFormat:@"%@%d%@ hours %@.", dayString, hours, minuteString, riseOrSet];
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
  BOOL sunriseNext = YES;
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  NSDate *nextSunrise, *nextSunset;
  
  // find the next sunrise and the next sunset
  for (int i = 0; i < upcomingSunrises.count; i++) {
    if ([[upcomingSunrises objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunrise = [upcomingSunrises objectAtIndex:i];
      break;
    }
  }
  for (int i = 0; i < upcomingSunsets.count; i++) {
    if ([[upcomingSunsets objectAtIndex:i] timeIntervalSinceNow] > 0) {
      nextSunset = [upcomingSunsets objectAtIndex:i];
      break;
    }
  }
  
  // compare the next sunrise against the next sunset to see which comes first
  if ([nextSunrise timeIntervalSinceNow] < [nextSunset timeIntervalSinceNow]) {
    sunriseNext = YES;
  } else {
    sunriseNext = NO;
  }
  
  return sunriseNext;
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
  NSArray *upcomingSunrises = [myDefaults objectForKey:@"upcomingSunrises"];
  NSArray *upcomingSunsets = [myDefaults objectForKey:@"upcomingSunsets"];
  
  // test the last item in both arrays to see if they are in the past
  if ([[upcomingSunrises objectAtIndex:(upcomingSunrises.count - 1)] timeIntervalSinceNow] > 0) {
    return NO;
  }
  if ([[upcomingSunsets objectAtIndex:(upcomingSunrises.count - 1)] timeIntervalSinceNow] > 0) {
    return NO;
  }
  
  // if this point is reached the data is expired
  return YES;
}




/**
 * Returns the time from a date object in a string format.
 * @author Nate
 *
 * @param date A NSDate object of the time to be converted
 * @return A string representation of the time that was converted
 */
- (NSString *)getTimeString:(NSDate *)date {
  NSString *hourString, *minuteString, *amOrPM;
  int hours;
  BOOL isAM = YES;
  unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [calendar components:unitFlags fromDate:date];
  
  // add a 0 to the front of the minutes if it is a single digit (less than 10)
  minuteString = [NSString stringWithFormat:@"%d", (int) [components minute]];
  if ([components minute] < 10) {
    minuteString = [@"0" stringByAppendingString:minuteString];
  }
  
  // format the time for 24h time
  if ([myDefaults boolForKey:@"24h"]) {
    hourString = [NSString stringWithFormat:@"%d", (int) [components hour]];
    if ([components hour] < 10) {
      hourString = [@"0" stringByAppendingString:hourString];
    }
    return [hourString stringByAppendingString:[@":" stringByAppendingString:minuteString]];
  }
  
  // format the time for 12h time
  hours = (int) [components hour];
  minuteString = [NSString stringWithFormat:@"%d", (int) [components minute]];
  if (hours >= 12) {
    hourString = [NSString stringWithFormat:@"%d", hours - 12];
    isAM = NO;
  } else if (hours == 0) {
    hourString = [NSString stringWithFormat:@"%d", 12];
  } else {
    hourString = [NSString stringWithFormat:@"%d", hours];
  }
  amOrPM = (isAM) ? @" AM" : @" PM";
  if ([components minute] < 10) {
    minuteString = [@"0" stringByAppendingString:minuteString];
  }
  
  // return the 12h formated time
  return [hourString stringByAppendingString:[@":" stringByAppendingString:[minuteString stringByAppendingString:amOrPM]]];
}



@end
