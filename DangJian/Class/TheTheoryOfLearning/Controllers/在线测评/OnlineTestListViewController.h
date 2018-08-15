//
//  OnlineTestListViewController.h
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseRefreshTableViewController.h"

@interface OnlineTestListViewController : BaseRefreshTableViewController

@property (nonatomic, strong) NSDictionary *configParams;
/**
 事件Id任务ID 查询指定的事项
 */
@property (nonatomic, copy) NSString *missionId;
@end
