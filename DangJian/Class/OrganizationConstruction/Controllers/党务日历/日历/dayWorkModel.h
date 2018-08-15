//
//  dayWorkModel.h
//  ThePartyBuild
//
//  Created by TuringLi on 17/5/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

//事项列表Model
@interface dayWorkModel : NSObject

/**事项内容*/
@property (nonatomic, copy) NSString *content;

/**事项标题*/
@property (nonatomic, copy) NSString *subject;

/**执行时间*/
@property (nonatomic, copy) NSString *doDate;

/**自加属性 转换后的执行时间*/
@property (nonatomic, copy) NSString *workDayDate;

@end
