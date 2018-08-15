//
//  OrganizationOnlinePaymentViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "DuesVo.h"

@interface OrganizationOnlinePaymentViewController : BaseViewController
/**
 事项id 如果没有则查询全部有的则查询指定
 */
@property (nonatomic, copy) NSString *backlogId;

@property (nonatomic, strong) DuesVo *duesVo;


@end
