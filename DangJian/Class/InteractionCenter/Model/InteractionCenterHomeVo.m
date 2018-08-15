//
//  InteractionCenterHomeVo.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterHomeVo.h"

@implementation InteractionCenterHomeVo
- (NSMutableArray *)itemArray {
    
    if (!_itemArray) {
        
        NSArray *buttonArray =
        @[@[@{@"imageName":@"me_heartTalk_icon",
              @"className":@"HeartTalkListViewController",
              @"title":@"交心谈心"},
            @{@"imageName":@"me_thoughtReports_icon",
              @"className":@"ThoughtReportsViewController",
              @"title":@"思想汇报"},
            @{@"imageName":@"me_democraticAppraisal_button",
              @"className":@"InteractionReviewOrVoteTableViewController",
              @"title":@"民主评议"},
            @{@"imageName":@"me_onlineVoting_button",
              @"className":@"InteractionReviewOrVoteTableViewController",
              @"title":@"在线投票"}],
          @[@{@"imageName":@"me_memberInformation_button",
              @"className":@"MemberInformationViewController",
              @"title":@"信息维护"},
            @{@"imageName":@"me_myToDo_button",
              @"className":@"ToDoListViewController",
              @"title":@"我的待办"},
            @{@"imageName":@"me_myIntegral_icon",
              @"className":@"MyIntegralViewController",
              @"title":@"我的积分"},
            @{@"imageName":@"me_thePartyTrace_icon",
              @"className":@"ThePartyTraceViewController",
              @"title":@"我的党迹"}],
          @[@{@"imageName":@"me_feedback_icon",
              @"className":@"FeedbackViewController",
              @"title":@"意见反馈"},
            @{@"imageName":@"me_changePassword_icon",
              @"className":@"ChangePasswordViewController",
              @"title":@"修改密码"},
            @{@"imageName":@"me_logOut_icon",
              @"className":UserLogOutSign,
              @"title":@"退出登录"}]];
        _itemArray = [NSMutableArray arrayWithArray:buttonArray];
    }
    return _itemArray;
}
@end
