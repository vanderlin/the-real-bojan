//
//  AppUtils.h
//  Flipper
//
//  Created by Todd Vanderlin on 4/25/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ViewWidth (self.view.frame.size.width)
#define ViewHeight (self.view.frame.size.height)
#define BasicBlock void (^)(void)

// ----------------------------------------------------------------
@interface AppUtils : NSObject
+ (CGFloat)random:(CGFloat)max;
+ (CGFloat)random:(CGFloat)x y:(CGFloat)y;
+ (CGFloat)randomf;
+ (UIColor*)randomColor;
@end

#pragma mark - NSArray
//--------------------------------------------------------------
// NSArray Extensions
//--------------------------------------------------------------
@interface NSArray (NSArrayExtensions)
- (id)randomObject;
+ (NSArray*)shuffledArray:(NSArray *)array;
@end
@implementation NSArray (NSArrayExtensions)
+ (NSArray *)shuffledArray:(NSArray *)array
{
	return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		if (arc4random() % 2) {
			return NSOrderedAscending;
		} else {
			return NSOrderedDescending;
		}
	}];
}
-(id)randomObject {
	if ([self count] == 0) {
		return nil;
	}
	return [self objectAtIndex: arc4random() % [self count]];
}
@end
