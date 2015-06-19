//
//  CreditsViewController.m
//  Sunset
//
//  Created by Chase McCoy on 6/14/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "CreditsViewController.h"

@implementation CreditsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
}

- (void)viewWillAppear:(BOOL)animated {
  blackGradient = [BackgroundLayer blackGradient];
  blackGradient.frame = self.view.bounds;
  [self.view.layer insertSublayer:blackGradient atIndex:0];
  
  [self.navigationController.navigationBar setHidden:YES];
//  originalBarColor = self.navigationController.navigationBar.barTintColor;
//  [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//  [self.navigationController.navigationBar setTranslucent:NO];
//  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
//
//- (void)viewDidDisappear:(BOOL)animated {
//  [super viewDidDisappear:animated];
//  
//  [self.navigationController.navigationBar setBarTintColor:originalBarColor];
//  [self.navigationController.navigationBar setTranslucent:YES];
//  [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:0.47843137254901963 blue:1 alpha:1]];
//  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//  [super viewWillDisappear:animated];
//  [self.navigationController.navigationBar setBarTintColor:originalBarColor];
//  [self.navigationController.navigationBar setTranslucent:YES];
//  [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:0.47843137254901963 blue:1 alpha:1]];
//  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//}

- (IBAction)dismissCreditsView:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)websiteURL:(id)sender {
  NSURL *url = [[NSURL alloc] initWithString: @"http://cosmicowl.co" ];
  [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)chaseTwitter:(id)sender {
  NSURL *url = [[NSURL alloc] initWithString: @"http://twitter.com/chase_mccoy"];
  [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)nathanTwitter:(id)sender {
  NSURL *url = [[NSURL alloc] initWithString: @"http://twitter.com/nathan3o4"];
  [[UIApplication sharedApplication] openURL:url];
}

@end
