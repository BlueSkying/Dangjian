//
//  ToDoListModel.h
//  DangJian
//
//  Created by Sakya on 17/5/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_OPTIONS(NSInteger, ToDoType) {
    
    //    新闻列表
    ToDoTypeNews = 0,
    //在线考试
    ToDoTypeOnlineExam = 1,
    //在线缴费
    ToDoTypeOnlinePayCost,
    //工作反馈
    ToDoTypeJobFeedBack,
    //民主评议
    ToDoTypeDemocraticAppraisal,
    //在线投票
    ToDoTypeOnlineVote,
    //思想汇报
    ToDoTypeOnlineThoughtReports,
    
};
@interface ToDoListModel : NSObject

@property (nonatomic, strong) NSMutableArray *totalArray;


@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSArray *list;
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

/**主题*/
@property (nonatomic, copy) NSString *subject;
/**缴费月份*/
@property (nonatomic, copy) NSString *year;
/**type*/
@property (nonatomic, copy) NSString *type;
/**
 事件Id任务ID
 */
@property (nonatomic, copy) NSString *missionId;
/**待办事项ID*/
@property (nonatomic, copy) NSString *toDoId;
/**截止日期*/
@property (nonatomic, copy) NSString *doDate;

@property (nonatomic, assign) ToDoType pageType;
/**
 事件的title
 */
@property (nonatomic, copy) NSString *titleType;

/**
 需要跳转的class
 */
@property (nonatomic, copy) NSString *className;

- (void)toDoListIsHeader:(BOOL)isHeader
                 success:(void(^)(ToDoListModel *result)) successBlock
                  failed:(void(^)(id error)) failedBlock;


@end
