//
//  OrganizationConstructionHomeModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationConstructionHomeModel.h"

@implementation OrganizationConstructionHomeModel
- (NSMutableArray *)itemArray {
    
    if (!_itemArray) {
        
        NSArray *buttonArray =
        @[
          @[@{@"imageName":@"organization_structure_button",
              @"className":@"OrganizationStructureViewController",
              @"title":@"组织架构"},
            @{@"imageName":@"organization_jobspecification_button",
              @"className":@"OrganizationJobSpecificationViewController",
              @"title":@"工作规范"},
            @{@"imageName":@"organization_feedback_button",
              @"className":@"OrganizationFeedbackViewController",
              @"title":@"工作展示"}],
          @[@{@"imageName":@"organization_duesQuery_button",
              @"className":@"OrganzationDuesQueryiewController",
              @"title":@"党费查询"},
            @{@"imageName":@"organization_onlinePayment_button",
              @"className":@"OrganzationPersonalDuesViewController",
              @"title":@"在线缴费"},
            @{@"imageName":@"organization_calendar_button",
              @"className":@"OrganizationCalendarViewController",
              @"title":@"党务日历"}]];
        _itemArray = [NSMutableArray arrayWithArray:buttonArray];
    }
    return _itemArray;
}
@end
