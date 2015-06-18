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
  
  blackGradient = [BackgroundLayer blackGradient];
  blackGradient.frame = self.view.bounds;
  [self.view.layer insertSublayer:blackGradient atIndex:0];
  self.navigationController.navigationBarHidden = YES;
}

//- (void)viewWillAppear:(BOOL)animated {
//  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//  originalColor = self.navigationController.navigationBar.barTintColor;
//  originalTentColor = self.navigationController.navigationBar.tintColor;
//  self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//  self.navigationController.navigationBar.translucent = NO;
//  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//  self.navigationController.navigationBar.barTintColor = originalColor;
//  self.navigationController.navigationBar.translucent = YES;
//  self.navigationController.navigationBar.tintColor = originalTentColor;
//}

- (IBAction)dismissCreditsView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
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
