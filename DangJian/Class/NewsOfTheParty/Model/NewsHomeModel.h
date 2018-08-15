//
//  NewsHomeModel.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

//HomeBannerVo


@interface NewsHomeModel : NSObject
/**
 按钮模块的信息
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*itemArray;
/**
 专题下面模块
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*subjectArray;



/**
 轮播图图片地址
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/**
 轮播图文章地址
 */
@property (nonatomic, strong) NSMutableArray *targetsArray;

+ (void)homePageThePartyBuildNewsSuccess:(void(^)(NewsHomeModel *result)) successBlock
                                  failed:(void(^)(id error)) failedBlock;
@end
