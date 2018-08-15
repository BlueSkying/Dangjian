//
//  ThePartyHelper.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleListEntity;
//文章请求类型
typedef NS_OPTIONS(NSInteger, ArticleListRequestType) {
    
//    党建要闻
    /**党建要闻*/
    ArticleListRequestThePartyNewsType = 0,
    /**中央新闻*/
    ArticleListRequestTheCentralNewsType = 1,
    /**行业动态*/
    ArticleListRequestIndustryDynamicType = 2,
    /**阿烟信息*/
    ArticleListRequestSmokeInformationType = 3,
    
    
    //三会一课
    /**三会一课*/
    ArticleListRequestMeetingClassType,
    
    /**党员大会*/
    ArticleListRequestMemberMeetingType,
    /**党员会议通知*/
    ArticleListRequestMemberMeetingNoticeType,
    /**党员会议决议*/
    ArticleListRequestMemberMeetingResolutionType,
    
    /**党支部委员会*/
    ArticleListRequestThePartyBranchCommitteeType,
    /**党支部会议通知*/
    ArticleListRequestThePartyBranchCommitteeNoticeType,
    /**党支部会议决议*/
    ArticleListRequestThePartyBranchCommitteeResolutionType,
    
    /**党小组会*/
    ArticleListRequestThePartyGroupMeetingType,
    /**党小组会议通知*/
    ArticleListRequestThePartyGroupNoticeType,
    /**党小组会议决议*/
    ArticleListRequestThePartyGroupResolutionType,
    
    /** 党课*/
    ArticleListRequestThePartyClassType,
    /**党课讲义*/
    ArticleListRequestThePartyClassNotesType,
    /**微党课学习*/
    ArticleListRequestThePartyClassLearningType,
    
    //两学一做
    /** 两学一做*/
    ArticleListRequestLearningDoneType,
    /** 学党章党规*/
    ArticleListRequestLearningThePartyConstitutionType,
    /** 学系列讲话*/
    ArticleListRequestLearningSeriesOfSpeechType,
    /**  做合格党员*/
    ArticleListRequestLearningDoneQualifiedPartyMemberType,
    
//    民主生活会
    /** 民主生活会*/
    ArticleListRequestDemocraticLifeType,
    /** 民主会议通知*/
    ArticleListRequestDemocraticMeetingNoticeType,
    /** 民主会议决议*/
    ArticleListRequestDemocraticMeetingResolutionType,
    
    
    
//    党员互动
    /** 党员互动*/
    ArticleListRequestMemberInteractiveType,
    
    //二、通知公告
    /** 机关党委*/
    ArticleListRequestDepartmentThePartyCommitteeType,
    /** 党支部*/
    ArticleListRequestThePartyBranchType,
    /** 党小组*/
    ArticleListRequestThePartyGroupType,
    
//    理论学习
    /**在线学习*/
    ArticleListRequestLearningOnlineType,
    /** 党史*/
    ArticleListRequestThePartyHistoryType,
//    党章党规
     /** 党章*/
    ArticleListRequestThePartyConstitutionType,
     /** 党规*/
    ArticleListRequestThePartyRuleType,
    
    
//    系列讲话
    /** 系列讲话*/
    ArticleListRequestSeriesOfSpeechType,
//    理论推送
    /** 理论推送*/
    ArticleListRequestTheTheoryPushType,
    
    
//    组织建设
    /** 理工作规范*/
    ArticleListRequestJobSpecificationType,
    
//     廉政建设
    ArticleListRequestIntegrityBuildType,

    
};

@interface ThePartyHelper : NSObject


/**
 返回码处理

 @param prompt 是否显示提示框
 @param result 返回码
 @return 成功失败
 */
+ (BOOL)showPrompt:(BOOL)prompt returnCode:(id)result;


/**
 根据type 返回对应的实体

 @param type 类型

 */
+ (ArticleListEntity *)articleListRequestParamterType:(ArticleListRequestType)type;

@end


/**
 返回 请求需要的参数
 */
@interface ArticleListEntity : NSObject

/**
 文章类型
 */
@property (nonatomic,copy) NSString *type;

/**
 标题
 */
@property (nonatomic,copy) NSString *title;


@end
