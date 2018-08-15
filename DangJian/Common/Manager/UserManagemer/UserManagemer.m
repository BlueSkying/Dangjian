//
//  UserManagemer.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UserManagemer.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "UMMobClick/MobClick.h"
#import "FmdbTool.h"
#import "XGPush.h"

@implementation UserManagemer

//数据的管理
+ (void)userLogOutSuccess:(void(^)(id result)) logOutBlock {
    
    
    [UserOperation shareInstance].loginState = NO;
    [UserOperation shareInstance].account = nil;
    [UserOperation shareInstance].password = nil;

    //    删除设备绑定的账号
    /*
    [XGPush delAccount:^{
    } errorCallback:^{
    }];
*/
    /**
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // 获取当前app单例
    if ([app.window.rootViewController isKindOfClass:[LoginViewController class]]) {
        [[Helper activityViewController] dismissViewControllerAnimated:YES completion:^{
            NSLog(@"退出成功");
            logOutBlock(@"1");
        }];
    } else{
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [Helper activityViewController].view.window.rootViewController = loginView;
        logOutBlock(@"1");

    }
     */
}
+ (void)loginSuccessCurrentView:(UIViewController *)viewcontroller {
    
    
    [UserOperation shareInstance].loginState = YES;
    UserInformationVo *user = [UserOperation shareInstance].user;
    NSString *account = !user.account ? [UserOperation shareInstance].account : user.account;
    if (account) {
        //    设备绑定账号
        /*
        [XGPush setAccount:account successCallback:^{
            DDLogInfo(@"绑定账号成功");
        } errorCallback:^{
        }];
         */
    }

    //修改数据库路径
    [[FmdbTool shareInstance] changeDBWithDirectoryName:[UserOperation shareInstance].account];
    [[ChatHelper shareHelper] asyncGroupFromServer];
    [[ChatHelper shareHelper] asyncConversationFromDB];
    [[ChatHelper shareHelper] asyncPushOptions];
    
}


+ (void)defaultSubjectState {
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
  
    navigationBarAppearance.translucent = NO;
        //导航标题白色
    [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_9_0
    
    
#endif
    //  电量条白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //设置每次进入角标清除掉
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}
+ (void)configationUMSDK {
    
    UMConfigInstance.appKey = AppkeyUMConfigSDK;
    UMConfigInstance.channelId = @"App Store";
    //版本号统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}
+ (void)defaultAttributeManage {}
@end
