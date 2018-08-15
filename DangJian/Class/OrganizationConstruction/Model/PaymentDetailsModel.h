//
//  PaymentDetailsModel.h
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, PaymentChannelMode) {
    
    //支付宝支付
    PaymentModeAlipay = 0,
    //微信支付
    PaymentModeWeChat
};


@interface PaymentDetailsModel : NSObject

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) PaymentChannelMode paymentChannel;

+ (void)payCostOrderId:(NSString *)orderId
            payChannel:(PaymentChannelMode)channel
             backlogId:(NSString *)backlogId
               success:(void(^)(NSString *result)) successBlock;

@end
