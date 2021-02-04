//
//  RecordModel.h
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TimeModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecordModel : NSObject

@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)TimeModel * timeRecord;
@property(nonatomic,strong)UIColor * recordColor;

@end

NS_ASSUME_NONNULL_END
