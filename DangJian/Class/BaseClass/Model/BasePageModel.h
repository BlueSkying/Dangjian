//
//  BasePageModel.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasePageModel : NSObject
//有分页的的Vo需要继承此Model


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

//增加的为了添加所有数据
@property (nonatomic, strong) NSMutableArray *totalArray;


@end
