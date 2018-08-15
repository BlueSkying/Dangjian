//
//  ThoughtReportsEditViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "ReportFeedbackModel.h"

@interface ThoughtReportsEditViewController : BaseViewController
/**
 是否是新增进入的
 */
@property (nonatomic, assign) BOOL isEdit;
/**
 如果有数据的时候
 */
@property (nonatomic, strong) ReportFeedbackModel *reportFeedbackVo;
/**
 如果是从待办事项进入的需要待办事项id
 */
@property (nonatomic, copy) NSString *backlogId;

@property (nonatomic, copy) void(^addReportFeedvackSuccessBlock)();

@end
