//
//  PayManager.m
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PayManager.h"


@implementation PayManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PayManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;

}
- (void)payChannel:(PaymentChannelMode)channel
    payOrderString:(NSString *)string {
    
    
    SKNSAssertNil(!string, @"order information is nil");
    switch (channel) {
        case PaymentModeAlipay:
            [self alipayPayOrderString:string];

            break;
        case PaymentModeWeChat:
            [self wxPayJumpToBizString:string];

            break;
        default:
            break;
    }
}
//调动微信支付
- (void)wxPayJumpToBizString:(NSString *)string {
    
    //签名信息
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
    req.package             = [dict objectForKey:@"packageValue"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}
//调用支付宝支付
- (void)alipayPayOrderString:(NSString *)orderString {
//    /步骤、调用支付结果开始支付=========================/
    __weak typeof(self) weakSelf = self;

    NSString *appScheme = @"dangjianpay";//url types设置
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [weakSelf dealAlipayResult:resultDic];
    }];
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的

- (void)onResp:(BaseResp*)resp {
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        BOOL state;
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付成功！";
                state = YES;
                break;
            case -1:
                payResoult = @"支付失败！";
                state = NO;
                break;
            case -2:
                payResoult = @"取消支付！";
                state = NO;

                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                state = NO;

                break;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvPayState:result:)]) {
            [_delegate managerDidRecvPayState:state result:payResoult];
        }
        
    }
}
- (void)onReq:(BaseReq*)req {
    
    
    
}
- (void)dealAlipayResult:(NSDictionary *)resultDic {
    
    DDLogInfo(@"reslut = %@",resultDic);
    NSString *resultString;
    BOOL state = [[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"] ? YES : NO;
    switch ([[resultDic objectForKey:@"resultStatus"] integerValue]) {
        case 9000:
            resultString  = @"支付成功！";
            
            break;
        case 4000:
            resultString  = @"系统异常！";
            
            break;
        case 6001:
            resultString  = @"取消支付！";
            
            break;
        case 6002:
            resultString  = @"网络连接出错！";
            
            break;
        default:
            resultString  = @"系统错误，请稍后重试！";
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvPayState:result:)]) {
        [_delegate managerDidRecvPayState:state result:resultString];
    }
}

@end
