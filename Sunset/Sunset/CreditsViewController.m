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
  [super viewWillAppear:animated];
  blackGradient = [BackgroundLayer blueGradient];
  blackGradient.frame = self.view.frame;
  [self.view.layer insertSublayer:blackGradient atIndex:0];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

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
