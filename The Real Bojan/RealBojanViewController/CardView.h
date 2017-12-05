//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bojan.h"
#import "AppUtils.h"

@interface CardView : UIView
-(instancetype)initWithFrame:(CGRect)frame withBojan:(Bojan *)bojan;
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, strong) Bojan * bojan;
@property (nonatomic,strong) UIImageView * imageView;
@end
