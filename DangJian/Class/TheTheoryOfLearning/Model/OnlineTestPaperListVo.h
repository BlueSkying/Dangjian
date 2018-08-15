//
//  OnlineTestPaperListVo.h
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, OnlineTestPaperType) {
    
    //    试卷列表
    OnlineTestExaminationPaperType = 0,
    //历史成绩
    OnlineTestPaperHistoryScoreType
};

@interface OnlineTestPaperListVo : NSObject

@property (nonatomic, strong) NSMutableArray *totalArray;


@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSArray *list;



/**有效时间*/
@property (nonatomic, copy) NSString *expire;
/**试卷描述*/
@property (nonatomic, copy) NSString *content;
/**通过分数 或是否通过 */
@property (nonatomic, copy) NSString *pass;
/**试卷id*/
@property (nonatomic, copy) NSString *examinationPaperId;
/**可考次数*/
@property (nonatomic, assign) NSInteger times;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**时长（分钟）*/
@property (nonatomic, assign) NSInteger duration;
//试卷类型：DS("党史"),DZ("党章党规"),XLJH("系列讲话"),LLTS("理论推送"),ZXXX("在线学习")
@property (nonatomic, copy) NSString *type;
/**是否有效*/
@property (nonatomic, assign) BOOL isexpire;
//页面类型
@property (nonatomic, assign) OnlineTestPaperType cellType;

//考试成绩特有
/**
 考试日期
 */
@property (nonatomic, copy) NSString *examDate;
/**
 试卷名称
 */
@property (nonatomic, copy) NSString *examName;
/**
 得分
 */
@property (nonatomic, copy) NSString *value;



/**
 考试试卷列表

 @param isHeaderRefresh 刷新还是加载
 @param type 试卷类型

 */
- (void)examListIsHeaderRefresh:(BOOL)isHeaderRefresh
                           type:(NSString *)type
                      missionId:(NSString *)missionId
                        success:(void(^)(OnlineTestPaperListVo *result)) successBlock
                         failed:(void(^)(id error)) failedBlock;

/**
 考试历史成绩列表

 @param isHeaderRefresh 刷新还是加载
 */
- (void)examHistoryScoreListIsHeaderRefresh:(BOOL)isHeaderRefresh
                        success:(void(^)(OnlineTestPaperListVo *result)) successBlock
                         failed:(void(^)(id error)) failedBlock;
@end
