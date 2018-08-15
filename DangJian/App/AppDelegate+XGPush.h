//
//  AppDelegate+XGPush.h
//  DangJian
//
//  Created by Sakya on 17/5/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XGPush)

//注册信鸽
- (void)xgPushApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appId:(uint32_t)appId
                   appkey:(NSString *)appkey;

//收到离线推送的消息
- (void)xgPushHandleReceiveNotificationNotificationResponse:(UNNotificationResponse *)response;
//绑定token
- (void)xgPushRegisterDeviceToken:(NSData *)deviceToken;
//收到静默推送
- (void)xgPushDidSilentReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)xgPushApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
