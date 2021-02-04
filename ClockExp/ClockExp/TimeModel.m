//
//  TimeModel.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

-(instancetype)init
{
    if (self = [super init]) {
        _minute = 0;
        _second = 0;
        _msecond = 0;
    }
    return self;
}

-(NSInteger)isBiggerThan:(TimeModel*) time
{
    if(self.minute > time.minute)       //minute  >
    {
        return YES;
    }
    if (self.minute < time.minute) {    //minute <
        return NO;
    }
    //minute =
    if (self.second > time.second) {    //second >
        return YES;
    }
   
    if (self.second < time.second) {    //second <
        return NO;
    }
    //second =
    if (self.msecond > time.msecond) {  //msecond >
        return YES;
    }
    if (self.msecond < time.msecond) {    //second <
        return NO;
    }
    //TODO 相等
    return -1;
}

-(NSInteger)isSmallerThan:(TimeModel*) time
{
    if(self.minute < time.minute)       //minute  >
    {
        return YES;
    }
    if (self.minute > time.minute) {    //minute <
        return NO;
    }
    //minute =
    if (self.second < time.second) {    //second >
        return YES;
    }
    
    if (self.second > time.second) {    //second <
        return NO;
    }
    //second =
    if (self.msecond < time.msecond) {  //msecond >
        return YES;
    }
    if (self.msecond > time.msecond) {    //second <
        return NO;
    }
    //TODO 相等
    return -1;
}



@end
