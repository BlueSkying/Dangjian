//
//  AppDelegate+EaseMob.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMob)
- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 注册推送返回的token
 */
- (void)easemobApplication:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end
