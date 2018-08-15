//
//  FmdbTool.m
//  UnionProgarm
//
//  Created by Sakya on 17/2/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "FmdbTool.h"


//统一数据库表名字
#define sqliteTableName @"USERFRIENDLIST.sqlite"

@interface FmdbTool ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end
static FmdbTool *_instance = nil;

@implementation FmdbTool
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [FmdbTool shareInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [FmdbTool shareInstance];
}

+ (NSString *)dbPath {
    
    return [self dbPathWithDirectoryName:nil];
}

+ (NSString *)dbPathWithDirectoryName:(NSString *)directoryName
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (directoryName == nil || directoryName.length == 0) {
        docsdir = [docsdir stringByAppendingPathComponent:@"ZJSDDJ"];
    } else {
        docsdir = [docsdir stringByAppendingPathComponent:directoryName];
    }
    
    // 判断文件夹是否存在，如果不存在，则创建
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }else {
        DDLogInfo(@"userFilePath is exists.");
    }
    //表路径
    NSString * dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",sqliteTableName]];
    DDLogInfo(@"%@",dbpath);
    _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbpath];
    //创建表
    //userAccount 用户账号 
    //nickName 用户昵称
    //image 用户头像地址
    //groupName 用户分组名字
    [_instance.dbQueue inDatabase:^(FMDatabase *db) {
        //创建用户信息表
        BOOL b = [db executeUpdate:@"create table if not exists userInfo(ID integer primary key autoincrement,userAccount text,nickName text,image text,groupName text)"];
        if(!b){
            DDLogInfo(@"创建消息表失败");
        }
        //创建用户通讯录表
        BOOL addressBookTable = [db executeUpdate:@"create table if not exists addressBook(ID integer primary key autoincrement,userAccount text,addressBookVo blob)"];
        if(!addressBookTable){
            DDLogInfo(@"创建消息表失败");
        }
        
    }];
    return dbpath;
}


- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName
{
    if (_instance.dbQueue) {
        _instance.dbQueue = nil;
    }
    _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:[FmdbTool dbPathWithDirectoryName:directoryName]];
    
    return YES;
}
//可能需要添加新的表字段
- (void)addNewTableColumn {
    /**
     if (![db columnExists:@"新增字段" inTableWithName:@"表名"]){
     
     }
     NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"表名",@"新增字段"];
     BOOL worked = [db executeUpdate:alertStr];
     if(worked){
     NSLog(@"插入成功");
     }else{
     NSLog(@"插入失败");
     }
     */
}
@end
