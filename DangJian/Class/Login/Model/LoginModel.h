//
//  LoginModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

+ (void)loginAccount:(NSString *)account
            password:(NSString *)password
             success:(void(^)(UserInformationVo *result)) successBlock;
@end
