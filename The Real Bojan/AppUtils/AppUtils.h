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

#pragma mark - NSMutableArray
//--------------------------------------------------------------
// NSMutableArray Extensions
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

#pragma mark - UIView
//--------------------------------------------------------------
// UIView Extensions
//--------------------------------------------------------------
@interface UIView (UIViewExtension)

-(void)translate:(CGPoint)position;
-(void)translateX:(CGFloat)x;
-(void)translateY:(CGFloat)y;
-(void)centerInView:(UIView*)other;

-(CALayer*)getSublayerNamed:(NSString*)name;
-(CGPoint) getTopRight;
-(CGPoint) getTopLeft;
-(CGPoint) getBottomRight;
-(CGPoint) getBottomLeft;

-(CGFloat) getRight;
-(CGFloat) getLeft;
-(CGFloat) getBottom;
-(CGFloat) getTop;

-(CGPoint) getMiddleRight;
-(CGPoint) getMiddleLeft;

-(CALayer*)addTopBorder:(UIColor*)color;
-(CALayer*)addBottomBorder:(UIColor*)color;
-(CALayer*)addRightBorder:(UIColor*)color;
-(CALayer*)addLeftBorder:(UIColor*)color;
-(void)removeLayerName:(NSString*)name;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;

-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)fadeToAlpha:(CGFloat)alpha speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock;
-(void)translateTo:(CGPoint)position speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock;
@end
@implementation UIView (UIViewExtension)
-(void)fadeToAlpha:(CGFloat)alpha speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock {
	[UIView animateWithDuration:speed delay:delay options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
		self.alpha = alpha;
	} completion:^(BOOL fin) {
		if(completeBlock) completeBlock();
	}];
}
-(void)translateTo:(CGPoint)position speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock {
	CGRect r = self.frame;
	r.origin = position;
	[UIView animateWithDuration:speed delay:delay options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
		self.frame = r;
	} completion:^(BOOL fin) {
		if(completeBlock) completeBlock();
	}];
}
-(void)translate:(CGPoint)position {
	CGRect r = self.frame;
	r.origin = position;
	self.frame = r;
}
-(void)translateX:(CGFloat)x {
	CGRect r = self.frame;
	r.origin = CGPointMake(x, r.origin.y);
	self.frame = r;
}
-(void)translateY:(CGFloat)y {
	CGRect r = self.frame;
	r.origin = CGPointMake(r.origin.x, y);
	self.frame = r;
}

-(void)centerInView:(UIView*)other {
	[self translate:CGPointMake((other.frame.size.width-self.frame.size.width)/2, (other.frame.size.height-self.frame.size.height)/2)];
}
-(CALayer*) getSublayerNamed:(NSString *)name {
	for(CALayer * ca in self.layer.sublayers) {
		if([ca.name isEqualToString:name]) return ca;
	}
	return nil;
}
-(void)removeLayerName:(NSString *)name {
	for(CALayer * ca in self.layer.sublayers) {
		if([ca.name isEqualToString:name]) [ca removeFromSuperlayer];
	}
}
-(CGPoint) getTopLeft {
	return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}
-(CGPoint) getBottomLeft {
	return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}
-(CGPoint) getTopRight {
	return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y);
}
-(CGPoint) getBottomRight {
	return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+self.frame.size.height);
}
-(CGPoint) getMiddleRight {
	return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+(self.frame.size.height/2));
}
-(CGPoint) getMiddleLeft {
	return CGPointMake(self.frame.origin.x, self.frame.origin.y+(self.frame.size.height/2));
}
-(CGFloat) getBottom {
	return self.frame.origin.y+self.frame.size.height;
}
-(CGFloat) getTop {
	return self.frame.origin.y;
}
-(CGFloat) getRight {
	return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat) getLeft {
	return self.frame.origin.x;
}

-(CALayer*) addTopBorder:(UIColor*)color {
	CALayer * stroke = [CALayer layer];
	[stroke setName:@"top_border_stoke"];
	for(CALayer * ca in self.layer.sublayers) {
		if([ca.name isEqualToString:@"top_border_stroke"]) [ca removeFromSuperlayer];
	}
	stroke.frame = CGRectMake(0, 0, self.frame.size.width, 1);
	stroke.backgroundColor = color.CGColor;
	[self.layer addSublayer:stroke];
	return stroke;
}
-(CALayer*) addBottomBorder:(UIColor*)color {
	CALayer * stroke = [CALayer layer];
	[stroke setName:@"bottom_border_stoke"];
	for(CALayer * ca in self.layer.sublayers) {
		if([ca.name isEqualToString:@"bottom_border_stoke"]) [ca removeFromSuperlayer];
	}
	stroke.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
	stroke.backgroundColor = color.CGColor;
	[self.layer addSublayer:stroke];
	return stroke;
}
-(CALayer*) addRightBorder:(UIColor*)color {
	CALayer * stroke = [CALayer layer];
	[stroke setName:@"right_border_stoke"];
	NSArray * ar = self.layer.sublayers;
	if(ar) {
		for(int i=0; i<ar.count; i++) {
			CALayer * ca = [ar objectAtIndex:i];
			if(ca && [ca.name isEqualToString:@"right_border_stoke"]) [ca removeFromSuperlayer];
		}
	}
	stroke.frame = CGRectMake(self.frame.size.width, 0, 1, self.frame.size.height);
	stroke.backgroundColor = color.CGColor;
	[self.layer addSublayer:stroke];
	return stroke;
}
-(CALayer*) addLeftBorder:(UIColor*)color {
	CALayer * stroke = [CALayer layer];
	[stroke setName:@"left_border_stoke"];
	for(CALayer * ca in self.layer.sublayers) {
		if([ca.name isEqualToString:@"left_border_stoke"]) [ca removeFromSuperlayer];
	}
	stroke.frame = CGRectMake(0, 0, 1, self.frame.size.height);
	stroke.backgroundColor = color.CGColor;
	[self.layer addSublayer:stroke];
	return stroke;
}
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height {
	CGRect rec = self.frame;
	rec.size = CGSizeMake(width, height);
	self.frame = rec;
}
-(void)setWidth:(CGFloat)width {
	[self setWidth:width andHeight:self.frame.size.height];
}
-(void)setHeight:(CGFloat)height {
	[self setWidth:self.frame.size.width andHeight:height];
}

@end
