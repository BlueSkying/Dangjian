//
//  DuesVo.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BasePageModel.h"

@interface DuesVo : BasePageModel

/**
 金额
 */
@property (nonatomic, copy) NSString *amount;

/**
 唯一id
 */
@property (nonatomic, copy) NSString *listId;
/**
 状态：true（已缴费），false(未缴费)
 */
@property (nonatomic, assign) BOOL status;
/**
 年份
 */
@property (nonatomic, copy) NSString *year;
/**
 已缴费
 */
@property (nonatomic, assign) double feeReceived;
/**
 待缴金额
 */
@property (nonatomic, copy) NSString *payment;

- (void)duesQueryIsHeader:(BOOL)isHeader
                  account:(NSString *)account
                     mine:(BOOL)mine
                     year:(NSString *)year
                  success:(void(^)(DuesVo *result)) successBlock
                   failed:(void(^)(id error)) failedBlock;

@end
