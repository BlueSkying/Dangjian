//
//  InteractionCenterHomeModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterHomeModel.h"
#import "UserFmdbManager.h"

@implementation InteractionCenterHomeModel

+ (void)userInformationSuccess:(void(^)(UserInformationVo *result)) successBlock
                        failed:(void(^)(id error)) failedBlock {
    
    [InterfaceManager userInformationObtainSuccess:^(id result) {

        UserInformationVo *user;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            user = [UserInformationVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            DDLogInfo(@"%@",user);
        }
        successBlock(user);
    }];
}
+ (void)userInfomationCommitParamters:(NSMutableDictionary *)paramters
                              success:(void(^)(UserInformationVo *result)) successBlock
                               failed:(void(^)(id error)) failedBlock {
    
    
    [InterfaceManager userInformationCommitParamater:paramters success:^(id result) {
        
        UserInformationVo *user;
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            user = [UserInformationVo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [UserFmdbManager editUserInfoUserName:[UserOperation shareInstance].account nickName:user.nickname image:user.image groupName:@"个人"];
            [UserOperation shareInstance].user = user;
        }
        
        successBlock(user);
    } failed:^(id error) {
        
        failedBlock(error);
    }];
}

@end
