//
//  UserFmdbManager.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserContactModel.h"

@interface UserFmdbManager : NSObject


/**
 更新组用户

 @param users 用户数组
 @param groupName 组名字
 */
+ (void)updateUsers:(NSArray *)users groupName:(NSString *)groupName;
/**
 查询用户信息

 @param userName 用户账号
 @return 用户信息实体
 */
+ (UserContactModel *)searchUserName:(NSString *)userName;


/**
 编辑用户信息

 @param userName 用户账号
 @param nickName 用户昵称
 @param image 用户头像
 @param groupName 用户群组
 
 */
+ (void)editUserInfoUserName:(NSString *)userName
                    nickName:(NSString *)nickName
                       image:(NSString *)image
                   groupName:(NSString *)groupName;

#pragma mark -- 通讯录列表操作

/**
 查询用户通讯录实体

 @param userAccount 用户账号
 */
+ (UserContactModel *)searchAddressBookUserAccount:(NSString *)userAccount;

/**
 修改用户通讯录列表

 @param addressBookVo 通讯录列表实体
 @param userAccount 用户帐号
 */
+ (void)eidtAddressBookVo:(UserContactModel *)addressBookVo userAccount:(NSString *)userAccount;

@end
