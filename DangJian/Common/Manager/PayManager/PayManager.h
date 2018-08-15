//
//  PayManager.h
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PaymentDetailsModel.h"



@protocol PayApiManagerDelegate <NSObject>

@optional
- (void)managerDidRecvPayState:(BOOL)state result:(NSString *)result;
@end

@interface PayManager : NSObject<WXApiDelegate>
+ (instancetype)sharedManager;

@property (nonatomic, weak) id<PayApiManagerDelegate> delegate;


/**
 微信支付
 */
- (void)wxPayJumpToBizString:(NSString *)string;

/**
 支付宝支付
 @param orderString 签名信息
 */
- (void)alipayPayOrderString:(NSString *)orderString;


/**
 支付调用

 @param channel 支付渠道
 @param string 支付信息
 */
- (void)payChannel:(PaymentChannelMode)channel
    payOrderString:(NSString *)string;
//返回结果处理
- (void)dealAlipayResult:(NSDictionary *)resultDic;

@end
