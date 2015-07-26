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
  
  timeLabel.text = [myDefaults objectForKey:@"date"];
  
  bool isSet = [[myDefaults objectForKey:@"isSet"] boolValue];
  bool inHours = [[myDefaults objectForKey:@"inHours"] boolValue];
  bool inMinutes = [[myDefaults objectForKey:@"inMinutes"] boolValue];
  
  if (isSet) {
    willSet.text = @"the sun went down at";
    [countdown setHidden:YES];
  }
  else {
    willSet.text = @"the sun will set at";
    if (inHours) {
      countdown.text = [NSString stringWithFormat:@"%@ hours of daylight left", [myDefaults objectForKey:@"hours"]];
    }
    else if (inMinutes) {
      countdown.text = [NSString stringWithFormat:@"%@ minutes of daylight left", [myDefaults objectForKey:@"minutes"]];
    }
  }

    completionHandler(NCUpdateResultNewData);
}

@end
