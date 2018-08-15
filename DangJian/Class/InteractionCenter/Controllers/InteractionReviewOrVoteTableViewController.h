//
//  InteractionReviewOrVoteTableViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_OPTIONS(NSInteger, MeReViewOrVotePageType) {
    
    //民主评议
    MeDemocraticReViewPageType = 0,
    // 在线投票
    MeOnlineVotePageType,
};
@interface InteractionReviewOrVoteTableViewController : BaseTableViewController
/**
 页面类型
 */
@property (nonatomic, assign) MeReViewOrVotePageType pageType;

/**
 事件Id任务ID 查询指定的事项
 */
@property (nonatomic, copy) NSString *missionId;
@end
