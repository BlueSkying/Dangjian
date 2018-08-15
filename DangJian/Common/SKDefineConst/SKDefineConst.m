//
//  SKDefineConst.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKDefineConst.h"

@implementation SKDefineConst

#pragma mark - const
/**常量－用户退出登录标示*/
NSString *const UserLogOutSign = @"LogOutSign";
/**常量－ 统一圆角度*/
CGFloat const ControlsCornerRadius = 4.0f;


/**常量－新闻列表cell高度*/
CGFloat const CellNewsListHeight = 85.0f;
/**常量－单行文本cell高度*/
CGFloat const CellSingleTextHeight = 45.0f;
/**常量－新闻列表每页条数*/
CGFloat const NewsListPageSize = 20;
/**常量-右箭头大小*/
CGFloat const CELLRIGHTARROWSIZE = 15;



/**常量－友盟SDK Appkey*/
NSString *const AppkeyUMConfigSDK = @"591137d8ae1bf85986001e1c";
/**常量－环信SDK Appkey*/
NSString *const AppkeyEaseMob = @"1111161019178961#dangjian";
/**常量－信鸽推送SDK*/
uint32_t const AppIdXGPush = 2200259607;
NSString *const AppkeyXGPush = @"IID964GV81KK";


/**常量－支付SDK*/
NSString *const APPIDALIPAYSDK = @"2088421644927885";
NSString *const APPIDWECHATSDK = @"wx6f1f9181c2f1e6c7";

//提示语
NSString *const NetworkError = @"网络连接失败，请稍后重试";

#pragma mark - notification
/**常量－用户信息改变*/
NSString *const NotificationUserInformationChange = @"NotificationUserInformationChange";
/**通知－登录状态变更的通知*/
NSString *const NotificationloginStateChange = @"NotificationloginStateChange";
/**通知－消息列表发生改变*/
NSString *const NotificationMessageListChange = @"NotificationMessageListChange";
/**通知-党费支付成功*/
NSString *const NOTIFICATIONCOSTPAYSUCCESS = @"NotificationCostPaySuccess";

NSString *const INTEGRALDESCRIBEURL = @"/rest/user/pointsDesc";

/**常量－App推送token*/
NSString *const DEVICE_TOKEN = @"device_token";



#pragma mark - server configuration
#if DebugEnvironmentServer == 0
//本地测试
//常量－环信配置证书 生产和测试
NSString *const ApnsCertNameHyphenate = @"apns_development";
//常量－接口的IP地址
NSString *const InterfaceIPAddress = @"http://192.168.31.88:8082";
#elif DebugEnvironmentServer == 1
//准生产
//常量－环信配置证书 生产和测试
NSString *const ApnsCertNameHyphenate = @"apns_development";
//常量－接口的IP地址
NSString *const InterfaceIPAddress = @"http://120.92.78.172:9080/party";
#else
//正式服务器
//常量－环信配置证书 生产和测试
NSString *const ApnsCertNameHyphenate = @"apns_production";
//常量－接口的IP地址
NSString *const InterfaceIPAddress = @"http://10.1.120.83:48080/deyangparty/"; //https://abadangjian.idocker.com.cn


#endif

@end
