//
//  AppDelegate+Pay.m
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate+Pay.h"
#import "PayManager.h"

@implementation AppDelegate (Pay)

- (void)wxRegisterApp:(NSString *)appid withDescription:(NSString *)appdesc {
    
    //向微信注册
    [WXApi registerApp:appid enableMTA:YES];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    
    //支付宝不需要修改配置信息
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[PayManager sharedManager] dealAlipayResult:resultDic];
            DDLogInfo(@"result = %@",resultDic);
        }];
        return YES;
    } else {
        return  [WXApi handleOpenURL:url delegate:[PayManager sharedManager]];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[PayManager sharedManager]];
}


//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         
            [[PayManager sharedManager] dealAlipayResult:resultDic];
            DDLogInfo(@"result = %@",resultDic);
        }];
        return YES;
    } else {
        return  [WXApi handleOpenURL:url delegate:[PayManager sharedManager]];
    }
}

@end
