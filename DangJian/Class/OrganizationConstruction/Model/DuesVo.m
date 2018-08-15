//
//  DuesVo.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DuesVo.h"

@implementation DuesVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"listId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"DuesVo"};
}

- (void)duesQueryIsHeader:(BOOL)isHeader
                  account:(NSString *)account
                     mine:(BOOL)mine
                     year:(NSString *)year
                  success:(void(^)(DuesVo *result)) successBlock
                   failed:(void(^)(id error)) failedBlock {
    
    if (isHeader) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager duesQueryListAccount:account pageNo:self.pageNo mine:mine year:year success:^(id result) {
        DuesVo *listVo;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listVo = [DuesVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listVo.list];
            listVo.totalArray = weakSelf.totalArray;
        }
        successBlock(listVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}


@end
