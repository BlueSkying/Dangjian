//
//  UserInformationVo.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationVo : NSObject<NSCoding>
/**
 用户ID
 */
@property (nonatomic, copy) NSString *userID;
/**
 用户账号
 */
@property (nonatomic, copy) NSString *account;
/**
 用户工号
 */
@property (nonatomic, copy) NSString *employeeNumber;
/**
 联系电话 用户手机号
 */
@property (nonatomic, copy) NSString *phone;

/**
 用户昵称（姓名）
 */
@property (nonatomic, copy) NSString *nickname;
/**
 头像
 */
@property (nonatomic, copy) NSString *image;
/**
 用户token
 */
@property (nonatomic, copy) NSString *token;
/**
 更新时间
 */
@property (nonatomic, copy) NSString *updateTime;
/**
 性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 籍贯
 */
@property (nonatomic, copy) NSString *nativePlace;
/**
 民族
 */
@property (nonatomic, copy) NSString *nation;
/**
 职称
 */
@property (nonatomic, copy) NSString *job;
/**
 学历
 */
@property (nonatomic, copy) NSString *education;
/**
 职务
 */
@property (nonatomic, copy) NSString *duty;
/**
 出生年月
 */
@property (nonatomic, copy) NSString *birth;
/**
 入党时间
 */
@property (nonatomic, copy) NSString *partyTime;
/**
 党内培训记录
 */
@property (nonatomic, copy) NSString *train;
/**
 奖励记录
 */
@property (nonatomic, copy) NSString *award;
/**
 惩罚记录
 */
@property (nonatomic, copy) NSString *punishment;
/**
 查询描述
 */
@property (nonatomic, copy) NSString *desc;
/**
返回状态
 */
@property (nonatomic, copy) NSString *status;
/**
 是否是领导
 */
@property (nonatomic, assign) BOOL leader;
/**
 组织标签
 */
@property (nonatomic, copy) NSString *orgId;

/**
 组织级别   0 党组 1机关党委 2党支部
 */
@property (nonatomic, copy) NSString *orgLevel;


/**
 操作描述
 */
@property (nonatomic, copy) NSString *msg;


@end
