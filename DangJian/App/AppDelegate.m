//
//  AppDelegate.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/21.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "LoginModel.h"
#import "AppDelegate+RegisterApns.h"
#import "AppDelegate+XGPush.h"
#import "AppDelegate+Pay.h"


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化sdk
    [self configurationSDKApplication:application options:launchOptions];
    //设置主题
    [self setUpSubjectState];
    //登录控制
    [self setUpLoginControl];
//设置默认属性
    [self setUpDefaultAttribute];
    //支付相关
    [self setUpPay];
    //输出日志
    [self initDDLog];

    [self registerRemoteNotificationLocalDeventokenWithApplication:application];
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}
- (void)setUpSubjectState {
    [UserManagemer defaultSubjectState];
}

//本地保存token用来处理
- (void)registerRemoteNotificationLocalDeventokenWithApplication:(UIApplication *)application {
    
    NSData *deviceToken = [UserOperation shareInstance].device_token;
    DDLogDebug(@"deviceToken%@",deviceToken);
    if (deviceToken) {
        //注册环信的推送
        [self easemobApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        //信鸽注册的推送
        [self xgPushRegisterDeviceToken:deviceToken];
    }
}
#pragma mark - 属性设置
- (void)setUpDefaultAttribute {
   

    
}
- (void)configurationSDKApplication:(UIApplication *)application
                            options:(NSDictionary *)launchOptions {
    
    //注册推送 获取token
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    [self registerRemoteNotification];
    
    //-- 配置友盟sdk
    [UserManagemer configationUMSDK];
    
    //-- 配置信鸽SDK
    [self xgPushApplication:application didFinishLaunchingWithOptions:launchOptions appId:AppIdXGPush appkey:AppkeyXGPush];
    //--- 配置环信SDK
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifixiner_appkey"];
    if (!appkey) {
        appkey = AppkeyEaseMob;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    // Init SDK，detail in AppDelegate+EaseMob.m
    // SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:ApnsCertNameHyphenate
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    NSString *s = [[EMClient sharedClient] version];
    DDLogInfo(@"s---------%@", s);
    
}
- (void)setUpLoginControl {
    //开启网络状况监测
    [NetworkLib netReachability];
    if ([UserOperation shareInstance].loginState == YES) {
        [self login];
    }
}
- (void)setUpPay {
    [WXApi registerApp:APPIDWECHATSDK];
    [self wxRegisterApp:APPIDWECHATSDK withDescription:nil];
}
- (void)initDDLog {
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}
#pragma mark login
//登录
- (void)login {
    
    NSString *account = [UserOperation shareInstance].account;
    NSString *password = [UserOperation shareInstance].password;
    [LoginModel loginAccount:account password:password success:^(UserInformationVo *result) {
        if (result) {
         
            [UserOperation shareInstance].token_user = result.token;
            [UserOperation shareInstance].user = result;
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationloginStateChange object:@NO];
        }
    }];
}

//--获取服务器返回token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DDLogDebug(@"deviceToken%@",deviceToken);
    if (![[UserOperation shareInstance].device_token isEqual:deviceToken] &&
        deviceToken != nil) {
        [UserOperation shareInstance].device_token = deviceToken;
        //注册环信的推送
        [self easemobApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        //信鸽注册的推送
        [self xgPushRegisterDeviceToken:deviceToken];
    }
}
//收到通知回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
    [self xgPushApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    [self xgPushHandleReceiveNotificationNotificationResponse:response];
    if (_mainController) {
        [_mainController didReceiveUserNotification:response.notification];
    }
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif
/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self xgPushDidSilentReceiveRemoteNotification:userInfo];
    
}


#pragma mark - allowRotation
/**是否允许横屏*/
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
