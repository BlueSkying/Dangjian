//
//  AppDelegate+Pay.h
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Pay)


/**
 向微信注册

 @param appid appid 微信开发者ID
 @param appdesc 应用附加信息，长度不超过1024字节
 */
- (void)wxRegisterApp:(NSString *)appid withDescription:(NSString *)appdesc;

@end
