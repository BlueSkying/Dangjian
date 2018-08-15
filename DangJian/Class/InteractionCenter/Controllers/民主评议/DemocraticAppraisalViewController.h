//
//  DemocraticAppraisalViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "DemocraticReviewOptionCell.h"

@interface DemocraticAppraisalViewController : BaseViewController


/**
 民主评议id
 */
@property (nonatomic, strong) DemocraticAppraisalVo *appraisalVo;

@property (nonatomic, copy) void(^appraisalSuccessBlock)();
@end
