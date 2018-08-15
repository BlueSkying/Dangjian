//
//  ToDoListModel.m
//  DangJian
//
//  Created by Sakya on 17/5/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ToDoListModel.h"





@implementation ToDoListModel

+ (NSDictionary*)mj_objectClassInArray {
    
    return @{@"list":@"ToDoListModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"toDoId":@"id"};
}
- (void)setType:(NSString *)type {
    
    _type = type;
    if ([type isEqualToString:@"XWCK"]) {
        
        _pageType = ToDoTypeNews;
        _titleType = @"新闻查看";
        _className = @"BaseWebViewController";
        
    } else if ([type isEqualToString:@"ZXKS"]) {
        _pageType = ToDoTypeOnlineExam;
        _titleType = @"在线考试";
        _className = @"OnlineTestListViewController";
        
    } else if ([type isEqualToString:@"ZXJF"]) {
        _pageType = ToDoTypeOnlinePayCost;
        _titleType = @"在线缴费";
        _className = @"OrganizationOnlinePaymentViewController";
        
    } else if ([type isEqualToString:@"GZFK"]) {
        _pageType = ToDoTypeJobFeedBack;
        _titleType = @"工作反馈";
        _className = @"WorkFeedbackEditViewController";
        
    } else if ([type isEqualToString:@"SXHB"]) {
        _pageType = ToDoTypeOnlineThoughtReports;
        _titleType = @"思想汇报";
        _className = @"ThoughtReportsEditViewController";
        
    } else if ([type isEqualToString:@"MZPY"]) {
        _pageType = ToDoTypeDemocraticAppraisal;
        _titleType = @"民主评议";
        _className = @"InteractionReviewOrVoteTableViewController";
        
    } else if ([type isEqualToString:@"ZXTP"]) {
        _pageType = ToDoTypeOnlineVote;
        _titleType = @"在线投票";
        _className = @"InteractionReviewOrVoteTableViewController";
        
    }
}

- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalArray;
}

- (void)toDoListIsHeader:(BOOL)isHeader
                 success:(void(^)(ToDoListModel *result)) successBlock
                 failed:(void(^)(id error)) failedBlock {
    
    
    if (isHeader) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager toDoListPageNo:self.pageNo success:^(id result) {
        ToDoListModel *listVo;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listVo = [ToDoListModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listVo.list];
            listVo.totalArray = weakSelf.totalArray;
        }
        successBlock(listVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
    
}
@end
