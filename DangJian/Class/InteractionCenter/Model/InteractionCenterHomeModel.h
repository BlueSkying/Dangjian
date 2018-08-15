//
//  InteractionCenterHomeModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractionCenterHomeModel : NSObject


/**
 查询用户信息

 @param successBlock 返回对象
 */
+ (void)userInformationSuccess:(void(^)(UserInformationVo *result)) successBlock
                        failed:(void(^)(id error)) failedBlock;



////修改用户信息
//+ (void)userInformationModifyParams:(NSDictionary *)params
//                            success:(void(^)(UserInformationVo *result)) successBlock;
////修改用户信息
//+ (void)userInformationModifyImages:(NSArray *)images
//                           success :(void(^)(UserInformationVo *result)) successBlock;


/**
 提交用户信息

 @param paramters 用户信息参数包括图片
 @param successBlock 返回的 UserInformationVo实体
 */
+ (void)userInfomationCommitParamters:(NSMutableDictionary *)paramters
                              success:(void(^)(UserInformationVo *result)) successBlock
                               failed:(void(^)(id error)) failedBlock;




@end
