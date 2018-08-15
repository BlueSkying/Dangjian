//
//  TheoryLearningHomeModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheoryLearningHomeModel : NSObject
/**
 按钮模块的信息
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*itemArray;
/**
 评测信息
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*reviewArray;


/**
 轮播图数组
 */
@property (nonatomic, strong) NSArray *carousel;
/**
 在线学习列表
 */
@property (nonatomic, strong) NSArray *zxxx;
/**
 轮播图图片地址
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 轮播图文章地址
 */
@property (nonatomic, strong) NSMutableArray *targetsArray;


+ (void)homePageTheoryLearningSuccess:(void(^)(TheoryLearningHomeModel *result)) successBlock
                                  failed:(void(^)(id error)) failedBlock;


@end
