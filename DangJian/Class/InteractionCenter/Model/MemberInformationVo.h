//
//  MemberInformationVo.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAlterView.h"


@interface CellCustomVo : NSObject

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) id content;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) SKPromptStyle alterStyle;

@property (nonatomic, assign) SKPromptNavBarType alterNavBarType;

@end

@interface MemberInformationVo : NSObject



/**

 */
@property (nonatomic, strong) NSMutableArray <CellCustomVo *>*dataArray;
/**
 右侧的信息
 */
@property (nonatomic, strong) NSMutableArray <NSArray *>*informationArray;



/**
 更新用户信息

 @param user 用户信息Vo
 */
- (NSArray *)updateUserInfo:(UserInformationVo *)user;

/**
 字段验证学历 中英文切换

 @param isCommit 是否是提交上传的字段
 @param text 输入字段
 @return 返回字段
 */
+ (NSString *)checkIsCommit:(BOOL)isCommit text:(NSString *)text;
@end
