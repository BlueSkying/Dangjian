//
//  HomeBannerVo.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBannerVo : NSObject

/**
 轮播图地址
 */
@property (nonatomic, copy) NSString *imageUrl;
/**
 轮播图链接地址
 */
@property (nonatomic, copy) NSString *targetUrl;
/**
 title
 */
@property (nonatomic, copy) NSString *title;

/**
 是否是外链
 */
@property (nonatomic, assign) BOOL targetOut;
/**
 轮播图id
 */
@property (nonatomic, copy) NSString *targetId;

@end
