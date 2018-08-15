//
//  AppDelegate+RegisterApns.m
//  DangJian
//
//  Created by Sakya on 17/5/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate+RegisterApns.h"

@implementation AppDelegate (RegisterApns)

- (void)registerRemoteNotification {
    
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    //方法一用设备型号判断设备
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    }
#else
    if (sysVer > 8) {
        [self registerPush8to9];
    }
#endif
    
    //方法二用方法头判断
    /**
     
     ios 10 以上有此类
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        
    }
     iOS 10以下 iOS 8以上有此方法
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        
    }
     */
}
- (void)registerPush10 {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
#if !TARGET_IPHONE_SIMULATOR
            [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
        }
    }];
#endif
}

- (void)registerPush8to9 {
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
