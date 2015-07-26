//
//  ViewController.m
//  Sunset
//
//  Created by Chase McCoy on 5/12/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (IBAction)getLocation:(id)sender {
  [self refresh];
}

- (void)updateView:(NSNotification *) notification {
  NSMutableDictionary *data = [sunEventObject updateDictionary];
  
  timeLabel.text = [data objectForKey:@"time"];
  NSLog(@"*****%@*****\n", [data objectForKey:@"time"]);
  timeUntil.text = [data objectForKey:@"timeLeft"];
  willSet.text = [data objectForKey:@"riseOrSet"];
  
  bool isSet = [[data objectForKey:@"isSet"] boolValue];
  
  if (isSet) {
    orangeGradientLayer.hidden = true;
    blueGradientLayer.hidden = false;
    // Set status bar to light color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
  }
  else {
    orangeGradientLayer.hidden = false;
    blueGradientLayer.hidden = true;
    // Set status bar to dark color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
  }
}

// Sets up the gradient layers
- (void)setupGradients {
  orangeGradientLayer = [BackgroundLayer orangeGradient];
  blueGradientLayer = [BackgroundLayer blueGradient];
  orangeGradientLayer.frame = self.view.bounds;
  blueGradientLayer.frame = self.view.bounds;
  [self.view.layer insertSublayer:orangeGradientLayer atIndex:0];
  [self.view.layer insertSublayer:blueGradientLayer atIndex:1];
  
  blueGradientLayer.hidden = true;
  orangeGradientLayer.hidden = false;
}

// Starts the locationManager with ALWAYS authorization
-(void) refresh {
  [sunEventObject updateLocation];
  [sunEventObject updateDictionary];
  // [self updateView:nil];
}

// I use this for cases when the app is closed or the background refresh ends
// and the location service needs to be stopped
-(void)stopLocation {
  [sunEventObject stopUpdatingLocation];
}

// This is for background updates. Needs to be left here, but you can change
// up the code inside as long as it works the same and you leave in the completion handler
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [self refresh];
  [self stopLocation];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  // This code creates the rounded button corners. Can be removed if we decide to
  // remove the button entirely (right now it's just hidden)
  CALayer *btnLayer = [roundedButton layer];
  [btnLayer setMasksToBounds:YES];
  [btnLayer setCornerRadius:5.0f];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"refreshView" object:nil];
  
  if (sunEventObject == NULL) {
    sunEventObject = [[SunEvent alloc] init];
  }
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  [self setupGradients];
  [self refresh];
  
  // [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
