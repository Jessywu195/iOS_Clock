//
//  MyCell.h
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecordCell : UITableViewCell

@property(nonatomic,strong)RecordModel * cellData;

@end

NS_ASSUME_NONNULL_END
