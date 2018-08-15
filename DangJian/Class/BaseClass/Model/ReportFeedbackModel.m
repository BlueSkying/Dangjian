//
//  ReportFeedbackModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ReportFeedbackModel.h"

@implementation ReportFeedbackModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"infoID":@"id"};
}
+ (NSDictionary*)mj_objectClassInArray {
    
    return @{@"list":@"ReportFeedbackModel"};
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}
// 工作反馈
- (void)jobFeedbackListMine:(BOOL)mine
                      success:(void(^)(ReportFeedbackModel *result)) successBlock
                        failed:(void(^)(id error)) failedBlock {
    
    if (self.pageNo == 0)  [self.listArray removeAllObjects];
    self.pageNo ++;
    __weak typeof(self) weakSelf = self;
    [InterfaceManager jobFeedbackListPageNo:self.pageNo mine:mine success:^(id result) {
        ReportFeedbackModel *jobFeedbackVo;
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            
            jobFeedbackVo = [ReportFeedbackModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.listArray addObjectsFromArray:jobFeedbackVo.list];;
            jobFeedbackVo.listArray = weakSelf.listArray;
            DDLogInfo(@"%@",jobFeedbackVo);
        }
        successBlock(jobFeedbackVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}
// 思想汇报
- (void)thoughtReportListMine:(BOOL)mine
                        success:(void(^)(ReportFeedbackModel *result)) successBlock
                         failed:(void(^)(id error)) failedBlock {
    if (self.pageNo == 0)  [self.listArray removeAllObjects];
    self.pageNo ++;
    __weak typeof(self) weakSelf = self;
    [InterfaceManager thoughtReportsListPageNo:self.pageNo mine:mine success:^(id result) {
        ReportFeedbackModel *jobFeedbackVo;
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            
            jobFeedbackVo = [ReportFeedbackModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.listArray addObjectsFromArray:jobFeedbackVo.list];;
            jobFeedbackVo.listArray = weakSelf.listArray;
            DDLogInfo(@"%@",jobFeedbackVo);
        }
        successBlock(jobFeedbackVo);
        
    } failed:^(id error) {
        failedBlock(error);
    }];
}
- (void)reportFeedbackType:(ReportFeedbackType)type
                    mine:(BOOL)mine
                   success:(void(^)(ReportFeedbackModel *result)) successBlock
                    failed:(void(^)(id error)) failedBlock {
    
    if (type == ReportObjectType) {
        
        [self thoughtReportListMine:mine success:^(ReportFeedbackModel *result) {
            successBlock(result);
        } failed:^(id error) {
            failedBlock(error);
        }];
    } else if (type == FeedbackObjectType) {
        
        [self jobFeedbackListMine:mine success:^(ReportFeedbackModel *result) {
            successBlock(result);
        } failed:^(id error) {
            failedBlock(error);
        }];
    }
    
}

@end
