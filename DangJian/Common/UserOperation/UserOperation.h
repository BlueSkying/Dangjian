//
//  UserOperation.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_OPTIONS(NSInteger, NetworkLinkState) {
    
    /**无网络*/
    NetworkConditionNotReachable = 0,
    
    /**无线网络*/
    NetworkConditionWiFi = 1,
    
    /**手机网络*/
    NetworkConditionWWAN
};

@interface UserOperation : NSObject
//初始化方法
+(UserOperation *)shareInstance;


/*
 *用户信息
 */
@property (nonatomic, strong) UserInformationVo *user;

//注册手机号码
@property (nonatomic, copy) NSString *account;
//用户密码
@property (nonatomic, copy) NSString *password;
/**1登录 0未登录*/
@property (nonatomic, assign) BOOL loginState;
/**
 * token_app 请求接口用到 初登陆接口外都需要添加
 */
@property (nonatomic, copy) NSString *token_user;
//设备token
@property (nonatomic, strong) NSData *device_token;


/**
 联系人列表版本号  不同用户对应的不同
 */
@property (nonatomic, copy) NSString *version;

/**
 网络状况
 */
@property (nonatomic, assign) NetworkLinkState netState;

@end
