//
//  OnlineTestPaperListVo.m
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestPaperListVo.h"

@implementation OnlineTestPaperListVo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"OnlineTestPaperListVo"};
    
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"examinationPaperId":@"id"};
}
- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalArray;
}
- (void)examListIsHeaderRefresh:(BOOL)isHeaderRefresh
                           type:(NSString *)type
                         missionId:(NSString *)missionId
                        success:(void(^)(OnlineTestPaperListVo *result)) successBlock
                         failed:(void(^)(id error)) failedBlock {
    
    if (isHeaderRefresh) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager examListPageNo:self.pageNo  type:type missionId:missionId success:^(id result) {
        
        OnlineTestPaperListVo *listVo;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listVo = [OnlineTestPaperListVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listVo.list];
            listVo.totalArray = weakSelf.totalArray;
            listVo.cellType = OnlineTestExaminationPaperType;
        }
        successBlock(listVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
    
}
- (void)examHistoryScoreListIsHeaderRefresh:(BOOL)isHeaderRefresh
                                    success:(void(^)(OnlineTestPaperListVo *result)) successBlock
                                     failed:(void(^)(id error)) failedBlock {
    
    if (isHeaderRefresh) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager examScoreHistoryListPageNo:self.pageNo success:^(id result) {
        OnlineTestPaperListVo *listVo;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listVo = [OnlineTestPaperListVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listVo.list];
            listVo.totalArray = weakSelf.totalArray;
            listVo.cellType = OnlineTestPaperHistoryScoreType;
        }
        successBlock(listVo);
    } failed:^(id error) {
        failedBlock(error);

    }];
}

@end
