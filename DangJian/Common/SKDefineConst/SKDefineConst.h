//
//  SKDefineConst.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDefineConst : NSObject

/**通知－个人信息发生变化*/
UIKIT_EXTERN NSString *const NotificationUserInformationChange;
/**通知－登录状态变更的通知*/
UIKIT_EXTERN NSString *const NotificationloginStateChange;
/**通知－消息列表发生改变*/
UIKIT_EXTERN NSString *const NotificationMessageListChange;
/**通知-党费支付成功*/
UIKIT_EXTERN NSString *const NOTIFICATIONCOSTPAYSUCCESS;





/**常量－统一圆角度*/
UIKIT_EXTERN CGFloat const ControlsCornerRadius;
/**常量－新闻列表cell高度*/
UIKIT_EXTERN CGFloat const CellNewsListHeight;
/**常量－单行文本cell高度*/
UIKIT_EXTERN CGFloat const CellSingleTextHeight;
/**常量－新闻列表每页条数*/
UIKIT_EXTERN CGFloat const NewsListPageSize;
/**常量-右箭头大小*/
UIKIT_EXTERN CGFloat const CELLRIGHTARROWSIZE;



/**URL－积分描述*/
UIKIT_EXTERN NSString *const INTEGRALDESCRIBEURL;
/**RUL -*/


/**
 * 提示性语常量
 */
/**常量－网络错误提示*/
UIKIT_EXTERN NSString *const NetworkError;
/**常量－用户退出登录标示*/
UIKIT_EXTERN NSString *const UserLogOutSign;
/**常量－App推送token*/
UIKIT_EXTERN NSString *const DEVICE_TOKEN;



/**
Appkey
 */
/**常量－友盟SDK Appkey*/
UIKIT_EXTERN NSString *const AppkeyUMConfigSDK;
/**常量－环信SDK Appkey*/
UIKIT_EXTERN NSString *const AppkeyEaseMob;
/**常量－信鸽推送SDK*/
UIKIT_EXTERN uint32_t const AppIdXGPush;
UIKIT_EXTERN NSString *const AppkeyXGPush;
/**常量－支付SDK*/
UIKIT_EXTERN NSString *const APPIDALIPAYSDK;
UIKIT_EXTERN NSString *const APPIDWECHATSDK;



/*
 * IP地址 需要修改的配置等
 */
/**常量－环信配置证书 生产和测试*/
UIKIT_EXTERN NSString *const ApnsCertNameHyphenate;
/**常量－接口的IP地址*/
UIKIT_EXTERN NSString *const InterfaceIPAddress;
@end
