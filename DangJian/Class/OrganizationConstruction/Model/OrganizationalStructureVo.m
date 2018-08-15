//
//  OrganizationalStructureVo.m
//  DangJian
//
//  Created by Sakya on 17/5/31.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationalStructureVo.h"

@implementation OrganizationalMemberVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId":@"id"};
}


@end

@implementation OrganizationalStructureVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"orgId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"childrenVo":@"OrganizationalStructureVo",
             @"list"      :@"OrganizationalMemberVo"};
}
- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalArray;
}



+ (void)organizationListSuccess:(void(^)(OrganizationalStructureVo *result)) successBlock {
    [InterfaceManager organizationListSuccess:^(id result) {
        OrganizationalStructureVo *resultVo;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            resultVo = [OrganizationalStructureVo mj_objectWithKeyValues:[result valueForKey:@"data"]];
        }
        successBlock(resultVo);
    } failed:^(id error) {
        
    }];
}
- (void)organizationMemberCountOrgId:(NSString *)orgId
                             Success:(void(^)(OrganizationalMemberVo *result)) successBlock
                              failed:(void(^)(id error)) failedBlock {
    
    [InterfaceManager organizationMemberOrgId:orgId success:^(id result) {
        OrganizationalMemberVo *countVo;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            countVo = [OrganizationalMemberVo mj_objectWithKeyValues:[result valueForKey:@"data"]];
        }
        successBlock(countVo);
    } failed:^(id error) {
        
    }];
}
- (void)organizationUserLisyIsHeader:(BOOL)isHeader
                               orgId:(NSString *)orgId
                             Success:(void(^)(OrganizationalStructureVo *result)) successBlock
                              failed:(void(^)(id error)) failedBlock {
    
    if (isHeader) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    
    [InterfaceManager organizationUserListOrgId:orgId pageNo:self.pageNo success:^(id result) {
        OrganizationalStructureVo *listVo;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listVo = [OrganizationalStructureVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listVo.list];
            listVo.totalArray = weakSelf.totalArray;
        }
        successBlock(listVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}
@end
