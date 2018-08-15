//
//  UserManagemer.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManagemer : NSObject


/**
 登录成功

 @param viewcontroller 当前控制器
 */
+ (void)loginSuccessCurrentView:(UIViewController *)viewcontroller;
/**
 退出登录管理
 */
+ (void)userLogOutSuccess:(void(^)(id result)) logOutBlock;

/**
 设置默认属性
 */
+ (void)defaultAttributeManage;

/**
 设置默认主题风格
 */
+ (void)defaultSubjectState;


/**
 配置友盟SDK
 */
+ (void)configationUMSDK;

@end
