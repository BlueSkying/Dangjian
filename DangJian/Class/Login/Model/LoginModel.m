//
//  LoginModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "LoginModel.h"
#import "UserFmdbManager.h"

@implementation LoginModel

+ (void)loginAccount:(NSString *)account
            password:(NSString *)password
             success:(void(^)(UserInformationVo *result)) successBlock {
    
    [InterfaceManager loginAccount:account password:password success:^(id result) {
        UserInformationVo *user;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            user = [UserInformationVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            //更新数据库用户信息
            [UserFmdbManager editUserInfoUserName:account nickName:user.nickname image:user.image groupName:@"个人"];
        } else {
            NSInteger errorCode = [[result objectForKey:@"status"] integerValue];
            if (errorCode == 4) {
                [SKHUDManager showBriefAlert:@"账号或密码错误！"];
            } else if (errorCode == 3) {
                [SKHUDManager showBriefAlert:@"系统异常，请稍后重试..."];
            } else {
                [SKHUDManager showBriefAlert:@"操作失败"];
            }
        }
        
        successBlock(user);
    }];
}
@end
