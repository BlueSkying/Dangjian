//
//  ThePartyHelper.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThePartyHelper.h"

@implementation ThePartyHelper

+ (BOOL)showPrompt:(BOOL)prompt returnCode:(id)result {
    
    
    NSInteger errorCode = [[result objectForKey:@"status"] integerValue];
    NSString *promptDescribe;
    BOOL status;
    if (errorCode == 1) {
        status = YES;
    } else if (errorCode == 3 ||
               errorCode == 4 ||
               errorCode == 0) {
        
        status = NO;
        promptDescribe = [result objectForKey:@"msg"];
        
    } else if (errorCode == 5) {
        promptDescribe = @"账号信息无效请重新登录";
        status = NO;

    } else if (errorCode == 6) {
        promptDescribe = @"账号信息已过期请重新登录";
        status = NO;
    }
    if (prompt && promptDescribe) {
        [SKHUDManager showBriefAlert:promptDescribe];
    }
    return status;
}
+ (ArticleListEntity *)articleListRequestParamterType:(ArticleListRequestType)type {
    ArticleListEntity *articleEntity = [[ArticleListEntity alloc] init];
    switch (type) {
        case ArticleListRequestThePartyNewsType:
            
            articleEntity.title = @"党建要闻";
            articleEntity.type = @"djyw1";
            break;
        case ArticleListRequestTheCentralNewsType:
            
            articleEntity.title = @"中央新闻";
            articleEntity.type = @"zyxw";
            break;
        case ArticleListRequestIndustryDynamicType:
            
            articleEntity.title = @"行业动态";
            articleEntity.type = @"hydt";
            break;
        case ArticleListRequestSmokeInformationType:
            
            articleEntity.title = @"阿烟信息";
            articleEntity.type = @"ayxx";
            break;
        case ArticleListRequestMeetingClassType:
            
            articleEntity.title = @"三会一课";
            articleEntity.type = @"shyk";
            break;
        case ArticleListRequestMemberMeetingType:
            
            articleEntity.title = @"党员大会";
            articleEntity.type = @"dydh";
            break;
        case ArticleListRequestMemberMeetingNoticeType:
            
            articleEntity.title = @"党员会议通知";
            articleEntity.type = @"dyhytz";
            break;
        case ArticleListRequestMemberMeetingResolutionType:
            
            articleEntity.title = @"党员会议决议";
            articleEntity.type = @"dyhyjy";
            break;
        case ArticleListRequestThePartyBranchCommitteeType:
            
            articleEntity.title = @"党支部委员会";
            articleEntity.type = @"dzbwyh";
            break;
        case ArticleListRequestThePartyBranchCommitteeNoticeType:
            
            articleEntity.title = @"党支部会议通知";
            articleEntity.type = @"dzbhytz";
            break;
        case ArticleListRequestThePartyBranchCommitteeResolutionType:
            
            articleEntity.title = @"党支部会议决议";
            articleEntity.type = @"dzbhyjy";
            break;
        case ArticleListRequestThePartyGroupMeetingType:
            
            articleEntity.title = @"党小组会";
            articleEntity.type = @"dxzh";
            break;
        case ArticleListRequestThePartyGroupNoticeType:
            
            articleEntity.title = @"党小组会议通知";
            articleEntity.type = @"dxzhytz";
            break;
        case ArticleListRequestThePartyGroupResolutionType:
            
            articleEntity.title = @"党小组会议决议";
            articleEntity.type = @"dxzhyjy";
            break;
        case ArticleListRequestThePartyClassType:
            
            articleEntity.title = @"党课";
            articleEntity.type = @"dk";
            break;
        case ArticleListRequestThePartyClassNotesType:
            
            articleEntity.title = @"党课讲义";
            articleEntity.type = @"dkjy";
            break;
        case ArticleListRequestThePartyClassLearningType:
            
            articleEntity.title = @"微党课学习";
            articleEntity.type = @"wdkxy";
            break;
        case ArticleListRequestLearningDoneType:
            
            articleEntity.title = @"两学一做";
            articleEntity.type = @"lxyz";
            break;
        case ArticleListRequestLearningThePartyConstitutionType:
            
            articleEntity.title = @"学党章党规";
            articleEntity.type = @"xdzdg";
            break;
        case ArticleListRequestLearningSeriesOfSpeechType:
            
            articleEntity.title = @"学系列讲话";
            articleEntity.type = @"xxljh";
            break;
        case ArticleListRequestLearningDoneQualifiedPartyMemberType:
            
            articleEntity.title = @"做合格党员";
            articleEntity.type = @"zhgdy";
            break;
        case ArticleListRequestDemocraticLifeType:
            
            articleEntity.title = @"民主生活会";
            articleEntity.type = @"mzshh";
            break;
        case ArticleListRequestDemocraticMeetingNoticeType:
            
            articleEntity.title = @"民主会议通知";
            articleEntity.type = @"mzhytz";
            break;
        case ArticleListRequestDemocraticMeetingResolutionType:
            
            articleEntity.title = @"民主会议决议";
            articleEntity.type = @"mzhyjy";
            break;
        case ArticleListRequestMemberInteractiveType:
            
            articleEntity.title = @"党员互动";
            articleEntity.type = @"dyhd";
            break;
            
        case ArticleListRequestDepartmentThePartyCommitteeType:
            
            articleEntity.title = @"机关党委";
            articleEntity.type = @"jgdw";
            break;
        case ArticleListRequestThePartyBranchType:
            
            articleEntity.title = @"党支部";
            articleEntity.type = @"dzb";
            break;
        case ArticleListRequestThePartyGroupType:
            
            articleEntity.title = @"党小组";
            articleEntity.type = @"dxz";
            break;

        case ArticleListRequestLearningOnlineType:
            
            articleEntity.title = @"在线学习";
            articleEntity.type = @"zxxx";
            break;
        case ArticleListRequestThePartyHistoryType:
            
            articleEntity.title = @"党史";
            articleEntity.type = @"ds";
            break;
        case ArticleListRequestThePartyConstitutionType:
            
            articleEntity.title = @"党章";
            articleEntity.type = @"dz";
            break;
        case ArticleListRequestThePartyRuleType:
            
            articleEntity.title = @"党规";
            articleEntity.type = @"dg";
            break;
        case ArticleListRequestSeriesOfSpeechType:
            
            articleEntity.title = @"系列讲话";
            articleEntity.type = @"xljh";
            break;
        case ArticleListRequestTheTheoryPushType:
            
            articleEntity.title = @"理论推送";
            articleEntity.type = @"llts";
            break;
        case ArticleListRequestJobSpecificationType:
            
            articleEntity.title = @"工作规范";
            articleEntity.type = @"gzgf";
            break;
        case ArticleListRequestIntegrityBuildType:
            
            articleEntity.title = @"廉政建设";
            articleEntity.type = @"lzjs";
            break;
        default:
            break;
    }
    return articleEntity;
}
@end

@implementation ArticleListEntity




@end
