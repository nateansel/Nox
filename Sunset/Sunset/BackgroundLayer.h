//
//  BackgroundLayer.h
//  Sunset
//
//  Created by Chase McCoy on 5/14/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundLayer : NSObject

+ (CAGradientLayer*) blueGradient;
+ (CAGradientLayer*) orangeGradient;
+ (CAGradientLayer*) blackGradient;

+ (NSArray*) getColorsForBlueGradient;
+ (NSArray*) getColorsForOrangeGradient;

+ (NSArray*) getLocationsForGradient;

@end
