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
  
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  data = [[myDefaults objectForKey:@"newSunriseNotificationsArray"] mutableCopy];
  
  // set up each of the buttons on the page
  for (int i = 1; i < 13; i++) {
    UIButton *currentButton = (UIButton *) [self.view viewWithTag:i];
    
    // set up the borders of the buttons
    customBlueColor = [UIColor colorWithRed:0.167 green:0.623 blue:0.969 alpha:1];
    customWhiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
    currentButton.layer.cornerRadius = 10;
    [currentButton.layer setBorderWidth:2.0f];
    [currentButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    // set the colors for the buttons
    [currentButton setSelected:[[data objectAtIndex:i] boolValue]];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [currentButton setBackgroundColor:([[data objectAtIndex:i] boolValue]) ? customWhiteColor : [UIColor clearColor]];
  }
}

- (void)setGradientBackground:(UIButton*)currentButton; {
  CAGradientLayer *blueGradient;
  blueGradient = [BackgroundLayer buttonGradient];
  blueGradient.frame = currentButton.bounds;
  [currentButton.layer insertSublayer:blueGradient atIndex:0];
  currentButton.clipsToBounds = YES;
}

/**
 * Detects which button was clicked and changes the subsequent setting.
 * @author Nate
 */
- (IBAction)buttonClicked:(id)sender {
  // if the button was selected before
  if ([sender isSelected]) {
    // deselect the button
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:NO]];
    [sender setSelected:NO];
    UIButton *currentButton = (UIButton *)sender;
    [currentButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    // animate the change in colors
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
  // if the button was not selected before
  } else {
    // select the button
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:YES]];
    [sender setSelected:YES];
    UIButton *currentButton = (UIButton *)sender;
    
    // animate the change in colors
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentButton.backgroundColor = customWhiteColor;
    [UIView commitAnimations];
  }
  
  // sync the changes
  [myDefaults setObject:data forKey:@"newSunriseNotificationsArray"];
  [myDefaults synchronize];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // set up the gradient behind the view
  UIImageView *backView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  backView.image = [UIImage imageNamed:@"tableViewBackground"];
  [self.view addSubview:backView];
  [self.view sendSubviewToBack:backView];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];

}

@end
