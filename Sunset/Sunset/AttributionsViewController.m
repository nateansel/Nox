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
  [super viewDidLoad];
//  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"attributions" ofType:@"html"];
//  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//  
//  NSString *path = [[NSBundle mainBundle] bundlePath];
//  NSURL *baseURL = [NSURL fileURLWithPath:path];
//  [_webView loadHTMLString:htmlString baseURL:baseURL];
//  
//  CALayer *blueGradient = [BackgroundLayer blueGradient];
//  blueGradient.frame = self.view.frame;
//  [self.view.layer insertSublayer:blueGradient atIndex:0];
//  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground" ] forBarMetrics:UIBarMetricsDefault];
//  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"attributions" ofType:@"html"];
  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
  
  NSString *path = [[NSBundle mainBundle] bundlePath];
  NSURL *baseURL = [NSURL fileURLWithPath:path];
  [_webView loadHTMLString:htmlString baseURL:baseURL];
}

@end
