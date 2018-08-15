//
//  UserOperation.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UserOperation.h"

//需要保存不同用户的token
#define UserToken [NSString stringWithFormat:@"token_%@",[UserOperation shareInstance].account]

/**缓存用户信息标示*/
#define UserInformationSign [NSString stringWithFormat:@"user_%@.archiver",[UserOperation shareInstance].account]

#define AddressBookVersion [NSString stringWithFormat:@"addressBook_%@",[UserOperation shareInstance].account]


@implementation UserOperation

+ (UserOperation *)shareInstance {
    
    static UserOperation *obj = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        obj = [[UserOperation alloc] init];
    });
    return obj;
}

//密码
- (void)setPassword:(NSString *)password {
    
    password = [Helper base64StringFromText:password];
    [MyDefaults setObject:password forKey:@"password"];
    [MyDefaults synchronize];
}
- (void)setDevice_token:(NSData *)device_token {
    
    [MyDefaults setObject:device_token forKey:DEVICE_TOKEN];
    [MyDefaults synchronize];
}
//账号
- (void)setAccount:(NSString *)account {
    
    [MyDefaults setObject:account forKey:@"account"];
    [MyDefaults synchronize];
    
}
//登录状态
- (void)setLoginState:(BOOL)loginState {
   
    [MyDefaults setObject:@(loginState) forKey:@"loginState"];
    [MyDefaults synchronize];
}

/**
 版本号
 */
- (void)setVersion:(NSString *)version {
    
    [MyDefaults setObject:version forKey:AddressBookVersion];
    [MyDefaults synchronize];
}


//token
- (void)setToken_user:(NSString *)token_user {
    
    NSString *token = token_user;
    if ([token_user isKindOfClass:[NSNull class]]) {
        token = nil;
    }
    [MyDefaults setObject:token forKey:UserToken];
    [MyDefaults synchronize];
}
/**缓存用户信息*/
- (void)setUser:(UserInformationVo *)user {
    
    if (user) {
        [self saveinfo:user];
    } else {
        [self clearUserInfo];
    }
}

//返回登录状态
- (BOOL)loginState {
    
    BOOL loginState = [[MyDefaults objectForKey:@"loginState"] boolValue];
    return loginState;
}
- (NSData *)device_token {
    
    NSData *deviceToken = [MyDefaults objectForKey:DEVICE_TOKEN];
    return deviceToken;
}

- (NSString *)password {
    
    NSString *password = [MyDefaults objectForKey:@"password"];
    password = [Helper textFromBase64String:password];
    return password;
}
- (NSString *)account {
    
    NSString *account = [MyDefaults objectForKey:@"account"];
    return account;
}
- (NSString *)version {
   
    NSString *version = [MyDefaults objectForKey:AddressBookVersion];
    return version;
}
/**token*/
- (NSString *)token_user {
    
    NSString *token = [MyDefaults objectForKey:UserToken];
    return token;
}

//用户信息
- (UserInformationVo *)user {
    
    UserInformationVo *user = [self getUserinfo];
    return user;
}
/**
 数据持久化
 */
/**系统自带加密算法*/
//清理用户信息

- (void)clearUserInfo {
    
    NSString *path = [self documentPathIsCreat:NO];
    UserInformationVo *user;
    [NSKeyedArchiver archiveRootObject:user toFile:path];
}

- (NSString *)documentPathIsCreat:(BOOL)isCreat {
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documents = [documents stringByAppendingPathComponent:@"User"];
    if (isCreat) {
        NSFileManager *filemanage = [NSFileManager defaultManager];
        BOOL isDir;
        BOOL exit =[filemanage fileExistsAtPath:documents isDirectory:&isDir];
        if (!exit || !isDir) {
            [filemanage createDirectoryAtPath:documents withIntermediateDirectories:YES attributes:nil error:nil];
        }else {
            DDLogInfo(@"userFilePath is exists.");
        }
    }
    NSString *path = [documents stringByAppendingPathComponent:UserInformationSign];//拓展名可以自己随便取
    return path;
}
//保存
- (void)saveinfo:(UserInformationVo *)user {
    
    if(nil != user) {
        NSString *path = [self documentPathIsCreat:YES];
        // 判断文件夹是否存在，如果不存在，则创建
        [NSKeyedArchiver archiveRootObject:user toFile:path];
    }
}
//得到用户信息
- (UserInformationVo *)getUserinfo {
    
    NSString *path = [self documentPathIsCreat:NO];
    UserInformationVo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return user;
}

 @end
