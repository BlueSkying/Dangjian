//
//  UserFmdbManager.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UserFmdbManager.h"
#import "FmdbTool.h"


@implementation UserFmdbManager
//判断该用户消息是否已经存在
+(BOOL)existUserName:(NSString *)userName {
  
    __block BOOL isExist=NO;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from userInfo where userAccount=?",userName];
        while ([result next]) {
            isExist = YES;
        }
        [result close];
    }];
    return isExist;
}

+ (void)updateUsers:(NSArray *)users groupName:(NSString *)groupName {
    
    [users enumerateObjectsUsingBlock:^(UserContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [UserFmdbManager editUserInfoUserName:obj.account nickName:obj.nickname image:obj.image groupName:groupName];
    }];
    
}
+ (void)editUserInfoUserName:(NSString *)userName
                      nickName:(NSString *)nickName
                         image:(NSString *)image
                   groupName:(NSString *)groupName {
    if ([UserFmdbManager existUserName:userName]) {
        [UserFmdbManager updateUserInfoUserName:userName nickName:nickName image:image groupName:groupName];
    } else {
        
        [UserFmdbManager insertUserInfoUserName:userName nickName:nickName image:image groupName:groupName];
    }
}
+ (BOOL)insertUserInfoUserName:(NSString *)userName
                      nickName:(NSString *)nickName
                         image:(NSString *)image
                     groupName:(NSString *)groupName {
    
    __block  BOOL b;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        
        b=[db executeUpdate:@"insert into userInfo(userAccount,nickName,image,groupName) values(?,?,?,?)",userName,nickName,image,groupName];
    }];
    return b;
}

+ (BOOL)updateUserInfoUserName:(NSString *)userName
                      nickName:(NSString *)nickName
                         image:(NSString *)image
                     groupName:(NSString *)groupName {
    
    __block BOOL b;
    
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        b=[db executeUpdate:@"UPDATE userInfo SET nickName=?, image = ?, groupName = ? WHERE userAccount=?",nickName,image,groupName,userName];
    }];
    
    return b;
}


+ (UserContactModel *)searchUserName:(NSString *)userName {
    
    __block UserContactModel *user = [UserContactModel new];;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        
        //       时间戳和创建时间同增同减降序排列
        FMResultSet *result=[db executeQuery:@"select * from userInfo where userAccount=?",userName];
        
        if (result) {
            
            while ([result next]) {
                
                user.image = [result stringForColumn:@"image"];
                user.nickname = [result stringForColumn:@"nickName"];
                user.account = [result stringForColumn:@"userAccount"];
                user.name = [result stringForColumn:@"groupName"];
                
            }
        }
    }];
    return user;
}


          /*************操作用户通讯录列表***************/


+ (void)eidtAddressBookVo:(UserContactModel *)addressBookVo userAccount:(NSString *)userAccount {
    
    if ([UserFmdbManager existAddressBookUserAccount:userAccount]) {
        [UserFmdbManager updateAddressBookVo:addressBookVo userAccount:userAccount];
        
    } else {
        [UserFmdbManager insertAddressBookVo:addressBookVo userAccount:userAccount];
    }
}
+ (BOOL)existAddressBookUserAccount:(NSString *)userAccount {
    
    __block BOOL isExist=NO;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from addressBook where userAccount=?",userAccount];
        while ([result next]) {
            isExist = YES;
        }
        [result close];
    }];
    return isExist;
}

+ (BOOL)insertAddressBookVo:(UserContactModel *)addressBookVo
                userAccount:(NSString *)userAccount{
    //将对象转为二进制
    NSData *addressBookData=[NSKeyedArchiver archivedDataWithRootObject:addressBookVo];
    __block  BOOL b;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        
        b=[db executeUpdate:@"insert into addressBook(userAccount,addressBookVo) values(?,?)",userAccount,addressBookData];
    }];
    return b;
    
}
+ (BOOL)updateAddressBookVo:(UserContactModel *)addressBookVo
                userAccount:(NSString *)userAccount{
    
    __block BOOL b;
    
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    NSData *addressBookData=[NSKeyedArchiver archivedDataWithRootObject:addressBookVo];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        b=[db executeUpdate:@"update addressBook set addressBookVo=? where userAccount=?",addressBookData,userAccount];
    }];
    return b;
}
+ (UserContactModel *)searchAddressBookUserAccount:(NSString *)userAccount {
    
    __block UserContactModel *user = [UserContactModel new];;
    FmdbTool *dbOperation = [FmdbTool shareInstance];
    [dbOperation.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result=[db executeQuery:@"select * from addressBook where userAccount=?",userAccount];
        if (result) {
            while ([result next]) {
                user = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"addressBookVo"]];
            }
        }
    }];
    return user;
}
@end
