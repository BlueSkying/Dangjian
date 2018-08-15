//
//  DuesRecordCell.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuesVo.h"

@interface DuesRecordContentView : UIView
/**
 缴费日期
 */
@property (nonatomic, strong) UILabel *dateLabel;
/**
 待缴党费
 */
@property (nonatomic, strong) UILabel *toBePaidLabel;

/**
 已缴党费
 */
@property (nonatomic, strong) UILabel *alreadyPayLabel;
@end

@interface DuesRecordCell : UITableViewCell

@property (nonatomic, strong) DuesVo *duesVo;
@end
