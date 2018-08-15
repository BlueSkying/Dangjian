//
//  OnlineTestOptionsCell.h
//  DangJian
//
//  Created by Sakya on 17/5/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineTestOptionsVo.h"

@interface OnlineTestOptionsCell : UITableViewCell



/**
 被选中选项
 */
@property (nonatomic, assign) BOOL selectedOption;

@property (nonatomic, strong) OnlineTestOptionsVo *optionVo;


@end
