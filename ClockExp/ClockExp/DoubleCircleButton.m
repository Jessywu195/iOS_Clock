//
//  DoubleCircleButton.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/2/2.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//
//define this constant if you want to use Masonry without the 'mas_' prefix
#ifndef MAS_SHORTHAND
#define MAS_SHORTHAND
#endif
//define this constant if you want to enable auto-boxing for default syntax
#ifndef MAS_SHORTHAND_GLOBALS
#define MAS_SHORTHAND_GLOBALS
#endif
#import "DoubleCircleButton.h"
#import "Masonry.h"

@implementation DoubleCircleButton

CGFloat border;
CGFloat btnWidth;
-(instancetype)init{
    if(self = [super init])
    {   //添加backgroundView子控件
        UIView *backgroundView = [[UIView alloc] init];
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;
        
        //设置Button的大小
        CGRect frame = self.frame;
        frame.size = CGSizeMake(btnWidth, btnWidth);
        self.frame = frame;
        
        //设置backgroundView的约束
        [backgroundView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(btnWidth + 2 * border, btnWidth + 2 * border));
            make.center.equalTo(self);
        }];
        
        //设置TitleLabel的约束
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
        
        //设置backgroundView的圆角
        [backgroundView layoutIfNeeded];    //立即更新约束
        backgroundView.layer.cornerRadius = self.backgroundView.frame.size.width / 2.0;
        
        //设置button的圆角
        self.layer.cornerRadius = self.frame.size.width / 2.0;
        self.layer.borderWidth = border;   //设置边缘
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.backgroundView) {
        return self;
    }
//    if (nil == view) {
//        for (UIView *subView in self.subviews) {
//            CGPoint myPoint = [subView convertPoint:point toView:self];
//            if (CGRectContainsPoint(subView.bounds, myPoint)) {
//                return subView;
//            }
//        }
//    }
    return view;
}
@end
