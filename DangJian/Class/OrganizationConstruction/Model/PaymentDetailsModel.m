//
//  PaymentDetailsModel.m
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PaymentDetailsModel.h"

@implementation PaymentDetailsModel

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"待缴年月",
                        @"缴纳金额",
                        @"缴纳人姓名",
                        @"缴纳人工号"];
    }
    return _titleArray;
}
+ (void)payCostOrderId:(NSString *)orderId
            payChannel:(PaymentChannelMode)channel
             backlogId:(NSString *)backlogId
               success:(void(^)(NSString *result)) successBlock {
    
    if (channel == PaymentModeAlipay) {
        
        [InterfaceManager paymentChannelAlipayId:orderId backlogId:backlogId success:^(id result) {
            if ([ThePartyHelper showPrompt:YES returnCode:result]) {
                NSString *sign = [result objectForKey:@"data"];
                successBlock(sign);
            }
        }];
    } else if (channel == PaymentModeWeChat) {
        
        [InterfaceManager paymentChannelWeChatId:orderId backlogId:backlogId success:^(id result) {
            if ([ThePartyHelper showPrompt:YES returnCode:result]) {
                NSString *stringData = [result objectForKey:@"data"];
                successBlock(stringData);
            }
        }];
    }
}

@end
