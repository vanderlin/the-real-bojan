//
//  CircleView.m
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/22/17.
//

#import "CircleView.h"

@implementation CircleView

-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	float w = frame.size.width;
	
	CGRect rect = CGRectMake(50, 50, 100, 100);
	UIView *mask = [[UIView alloc] initWithFrame:rect];
	mask.backgroundColor = UIColor.whiteColor;
	mask.layer.cornerRadius = CGRectGetHeight(rect) / 2;
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
	_imageView.image = [UIImage imageNamed:@"Artboard.png"];
	_imageView.layer.cornerRadius = w/2;
//	_imageView.maskView = mask;
	_imageView.layer.masksToBounds = YES;
	_imageView.layer.borderWidth = 0;
//	[_imageView scaleAspectFit:10];
	self.layer.cornerRadius = frame.size.width/2;
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	self.layer.borderWidth = 8;
	self.backgroundColor = [UIColor redColor];
	[self addSubview:_imageView];
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
