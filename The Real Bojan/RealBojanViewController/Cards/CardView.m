//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(instancetype)initWithFrame:(CGRect)frame withBojan:(Bojan *)bojan {
	self = [super initWithFrame:frame];
	
	if (self) {
		
		
		self.bojan = bojan;
		self.isReal = bojan.isReal;
		
		self.backgroundColor = [AppUtils randomColor];
		
		UIImage * image = [UIImage imageNamed:self.bojan.imageName];
		NSLog(@"loading image %@", image);
		
		self.imageView = [[UIImageView alloc] initWithImage:image];
		self.imageView.frame = CGRectMake(0, 0, FrameWidth, FrameHeight);
		self.imageView.alpha = 1;
		self.imageView.userInteractionEnabled = NO;
		
		[self addSubview:self.imageView];
		
		[self setup];
		
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Corner Radius
    self.layer.cornerRadius = 10.0;
	self.imageView.layer.cornerRadius = 10;
	self.imageView.clipsToBounds = YES;
}

@end
