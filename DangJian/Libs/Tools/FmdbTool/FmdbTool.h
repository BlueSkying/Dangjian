//
//  FmdbTool.h
//  UnionProgarm
//
//  Created by Sakya on 17/2/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface FmdbTool : NSObject

//创建数据库字段
/*********用户信息表*********/
//userInfo   表名
//userAccount 用户账号
//nickName 用户昵称
//image 用户头像地址
//groupName 用户分组名字

/*********联系人列表表*********/
//addressBook  表名
//


@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;
/**
 *  单列 操作数据库保证唯一
 */
+ (instancetype)shareInstance;
/**
 *  数据库路径
 */
+ (NSString *)dbPath;
/**
 *  切换数据库
 */
- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;



@end
