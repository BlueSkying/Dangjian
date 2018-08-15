//
//  InteractionCenterMyIntegralModel.h
//  DangJian
//
//  Created by Sakya on 17/6/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TemplateContainerModel.h"

@interface InteractionCenterMyIntegralModel : TemplateContainerModel<TemplateRenderProtocol>
- (id <TemplateRenderProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath;

/**
 积分ID
 */
@property (nonatomic, copy) NSString *integralId;
//操作描述
@property (nonatomic, copy) NSString *desc;
//结果
@property (nonatomic, copy) NSString *result;
//当前积分达标百分比
@property (nonatomic, copy) NSString *points;

- (void)pointsIsHeader:(BOOL)isHeader
               success:(void(^)(InteractionCenterMyIntegralModel *result)) successBlock
                failed:(void(^)(id error)) failedBlock;

@end
