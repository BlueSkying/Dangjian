//
//  OnlineVotingViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "DemocraticAppraisalVo.h"

@interface OnlineVotingViewController : BaseViewController
/**
 在线投票
 */
@property (nonatomic, strong) DemocraticAppraisalVo *appraisalVo;

@property (nonatomic, copy) void(^onlineVotingSuccessBlock)();
@end
