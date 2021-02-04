//
//  MyCell.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/28.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import "RecordCell.h"
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "RecordModel.h"
#import "Masonry.h"
#import "TimeModel.h"

#define CELL_MARGIN 10
extern CGFloat cellEdgeOffset;

@interface RecordCell ()

@property(nonatomic,weak)UILabel * recordCount;
@property(nonatomic,weak)UILabel * timeLabel;
//@property(nonatomic,strong)RecordModel * cellData;

@end


@implementation  RecordCell

UIColor *backgroundColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *recordCount = [[UILabel alloc] init];
        UILabel *timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:recordCount];
        [self.contentView addSubview:timeLabel];
        self.recordCount = recordCount;
        self.timeLabel = timeLabel;
        
        self.userInteractionEnabled = NO;//禁止与用户交互
        //计次位置约束
        [recordCount makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(cellEdgeOffset);
            make.centerY.equalTo(self.contentView);
        }];

        timeLabel.font = [UIFont monospacedDigitSystemFontOfSize:17 weight:UIFontWeightRegular];    //设置timeLabel的字体大小
        
        //timeLabel位置约束
        [timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-cellEdgeOffset);
            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(100);
//            make.height.equalTo(recordCount);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;    //设置cell无法选中
//        self.contentView.backgroundColor = backgroundColor;         //设置contenView的背景颜色
        self.backgroundColor = backgroundColor;                     //设置tableView的背景颜色
    }
    
    return self;
}

- (void)setCellData:(RecordModel *)cellData {
    _cellData = cellData;
    
    self.recordCount.text = [NSString stringWithFormat:@"计次 %ld",_cellData.count];
    self.recordCount.textColor = cellData.recordColor;
    
    self.timeLabel.text =  [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld", _cellData.timeRecord.minute, _cellData.timeRecord.second, _cellData.timeRecord.msecond];
    self.timeLabel.textColor = cellData.recordColor;
}

@end
