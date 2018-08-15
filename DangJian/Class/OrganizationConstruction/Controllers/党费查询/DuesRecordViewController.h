//
//  DuesRecordViewController.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseRefreshTableViewController.h"
#import "DuesRecordCell.h"
#import "OrganizationOnlinePaymentViewController.h"

@interface DuesRecordViewController : BaseRefreshTableViewController

/**
 用户工号
 */
@property (nonatomic, copy) NSString *workNumber;


/**
 判断是否是缴费进入的
 */
@property (nonatomic, assign) BOOL isPayCost;

@property (nonatomic, strong) DuesVo *duesVo;
/**
 缴费年份
 */
@property (nonatomic, copy) NSString *payCostDate;

- (void)tableViewDidTriggerHeaderRefresh;

@end
