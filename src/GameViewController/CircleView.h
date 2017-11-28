//
//  CircleView.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/22/17.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageViewScale)
-(void) scaleAspectFit:(CGFloat) scaleFactor;
@end

@implementation UIImageView (UIImageViewScale)
-(void) scaleAspectFit:(CGFloat) scaleFactor{

}
@end

@interface CircleView : UIView
@property(nonatomic, retain) UIImageView * imageView;
@end
