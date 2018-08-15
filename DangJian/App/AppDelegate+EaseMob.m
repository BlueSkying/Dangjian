//
//  AppDelegate+EaseMob.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "MainNavigationController.h"
#import "LoginViewController.h"

@implementation AppDelegate (EaseMob)
- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:NotificationloginStateChange
                                               object:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isHttpsOnly = [ud boolForKey:@"identifier_httpsonly"];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:appkey
                                         apnsCertName:apnsCertName
                                          otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:isHttpsOnly], kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    [ChatHelper shareHelper];
    
    if ([UserOperation shareInstance].loginState == YES){
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationloginStateChange object:@YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationloginStateChange object:@NO];
    }
}

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
    if (self.mainController) {
        [self.mainController didReceiveUserNotification:nil];
    }
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)easemobApplication:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}


// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
}

#pragma mark - login changed
- (void)loginStateChange:(NSNotification *)notification {

    //登录成功
    BOOL loginSuccess = [notification.object boolValue];
    UIViewController *navigationController = nil;

    if (loginSuccess) {//登陆成功加载主窗口控制器
        
        if (self.mainController == nil) {
            self.mainController = [[MainTabBarController alloc] initWithSelectIndex:1];
            navigationController = self.mainController;

        }else{
            navigationController  = self.mainController;
        }
        [ChatHelper shareHelper].mainVC = self.mainController;
        [UserManagemer loginSuccessCurrentView:nil];
        
    } else {
        //退出登录
        if (self.mainController) {
            [self.mainController.navigationController popToRootViewControllerAnimated:NO];
        }
        self.mainController = nil;
        [ChatHelper shareHelper].mainVC = nil;
        LoginViewController *loginController = [[LoginViewController alloc] init];
        navigationController = loginController;
        [UserManagemer userLogOutSuccess:^(id result) {
        }];
    }
    // options是动画选项
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        weakSelf.window.rootViewController = navigationController;        [UIView setAnimationsEnabled:oldState];
        [SKHUDManager hideAlert];

    } completion:^(BOOL finished) {
    }];


}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
