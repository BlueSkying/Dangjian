//
//  ReportFeedbackModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, ReportFeedbackType) {
    
    /**
     思想汇报页面
     */
    ReportObjectType = 0,
    /**
     工作反馈
     */
    FeedbackObjectType = 1,
};

@interface ReportFeedbackModel : NSObject

/**
 页码
 */
@property (nonatomic, assign) NSInteger pageNo;
/**
 每页条数
 */
@property (nonatomic, assign) NSInteger pageSize;
/**
 全部页码
 */
@property (nonatomic, assign) NSInteger totalPage;

/**
 状态
 */
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *list;
/**
活动地点
 */
@property (nonatomic, copy) NSString *address;
/**
 活动成果或反馈内容
 */
@property (nonatomic, copy) NSString *content;

/**
 汇报人
 */
@property (nonatomic, copy) NSString *username;

/**
 活动时间
 */
@property (nonatomic, copy) NSString *activityDate;
/**
 工作反馈ID或者汇报id
 */
@property (nonatomic, copy) NSString *infoID;
/**
参与人员
 */
@property (nonatomic, copy) NSString *people;
/**
 活动主题或者反馈主题
 */
@property (nonatomic, copy) NSString *subject;
/**
 全部列表
 */
@property (nonatomic, strong) NSMutableArray *listArray;

/**
工作反馈
 
 @param successBlock 成功返回数据位ReportFeedbackModel 类型
 */
- (void)jobFeedbackListMine:(BOOL)mine
                    success:(void(^)(ReportFeedbackModel *result)) successBlock
                     failed:(void(^)(id error)) failedBlock;
/**
 思想汇报
 
 @param successBlock 成功返回数据位ReportFeedbackModel 类型
 */
- (void)thoughtReportListMine:(BOOL)mine
                        success:(void(^)(ReportFeedbackModel *result)) successBlock
                         failed:(void(^)(id error)) failedBlock ;

- (void)reportFeedbackType:(ReportFeedbackType)type
                      mine:(BOOL)mine
                   success:(void(^)(ReportFeedbackModel *result)) successBlock
                    failed:(void(^)(id error)) failedBlock;
@end
