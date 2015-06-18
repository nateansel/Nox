//
//  BackgroundLayer.m
//  Sunset
//
//  Created by Chase McCoy on 5/14/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

// Blue gradient background
+ (CAGradientLayer*) blueGradient {
  
  UIColor *colorOne = [UIColor colorWithRed:0.377 green:0 blue:0.917 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.603 green:0.154 blue:0.699 alpha:1];
  
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
  
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
  
  CAGradientLayer *headerLayer = [CAGradientLayer layer];
  headerLayer.colors = colors;
  headerLayer.locations = locations;
  
  return headerLayer;
}

+ (NSArray*) getColorsForBlueGradient {
  UIColor *colorOne = [UIColor colorWithRed:0.377 green:0 blue:0.917 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.506 green:0.046 blue:0.726 alpha:1];
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  return colors;
}

// Orange gradient background
+ (CAGradientLayer*) orangeGradient {
  
  UIColor *colorOne = [UIColor colorWithRed:1 green:0.813 blue:0.052 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.968 green:0.35 blue:0.009 alpha:1];
  
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
  
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
  
  CAGradientLayer *headerLayer = [CAGradientLayer layer];
  headerLayer.colors = colors;
  headerLayer.locations = locations;
  
  return headerLayer;
}

+ (NSArray*) getColorsForOrangeGradient {
  UIColor *colorOne = [UIColor colorWithRed:1 green:0.907 blue:0.048 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.965 green:0.35 blue:0 alpha:1];
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  return colors;
}

+ (NSArray*) getLocationsForGradient {
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
  return locations;
}

// Black gradient background
+ (CAGradientLayer*) blackGradient {
  
  UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.198 green:0.198 blue:0.198 alpha:1];
  
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
  
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
  
  CAGradientLayer *headerLayer = [CAGradientLayer layer];
  headerLayer.colors = colors;
  headerLayer.locations = locations;
  
  return headerLayer;
}

// Gradient for notification buttons
+ (CAGradientLayer*) buttonGradient {
  UIColor *colorOne = [UIColor colorWithRed:0.333 green:0.674 blue:0.933 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.213 green:0.585 blue:0.868 alpha:1];
  
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
  
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
  
  CAGradientLayer *headerLayer = [CAGradientLayer layer];
  headerLayer.colors = colors;
  headerLayer.locations = locations;
  
  return headerLayer;
}



@end
