//
//  OrganizationPaymentInfoCell.h
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentDetailsModel.h"


@interface OrganizationPaymentInfoCell : UITableViewCell
/**
 描述
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 信息
 */
@property (nonatomic, strong) UILabel *contentLabel;
@end
