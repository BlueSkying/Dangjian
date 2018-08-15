//
//  DemocraticAppraisalVo.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemocraticAppraisalVo : NSObject


@property (nonatomic, strong) NSArray *data;

/**
 评议内容
 */
@property (nonatomic, copy) NSString *content;
/**
创建时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
  映射 内容id  对应的是在线投票的id 或者民主评议的id
 */
@property (nonatomic, copy) NSString *contentId;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 更新时间
 */
@property (nonatomic, copy) NSString *updateTime;
/**
 已经评议人
 */
@property (nonatomic, copy) NSString *voter;

/**
 民主评议ID
 */
@property (nonatomic, copy) NSString *apprId;
/**
 选项
 */
@property (nonatomic, copy) NSString *choice;
/**
 选项数组
 */
@property (nonatomic, strong) NSArray *choiceArray;

/**
 选择结果
 */
@property (nonatomic, copy) NSString *choiceResult;
/**
 评议结果 或投票结果
 */
@property (nonatomic, copy) NSString *evaluate;
/**
 评选对象
 */
@property (nonatomic, copy) NSString *userName;
/**
评选结果序号
 */
@property (nonatomic, copy) NSString *results;
/**
 选项ID
 */
@property (nonatomic, copy) NSString *ids;
/**
 是否单选
 */
@property (nonatomic, assign) BOOL radio;

/**
 图片 只有在线投票才有
 */
@property (nonatomic, copy) NSString *image;


/**
 在线投票ID
 */
@property (nonatomic, copy) NSString *voteId;



@end
