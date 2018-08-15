//
//  OrganizationPaymentModeCell.h
//  DangJian
//
//  Created by Sakya on 17/6/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentDetailsModel.h"


@class OrganizationPaymentModeCell;

@interface PaymentModeView : UIView

@property (nonatomic, strong) OrganizationPaymentModeCell *paymentCell;

@end


@protocol OrganizationPaymentChannelCellDelegate <NSObject>
/**
 选择支付渠道
 */
- (void)paymentChannelSelected:(UIButton *)sender;

@end

@interface OrganizationPaymentModeCell : UITableViewCell

@property (nonatomic, weak) id<OrganizationPaymentChannelCellDelegate>delegate;


@end
