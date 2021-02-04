//
//  RecordModel.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import "RecordModel.h"
#import "TimeModel.h"

@implementation RecordModel

- (instancetype)init
{
    if (self = [super init]) {
        self.count = 1;
        self.recordColor = [UIColor whiteColor];
        self.timeRecord = [[TimeModel alloc]init];
    }
    return self;
}

-(void)setTimeRecord:(TimeModel *)timeRecord
{
    _timeRecord = timeRecord;
    _timeRecord.minute = timeRecord.minute;
    _timeRecord.second = timeRecord.second;
    _timeRecord.msecond = timeRecord.msecond;
}



@end
