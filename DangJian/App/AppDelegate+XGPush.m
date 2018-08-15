//
//  AppDelegate+XGPush.m
//  DangJian
//
//  Created by Sakya on 17/5/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate+XGPush.h"
#import "XGPush.h"
#import "XGSetting.h"


@implementation AppDelegate (XGPush)

- (void)xgPushApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appId:(uint32_t)appId
                   appkey:(NSString *)appkey {
    
/*
    [XGPush isPushOn:^(BOOL isPushOn) {
        DDLogInfo(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
    }];
    [XGPush startApp:appId appKey:appkey];
    [XGPush handleLaunching:launchOptions successCallback:^{
        DDLogInfo(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        DDLogInfo(@"[XGDemo] Handle launching error");
    }];
 */
}
- (void)xgPushDidSilentReceiveRemoteNotification:(NSDictionary *)userInfo {
    
  /*
    DDLogInfo(@"[XGDemo] receive slient Notification");
    DDLogInfo(@"[XGDemo] userinfo %@", userInfo);
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
   */
}
- (void)xgPushApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /*
    NSLog(@"[XGDemo] receive Notification");
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
     */
}

- (void)xgPushHandleReceiveNotificationNotificationResponse:(UNNotificationResponse *)response {
    /*
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
     */
}
- (void)xgPushRegisterDeviceToken:(NSData *)deviceToken {
   /*
    [XGPush registerDevice:deviceToken successCallback:^{
        NSLog(@"[XGDemo] register push success");

        //重新绑定账号 防止token接受过慢
        UserInformationVo *user = [UserOperation shareInstance].user;
        NSString *account = !user.account ? [UserOperation shareInstance].account : user.account;
        if (account) {
            //    设备绑定账号
            [XGPush setAccount:account successCallback:^{
                DDLogInfo(@"绑定账号成功");
            } errorCallback:^{
            }];
        }
    } errorCallback:^{
        NSLog(@"[XGDemo] register push error");
    }];
    */
}

@end
