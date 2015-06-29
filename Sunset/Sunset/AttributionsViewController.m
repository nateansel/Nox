//
//  AttributionsViewController.m
//  Sunset
//
//  Created by Chase McCoy on 6/15/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "AttributionsViewController.h"

@implementation AttributionsViewController

- (void)viewDidLoad {
  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"attributions" ofType:@"html"];
  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
  [_webView loadHTMLString:htmlString baseURL:nil];
  
  CALayer *blueGradient = [BackgroundLayer blueGradient];
  blueGradient.frame = self.view.frame;
  [self.view.layer insertSublayer:blueGradient atIndex:0];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

@end
