//
//  AppUtils.m
//  Flipper
//
//  Created by Todd Vanderlin on 4/25/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

// ---------------------------------------------------------------
// random min/max
// ---------------------------------------------------------------
+ (CGFloat)clamp:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
    return value < min ? min : value > max ? max : value;
}

// ---------------------------------------------------------------
// random min/max
// ---------------------------------------------------------------
+ (CGFloat)random:(CGFloat)x y:(CGFloat)y {
	float high = 0;
	float low  = 0;
	float randNum = 0;
	// if there is no range, return the value
	if (x == y) return x;// float == ?, wise? epsilon?
	high = MAX(x,y);
	low = MIN(x,y);
	randNum = low + ((high-low) * arc4random()/(RAND_MAX + 1.0));
	return randNum;
}

+(CGFloat)randomf {
    return arc4random() % 11 * 0.1;
}

// ---------------------------------------------------------------
// random max
// ---------------------------------------------------------------
+ (CGFloat)random:(CGFloat)max {
	return max * arc4random() / (RAND_MAX + 1.0f);
}

// ---------------------------------------------------------------
// random color
// ---------------------------------------------------------------
+ (UIColor*)randomColor {
    return [UIColor colorWithRed:[AppUtils random:1] green:[AppUtils random:1] blue:[AppUtils random:1] alpha:1];
}
@end














