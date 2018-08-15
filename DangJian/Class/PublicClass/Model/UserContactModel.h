//
//  UserContactModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserContactModel : NSObject<NSCoding>

@property (nonatomic, strong) NSArray *list;

/**
 组名
 */
@property (nonatomic, copy) NSString *name;

/**
 用户账号
 */
@property (nonatomic, strong) NSArray *user;

/**
 头像
 */
@property (nonatomic, copy) NSString *image;
/**
昵称（真实姓名）
 */
@property (nonatomic, copy) NSString *nickname;
/**
 姓名
 */
@property (nonatomic, copy) NSString *account;

/**
 版本号
 */
@property (nonatomic, copy) NSString *version;

/**
 头像占位图
 */
@property (nonatomic, copy) NSString *placeholderImage;


//通讯录接口
+ (void)contactListVersionShowPrompt:(BOOL)showPrompt
                             success:(void(^)(NSArray <UserContactModel *>* result)) successBlock
                              failed:(void(^)(id error)) failedBlock;
@end
