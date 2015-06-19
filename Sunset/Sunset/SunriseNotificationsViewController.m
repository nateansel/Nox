//
//  SunriseNotificationsViewController.m
//  Sunset
//
//  Created by Nathan Ansel on 6/19/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "SunriseNotificationsViewController.h"

@implementation SunriseNotificationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  if ([myDefaults objectForKey:@"newSunriseNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],
                             [NSNumber numberWithBool:0],] forKey:@"newSunriseNotificationsArray"];
  }
  
  data = [[myDefaults objectForKey:@"newSunriseNotificationsArray"] mutableCopy];
  
  for (int i = 1; i < 13; i++) {
    UIButton *currentButton = (UIButton *) [self.view viewWithTag:i];
    
    customBlueColor = [UIColor colorWithRed:0.167 green:0.623 blue:0.969 alpha:1];
    currentButton.layer.cornerRadius = 10;
    [currentButton.layer setBorderWidth:2.0f];
    [currentButton.layer setBorderColor:customBlueColor.CGColor];
    
    [currentButton setSelected:[[data objectAtIndex:i] boolValue]];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [currentButton setTitleColor:customBlueColor forState:UIControlStateNormal];
    [currentButton setBackgroundColor:([[data objectAtIndex:i] boolValue]) ? customBlueColor : [UIColor whiteColor]];
    
    //    ([[data objectAtIndex:i] boolValue]) ? [self setGradientBackground:currentButton] : [currentButton setBackgroundColor:[UIColor whiteColor]];
  }
}

- (void)setGradientBackground:(UIButton*)currentButton; {
  CAGradientLayer *blueGradient;
  blueGradient = [BackgroundLayer buttonGradient];
  blueGradient.frame = currentButton.bounds;
  [currentButton.layer insertSublayer:blueGradient atIndex:0];
  currentButton.clipsToBounds = YES;
}

- (IBAction)buttonClicked:(id)sender {
  if ([sender isSelected]) {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:0]];
    [sender setSelected:NO];
    UIButton *currentButton = (UIButton *)sender;
    //[[currentButton.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    [currentButton.layer setBorderColor:customBlueColor.CGColor];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = [UIColor whiteColor];
    [UIView commitAnimations];
  } else {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:1]];
    [sender setSelected:YES];
    //[self setGradientBackground:sender];
    UIButton *currentButton = (UIButton *)sender;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = customBlueColor;
    [UIView commitAnimations];
  }
  
  [myDefaults setObject:data forKey:@"newSunriseNotificationsArray"];
  
  NSLog(@"Button pressed: %@", [sender currentTitle]);
}

@end
