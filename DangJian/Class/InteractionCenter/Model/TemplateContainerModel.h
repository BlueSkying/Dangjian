//
//  TemplateContainerModel.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

//
//  TemplateContainerModel.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateActionProtocol.h"
#import "TemplateRenderProtocol.h"
/**
 *  容器概念
 */
@protocol TemplateContainerProtocol <NSObject>

@required

- (NSInteger)numberOfChildModelsInContainer;

- (id <TemplateRenderProtocol>)childFloorModelAtIndex:(NSInteger)index;

@end

@class TemplateChannelModel;
@interface TemplateContainerModel : NSObject<TemplateContainerProtocol,TemplateActionProtocol,TemplateRenderProtocol>

//netList
@property (nonatomic,strong) NSNumber *identityId;
@property (nonatomic,strong) NSString *pattern;
@property (nonatomic,strong) NSMutableArray *totalArray;
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


@end

