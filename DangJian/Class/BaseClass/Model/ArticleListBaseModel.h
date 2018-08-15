//
//  ArticleListBaseModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleListBaseModel : NSObject
//所有文章列表都可用 也可继承于此model

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSArray *list;

/**
 页码
 */
@property (nonatomic, assign) NSInteger pageNo;

/**
 每页条数
 */
@property (nonatomic, assign) NSInteger pageSize;

/**
 全部页码
 */
@property (nonatomic, assign) NSInteger totalPage;

/**
 状态
 */
@property (nonatomic, copy) NSString *status;

/**
 作者
 */
@property (nonatomic, copy) NSString *author;

/**
 内容
 */
@property (nonatomic, copy) NSString *content;

/**
 图片地址
 */
@property (nonatomic, copy) NSString *imgUrl;

/**
 文章id
 */
@property (nonatomic, copy) NSString *articleID;

/**
 文章标题
 */
@property (nonatomic, copy) NSString *title;
/**
 阅读量
 */
@property (nonatomic, copy) NSString *count;
/**
 更新时间
 */
@property (nonatomic, copy) NSString *updateTime;
/**
 创建时间
 */
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *msg;


/**
 全部列表
 */
@property (nonatomic, strong) NSMutableArray *listArray;


/**
 请求文章列表

 @param articleType 文章列表类型
 @param successBlock 成功返回数据位ArticleListBaseModel 类型
 */
- (void)articleListType:(ArticleListRequestType)articleType
                success:(void(^)(ArticleListBaseModel *result)) successBlock
                 failed:(void(^)(id error)) failedBlock;
@end
