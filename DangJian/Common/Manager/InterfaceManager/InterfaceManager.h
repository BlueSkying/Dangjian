//
//  InterfaceManager.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkLib.h"

typedef NS_OPTIONS(NSInteger, HomePageType) {
    //党建要闻
    HomePageThePartyBuildType = 0,
    //理论学习
    HomePageTheTheoryLearningType = 1,

};

@interface InterfaceManager : NSObject

/**
 登录接口
 */
+ (void)loginAccount:(NSString *)account
            password:(NSString *)password
             success:(void(^)(id result)) successBlock;


/**
 修改登录密码
 @param newPassword 新密码

 */
+ (void)changePasswordOldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
                          success:(void(^)(id result)) successBlock;
/**
 查询文章列表

 @param articleType 标题
 @param successBlock 请求成功
 */
+ (void)articleListPageNo:(NSInteger)pageNo
              articleType:(ArticleListRequestType)articleType
                  success:(void(^)(id result)) successBlock
                   failed:(void(^)(id error)) failedBlock;


/**
 思想汇报列表

 @param pageNo 页码
 @param mine 用于区分查询全部还是自己的
 */
+ (void)thoughtReportsListPageNo:(NSInteger)pageNo
                            mine:(BOOL)mine
                         success:(void(^)(id result)) successBlock
                          failed:(void(^)(id error)) failedBlock;

/**
 提交思想汇报

 @param subject 反馈主题
 @param content 反馈内容

 */
+ (void)thoughtReportsSubmitSubject:(NSString *)subject
                            content:(NSString *)content
                          backlogId:(NSString *)backlogId
                            success:(void(^)(id result)) successBlock;

/**
 工作反馈
 @param pageNo 页码
 @param mine 用于区分查询全部还是自己的

 */
+ (void)jobFeedbackListPageNo:(NSInteger)pageNo
                         mine:(BOOL)mine
                      success:(void(^)(id result)) successBlock
                       failed:(void(^)(id error)) failedBlock;


/**
 提交工作反馈

  address 活动地点
 content 活动成果
 date 时间
  id 用户ID
  people 参与人员
  subject 活动主题
 Address:(NSString *)address
 content:(NSString *)content
 date:(NSString *)date
id:(NSString *)userID
 people:(NSString *)people
 subject:(NSString *)subject
 */
+ (void)jobFeedbackSubmitParams:(NSDictionary *)params
                         images:(NSArray *)images
                        success:(void(^)(id result)) successBlock;


/**
 提交意见反馈

 @param content 反馈内容
 */
+ (void)adviceFeedbackSubmitContent:(NSString *)content
                            success:(void(^)(id result)) successBlock;

/**
 用户信息获取
 */
+ (void)userInformationObtainSuccess:(void(^)(id result)) successBlock;


// *************  返回用户信息的Vo ******************
/**
 修改用户信息
 @param params 用户信息参数
 */
+ (void)userInformationCommitParamater:(NSMutableDictionary *)params
                               success:(void(^)(id result)) successBlock
                                failed:(void(^)(id error)) failedBlock;
/**
 党迹查询

 @param pageNo 页码
 */
+ (void)trackQueryPageNo:(NSInteger)pageNo
                 success:(void(^)(id result)) successBlock
                  failed:(void(^)(id error)) failedBlock;


/**
 积分查询

 @param pageNo 页码
 */
+ (void)pointsPage:(NSInteger)pageNo
           success:(void(^)(id result)) successBlock
            failed:(void(^)(id error)) failedBlock;






//--  首页轮播 类型
+ (void)homePageType:(HomePageType)type
             success:(void(^)(id result)) successBlock
              failed:(void(^)(id error)) failedBlock;


/**
 民主评议列表

 @param successBlock 返回参数
 */
+ (void)democraticAppraisalListMissionId:(NSString *)missionId
                                 success:(void(^)(id result)) successBlock
                                  failed:(void(^)(id error)) failedBlock;
/**
 民主评议详情
 
 @param apprId 民主评议ID
 */
+ (void)democraticAppraisalDetailsApprId:(NSString *)apprId
                                 success:(void(^)(id result)) successBlock;


/**
 提交民主评议

 @param apprId 民主评议ID
 
 */
+ (void)democraticAppraisalSubmitApprId:(NSString *)apprId
                            parameArray:(NSArray *)parameArray
                                success:(void(^)(id result)) successBlock;

/**
 查询在线投票列表
 */
+ (void)onlineVoteListMissionId:(NSString *)missionId
                        success:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock;
/**
 查询在线投票选项
 */
+ (void)onlineVoteDetailsVoteId:(NSString *)voteId
                        success:(void(^)(id result)) successBlock ;

/**
 提交在线投票

 @param voteId 在线投票id
 @param ids 在线投票选项id
 @param resultsArray 在线投票结果
 */
+ (void)onlineVoteCommitVoteId:(NSString *)voteId
                           ids:(NSString *)ids
                  resultsArray:(NSArray *)resultsArray
                       success:(void(^)(id result)) successBlock;


/**
 获取联系人列表

 @param version 版本号
 */
+ (void)contactListVersion:(NSString *)version
                   success:(void(^)(id result)) successBlock
                    failed:(void(^)(id error)) failedBlock;

/**
 查询党务日历列表
 
 @param month 查询月份2017-05
 
 */
+ (void)getOrganizationLsitWithjMonth:(NSString *)month
                              success:(void(^)(id result)) successBlock
                               failed:(void(^)(id error)) failedBlock;


            //************** 考试相关的 **//


/**
 考试列表

 @param pageNo 页码
 @param type 考试类型
 missionId 指定的任务id
 */
+ (void)examListPageNo:(NSInteger)pageNo
                  type:(NSString *)type
             missionId:(NSString *)missionId
               success:(void(^)(id result)) successBlock
                failed:(void(^)(id error)) failedBlock;

/**
 试卷详情

 @param Id 试卷id

 */
+ (void)examInfoId:(NSString *)Id
           success:(void(^)(id result)) successBlock
            failed:(void(^)(id error)) failedBlock;

/**
 提交成绩

 @param value 得分
 @param examId 试卷id
 */
+ (void)examCommitScoreValue:(NSString *)value
                      examId:(NSString *)examId
                     success:(void(^)(id result)) successBlock;

/**
 获取历史成绩列表

 */
+ (void)examScoreHistoryListPageNo:(NSInteger)pageNo
                           success:(void(^)(id result)) successBlock
                            failed:(void(^)(id error)) failedBlock;

//---- 待办事项
+ (void)toDoListPageNo:(NSInteger)pageNo
               success:(void(^)(id result)) successBlock
                failed:(void(^)(id error)) failedBlock;

//-- ************组织架构**************
+ (void)organizationListSuccess:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock;

/**
 组织架构成员统计

 @param orgId 组织id

 */
+ (void)organizationMemberOrgId:(NSString *)orgId
                        success:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock;

/**
 组织成员列表
 @param orgId 组织id
 @param pageNo 页码
 */
+ (void)organizationUserListOrgId:(NSString *)orgId
                           pageNo:(NSInteger)pageNo
                          success:(void(^)(id result)) successBlock
                           failed:(void(^)(id error)) failedBlock;


//-- **************党费查询*****************

/**
 党费查询

 @param account 查询姓名
 @param pageNo 页码
 @param mine 是否查询自己 是的则不用穿name phone
 @param year 从待办事项进去需要传年份

 */
+ (void)duesQueryListAccount:(NSString *)account
                             pageNo:(NSInteger)pageNo
                               mine:(BOOL)mine
                               year:(NSString *)year
                            success:(void(^)(id result)) successBlock
                             failed:(void(^)(id error)) failedBlock;

//-- ***************支付相关*******************
+ (void)paymentChannelAlipayId:(NSString *)listId
                     backlogId:(NSString *)backlogId
                       success:(void(^)(id result)) successBlock;
+ (void)paymentChannelWeChatId:(NSString *)listId
                     backlogId:(NSString *)backlogId
                       success:(void(^)(id result)) successBlock;

@end
