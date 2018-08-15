//
//  OrganizationMemberInfoViewController.h
//  DangJian
//
//  Created by Sakya on 2017/6/13.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "OrganizationMemberInfoCell.h"


@interface OrganizationMemberInfoViewController : BaseViewController
/**
 组织信息
 */
@property (nonatomic, strong) OrganizationalStructureVo *organizationInfoVo;
@end
