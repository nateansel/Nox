//
//  SunriseNotificationsViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 6/19/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundLayer.h"

@interface SunriseNotificationsViewController : UIViewController {
  NSUserDefaults *myDefaults;
  NSMutableArray *data;
  UIColor *customBlueColor;
  
}

- (IBAction)buttonClicked:(id)sender;
- (void)setGradientBackground:(UIButton*)currentButton;

@end
