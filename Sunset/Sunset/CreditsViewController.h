//
//  CreditsViewController.h
//  Sunset
//
//  Created by Chase McCoy on 6/14/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BackgroundLayer.h"

@interface CreditsViewController : UIViewController {
  CAGradientLayer *blackGradient;
  UIColor *originalBarColor;
  UIColor *originalTentColor;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)dismissCreditsView:(id)sender;
- (IBAction)websiteURL:(id)sender;
- (IBAction)chaseTwitter:(id)sender;
- (IBAction)nathanTwitter:(id)sender;

@end
