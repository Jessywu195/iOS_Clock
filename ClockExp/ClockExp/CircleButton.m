//
//  CircleButton.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/26.
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

#import "CircleButton.h"
#import "Masonry.h"

@interface CircleButton()

//@property(nonatomic,strong)UIView * backgroundView;

@end
@implementation CircleButton

CGFloat width;
-(instancetype)init
{
 if(self = [super init])
 {
     CGRect frame = self.frame;
     frame.size = CGSizeMake(width, width);
     self.frame = frame;
     
     self.layer.cornerRadius = self.frame.size.width / 2.0;
     self.layer.borderWidth = 2.f;
     //设置子控件的约束
     [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.centerX);
         make.centerY.equalTo(self.centerY);
     }];
 }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    //设置子控件的位置
//    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.centerX);
//        make.centerY.equalTo(self.centerY);
//    }];
}

/*
 设置button内部子控件title的位置
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 0, 100, 70);
//}
/*
 设置button内部子控件imageView的位置
 */
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(100, 0, 70, 70);
//}



@end
