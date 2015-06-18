//
//  SunsetNotificationsViewController.m
//  Sunset
//
//  Created by Nathan Ansel on 6/17/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "SunsetNotificationsViewController.h"

@implementation SunsetNotificationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  if ([myDefaults objectForKey:@"newSunsetNotificationsArray"] == nil) {
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
                             [NSNumber numberWithBool:0],] forKey:@"newSunsetNotificationsArray"];
  }
  
  data = [[myDefaults objectForKey:@"newSunsetNotificationsArray"] mutableCopy];
  
  for (int i = 1; i < 13; i++) {
    UIButton *currentButton = (UIButton *) [self.view viewWithTag:i];
    
    customBlueColor = [UIColor colorWithRed:0.167 green:0.623 blue:0.969 alpha:1];
    currentButton.layer.cornerRadius = 10;
    [currentButton.layer setBorderWidth:2.0f];
    [currentButton.layer setBorderColor:customBlueColor.CGColor];
    
    [currentButton setSelected:[[data objectAtIndex:i] boolValue]];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [currentButton setTitleColor:customBlueColor forState:UIControlStateNormal];
//    [currentButton setBackgroundColor:([[data objectAtIndex:i] boolValue]) ? customBlueColor : [UIColor whiteColor]];
    
    ([[data objectAtIndex:i] boolValue]) ? [self setGradientBackground:currentButton] : [currentButton setBackgroundColor:[UIColor whiteColor]];
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
    [sender setBackgroundColor:[UIColor whiteColor]];
    UIButton *currentButton = (UIButton *)sender;
//    for (CALayer *layer in [currentButton.layer.sublayers copy]) {
//      [layer removeFromSuperlayer];
//    }
    [[currentButton.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
  } else {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:1]];
    [sender setSelected:YES];
    [self setGradientBackground:sender];
  }
  
  [myDefaults setObject:data forKey:@"newSunsetNotificationsArray"];

  NSLog(@"Button pressed: %@", [sender currentTitle]);
}

@end
