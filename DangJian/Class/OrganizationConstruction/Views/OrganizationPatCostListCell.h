//
//  OrganizationPatCostListCell.h
//  DangJian
//
//  Created by Sakya on 2017/6/20.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuesVo.h"


@protocol OrganizationPatCostListCellDelegate <NSObject>

- (void)payCostListCellDuesVo:(DuesVo *)duesVo;

@end

@interface OrganizationPatCostListCell : UITableViewCell

@property (nonatomic, strong) DuesVo *duesVo;

@property (nonatomic, weak) id<OrganizationPatCostListCellDelegate>delegate;

@end
