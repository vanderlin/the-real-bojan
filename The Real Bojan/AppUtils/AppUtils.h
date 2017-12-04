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
#define FrameWidth (self.frame.size.width)
#define FrameHeight (self.frame.size.height)

#define BasicBlock void(^)(void)

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
@interface NSMutableArray (NSMutableArrayExtensions)
- (id)randomObject;
- (void)shuffle;
@end
@implementation NSMutableArray (NSMutableArrayExtensions)
- (void)shuffle {
	NSUInteger count = [self count];
	if (count <= 1) return;
	for (NSUInteger i = 0; i < count - 1; ++i) {
		NSInteger remainingCount = count - i;
		NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
		[self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
	}
}
-(id)randomObject {
	if ([self count] == 0) {
		return nil;
	}
	return [self objectAtIndex: arc4random() % [self count]];
}
@end
