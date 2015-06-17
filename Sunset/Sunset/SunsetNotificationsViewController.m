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
    [currentButton setSelected:[[data objectAtIndex:i] boolValue]];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentButton setBackgroundColor:([[data objectAtIndex:i] boolValue]) ? [UIColor grayColor] : [UIColor lightGrayColor]];
  }
}

- (IBAction)buttonClicked:(id)sender {
  if ([sender isSelected]) {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:0]];
    [sender setSelected:NO];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
  } else {
    [data replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithBool:1]];
    [sender setSelected:YES];
    [sender setBackgroundColor:[UIColor grayColor]];
  }
  
  [myDefaults setObject:data forKey:@"newSunsetNotificationsArray"];

  NSLog(@"Button pressed: %@", [sender currentTitle]);
}

@end
