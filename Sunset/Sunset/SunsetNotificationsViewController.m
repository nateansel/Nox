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
  
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  if ([myDefaults objectForKey:@"newSunsetNotificationsArray"] == nil) {
    [myDefaults setObject:@[ [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],] forKey:@"newSunsetNotificationsArray"];
  }
  
  data = [[myDefaults objectForKey:@"newSunsetNotificationsArray"] mutableCopy];
  
  for (int i = 1; i < 13; i++) {
    UIButton *currentButton = (UIButton *) [self.view viewWithTag:i];
    
    customBlueColor = [UIColor colorWithRed:0.167 green:0.623 blue:0.969 alpha:1];
    customWhiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
    currentButton.layer.cornerRadius = 10;
    [currentButton.layer setBorderWidth:2.0f];
    [currentButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [currentButton setSelected:[[data objectAtIndex:i] boolValue]];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [currentButton setBackgroundColor:([[data objectAtIndex:i] boolValue]) ? customWhiteColor : [UIColor clearColor]];
    
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
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:NO]];
    [sender setSelected:NO];
    UIButton *currentButton = (UIButton *)sender;
    //[[currentButton.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    [currentButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
  } else {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:YES]];
    [sender setSelected:YES];
    //[self setGradientBackground:sender];
    UIButton *currentButton = (UIButton *)sender;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = customWhiteColor;
    [UIView commitAnimations];
  }
  
  [myDefaults setObject:data forKey:@"newSunsetNotificationsArray"];

  NSLog(@"Button pressed: %@", [sender currentTitle]);
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  UIImageView *backView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  backView.image = [UIImage imageNamed:@"tableViewBackground"];
  [self.view addSubview:backView];
  [self.view sendSubviewToBack:backView];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];
  
}

@end
