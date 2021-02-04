//
//  TimeModel.h
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeModel : NSObject

@property(nonatomic,assign)NSInteger minute;
@property(nonatomic,assign)NSInteger second;
@property(nonatomic,assign)NSInteger msecond;

-(NSInteger)isBiggerThan:(TimeModel*) time;
-(NSInteger)isSmallerThan:(TimeModel*) time;
@end

NS_ASSUME_NONNULL_END
