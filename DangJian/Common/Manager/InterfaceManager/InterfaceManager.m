//
//  InterfaceManager.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InterfaceManager.h"


@implementation InterfaceManager

// 登录接口
+ (void)loginAccount:(NSString *)account
            password:(NSString *)password
             success:(void(^)(id result)) successBlock {
    

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:account forKey:@"account" inDic:params];
    [Helper setObject:password forKey:@"password" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_POST Url:@"/rest/user/login" parameter:params success:^(id responseData) {
        successBlock(responseData);
        DDLogInfo(@"%@",responseData);
        
        
    } failed:^(id responseData) {
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
// 修改登录密码
+ (void)changePasswordOldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
                          success:(void(^)(id result)) successBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

    [Helper setObject:oldPassword forKey:@"password" inDic:params];
    [Helper setObject:newPassword forKey:@"newPassword" inDic:params];

    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/user/upPassword" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
       
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
// 查询文章列表
+ (void)articleListPageNo:(NSInteger)pageNo
              articleType:(ArticleListRequestType)articleType
                  success:(void(^)(id result)) successBlock
                   failed:(void(^)(id error)) failedBlock; {
    
    ArticleListEntity *articleParam = [ThePartyHelper articleListRequestParamterType:articleType];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    [Helper setObject:articleParam.type forKey:@"type" inDic:params];

    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/article/page" parameter:params header:nil success:^(id responseData) {
    
        successBlock(responseData);
    } failed:^(id responseData) {
        [SKHUDManager showBriefAlert:NetworkError];
        failedBlock(responseData);
    }];
}
// 思想汇报列表
+ (void)thoughtReportsListPageNo:(NSInteger)pageNo
                          mine:(BOOL)mine
                         success:(void(^)(id result)) successBlock
                          failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    [Helper setUnObject:@(mine) forUnKey:@"mine" inDictionary:params];

    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/report/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        failedBlock(responseData);
    }];
}
// 提交思想汇报
+ (void)thoughtReportsSubmitSubject:(NSString *)subject
                            content:(NSString *)content
                          backlogId:(NSString *)backlogId
                            success:(void(^)(id result)) successBlock {
   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:subject forKey:@"subject" inDic:params];
    [Helper setObject:content forKey:@"content" inDic:params];
    if (backlogId) {
        [Helper setObject:backlogId forKey:@"backlogId" inDic:params];
    }
    [NetworkLib requestServer:HTTP_METHED_POST Url:@"/rest/report/add" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
// 工作反馈
+ (void)jobFeedbackListPageNo:(NSInteger)pageNo
                         mine:(BOOL)mine
                      success:(void(^)(id result)) successBlock
                       failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(10) forKey:@"pageSize" inDic:params];
    [Helper setUnObject:@(mine) forUnKey:@"mine" inDictionary:params];

    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/job/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        failedBlock(responseData);
    }];
}
// 提交工作反馈
+ (void)jobFeedbackSubmitParams:(NSDictionary *)params
                         images:(NSArray *)images
                        success:(void(^)(id result)) successBlock {
    [NetworkLib uploadWithPath:@"/rest/job/add" param:params images:images uploadName:@"file" successBlock:^(id result) {
        successBlock(result);
   
    
    } failureBlock:^(NSError *errorMsg) {
        [SKHUDManager showBriefAlert:NetworkError];
    
    
    }];

}
//  提交意见反馈
+ (void)adviceFeedbackSubmitContent:(NSString *)content
                            success:(void(^)(id result)) successBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:content forKey:@"content" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/advice/add" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
+ (void)userInformationObtainSuccess:(void(^)(id result)) successBlock {
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/user/info" parameter:nil header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
//用户 信息修改
+ (void)userInformationCommitParamater:(NSMutableDictionary *)params
                               success:(void(^)(id result)) successBlock
                                failed:(void(^)(id error)) failedBlock {
    
    NSString *uploadKey;
    NSArray *imgaes;
    if ([params.allKeys containsObject:@"image"]) {
        
        uploadKey = @"file";
        imgaes = @[[params objectForKey:@"image"]];
        [params removeObjectForKey:@"image"];
    }
    
    [NetworkLib uploadWithPath:@"/rest/user/upInfo" param:params images:imgaes uploadName:uploadKey successBlock:^(id result) {
        
        successBlock(result);
    } failureBlock:^(NSError *errorMsg) {
        [SKHUDManager showBriefAlert:NetworkError];
        failedBlock(errorMsg);
    }];
    
}
//积分查询
+ (void)pointsPage:(NSInteger)pageNo
           success:(void(^)(id result)) successBlock
            failed:(void(^)(id error)) failedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_POST Url:@"/rest/user/pointsPage" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
//首页数据
+ (void)homePageType:(HomePageType)type
             success:(void(^)(id result)) successBlock
              failed:(void(^)(id error)) failedBlock {
    
    NSDictionary *params = @{@"type": type == HomePageThePartyBuildType ? @"djyw" : @"llxx"};
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/carousel/list" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
    }];
    
}

/**
 民主评议列表
 @param successBlock 返回参数
 */
+ (void)democraticAppraisalListMissionId:(NSString *)missionId
                                 success:(void(^)(id result)) successBlock
                                  failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (missionId) {
        [Helper setObject:missionId forKey:@"id" inDic:params];
    }
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/appr/list" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
/**
 民主评议详情
  */
+ (void)democraticAppraisalDetailsApprId:(NSString *)apprId
                                 success:(void(^)(id result)) successBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:apprId forKey:@"apprId" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/appr/choice" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {

        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
+ (void)democraticAppraisalSubmitApprId:(NSString *)apprId
                                parameArray:(NSArray *)parameArray
                                 success:(void(^)(id result)) successBlock {
    
    
    __block NSMutableString *pathUrl = [NSMutableString stringWithFormat:@"/rest/appr/commit"];
    [pathUrl appendString:[NSString stringWithFormat:@"?apprId=%@",apprId]];
    [parameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pathUrl appendString:[NSString stringWithFormat:@"&ids=%@&results=%@",[obj objectForKey:@"ids"],[obj objectForKey:@"results"]]];
        
    }];
    [NetworkLib requestServer:HTTP_METHED_GET Url:pathUrl parameter:nil header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        [SKHUDManager showBriefAlert:NetworkError];
    }];
    
}
+ (void)onlineVoteListMissionId:(NSString *)missionId
                        success:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (missionId) {
        [Helper setObject:missionId forKey:@"id" inDic:params];
    }
    
    [NetworkLib requestServer:HTTP_METHED_POST Url:@"/rest/vote/list" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
    }];
 
}
+ (void)onlineVoteDetailsVoteId:(NSString *)voteId
                        success:(void(^)(id result)) successBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:voteId forKey:@"voteId" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/vote/options" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
+ (void)onlineVoteCommitVoteId:(NSString *)voteId
                           ids:(NSString *)ids
                  resultsArray:(NSArray *)resultsArray
                       success:(void(^)(id result)) successBlock {
    
   __block NSMutableString *pathUrl = [NSMutableString stringWithFormat:@"/rest/vote/commit"];
    [pathUrl appendString:[NSString stringWithFormat:@"?voteId=%@&ids=%@",voteId,ids]];
    [resultsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pathUrl appendString:[NSString stringWithFormat:@"&results=%@",obj]];
    }];
   
    [NetworkLib requestServer:HTTP_METHED_GET Url:pathUrl parameter:nil header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
// 获取联系人列表
+ (void)contactListVersion:(NSString *)version
                   success:(void(^)(id result)) successBlock
                    failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:version forKey:@"version" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/user/orgList" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
    }];
    
}

//查询党务日历
+ (void)getOrganizationLsitWithjMonth:(NSString *)month
                              success:(void(^)(id result)) successBlock
                               failed:(void(^)(id error)) failedBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:month forKey:@"month" inDic:params];
    [NetworkLib requestServer:HTTP_METHED_POST Url:@"/rest/calendar/list" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
//考试类型
+ (void)examListPageNo:(NSInteger)pageNo
                  type:(NSString *)type
             missionId:(NSString *)missionId
               success:(void(^)(id result)) successBlock
                failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!missionId) {
        [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
        [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
        [Helper setObject:type forKey:@"type" inDic:params];
    } else {
        
        [Helper setObject:missionId forKey:@"id" inDic:params];
    }
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/exam/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];

    }];
}
+ (void)examInfoId:(NSString *)Id
           success:(void(^)(id result)) successBlock
            failed:(void(^)(id error)) failedBlock {
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"/rest/exam/info"];
    [urlString appendString:[NSString stringWithFormat:@"/%@",Id]];
    
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:urlString parameter:nil header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
+ (void)examCommitScoreValue:(NSString *)value
                      examId:(NSString *)examId
                     success:(void(^)(id result)) successBlock {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:value forKey:@"value" inDic:params];
    [Helper setObject:examId forKey:@"exam.id" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/exam/scoreSave" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {

        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
+ (void)examScoreHistoryListPageNo:(NSInteger)pageNo
                           success:(void(^)(id result)) successBlock
                            failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/exam/scorePage" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
+ (void)toDoListPageNo:(NSInteger)pageNo
               success:(void(^)(id result)) successBlock
                failed:(void(^)(id error)) failedBlock {
   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/backlog/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
    
}
+ (void)organizationListSuccess:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock {
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/org/list" parameter:nil header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
    
}
+ (void)organizationMemberOrgId:(NSString *)orgId
                        success:(void(^)(id result)) successBlock
                         failed:(void(^)(id error)) failedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [Helper setObject:orgId forKey:@"orgId" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/org/userCount" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
+ (void)organizationUserListOrgId:(NSString *)orgId
                           pageNo:(NSInteger)pageNo
                          success:(void(^)(id result)) successBlock
                           failed:(void(^)(id error)) failedBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    [Helper setObject:orgId forKey:@"orgId" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/org/userList" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}

+ (void)duesQueryListAccount:(NSString *)account
                             pageNo:(NSInteger)pageNo
                               mine:(BOOL)mine
                               year:(NSString *)year
                            success:(void(^)(id result)) successBlock
                             failed:(void(^)(id error)) failedBlock {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    if (mine) {
        [Helper setObject:@(mine) forKey:@"mine" inDic:params];
    } else {
        
        [Helper setObject:account forKey:@"account" inDic:params];
    }
    [Helper setUnObject:year forUnKey:@"year" inDictionary:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/dues/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
+ (void)trackQueryPageNo:(NSInteger)pageNo
                 success:(void(^)(id result)) successBlock
                  failed:(void(^)(id error)) failedBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [Helper setObject:@(pageNo) forKey:@"pageNo" inDic:params];
    [Helper setObject:@(NewsListPageSize) forKey:@"pageSize" inDic:params];
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:@"/rest/track/page" parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        failedBlock(responseData);
        [SKHUDManager showBriefAlert:NetworkError];
        
    }];
}
+ (void)paymentChannelAlipayId:(NSString *)listId
                     backlogId:(NSString *)backlogId
                       success:(void(^)(id result)) successBlock {
    
    __block NSMutableString *pathUrl = [NSMutableString stringWithFormat:@"/rest/pay/alipay/"];
    if (listId) [pathUrl appendString:listId];
    NSDictionary *params = backlogId ? @{@"backlogId":backlogId} : nil;
    
    [NetworkLib requestServer:HTTP_METHED_GET Url:pathUrl parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
+ (void)paymentChannelWeChatId:(NSString *)listId
                     backlogId:(NSString *)backlogId
                       success:(void(^)(id result)) successBlock {
   
    __block NSMutableString *pathUrl = [NSMutableString stringWithFormat:@"/rest/pay/wxpay/"];
    if (listId) [pathUrl appendString:listId];
    NSDictionary *params = backlogId ? @{@"backlogId":backlogId} : nil;

    [NetworkLib requestServer:HTTP_METHED_GET Url:pathUrl parameter:params header:nil success:^(id responseData) {
        
        successBlock(responseData);
    } failed:^(id responseData) {
        
        [SKHUDManager showBriefAlert:NetworkError];
    }];
}
@end
