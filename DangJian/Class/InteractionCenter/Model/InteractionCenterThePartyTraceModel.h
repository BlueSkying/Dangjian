//
//  InteractionCenterThePartyTraceModel.h
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BasePageModel.h"
#import "TemplateContainerModel.h"

@interface InteractionCenterThePartyTraceModel : BasePageModel<TemplateRenderProtocol>

/**
 日期
 */
@property (nonatomic, copy) NSString *date;
/**
 党迹ID
 */
@property (nonatomic, copy) NSString *eventId;
/**
 党迹主题
 */
@property (nonatomic, copy) NSString *subject;
/**
 党迹类型： ZXKS("参加在线考试"), GZFK("完成工作反馈"),SXHB("完成思想汇报"),MZPY("参加民主评议"),ZXTP("参加在线投票")
 */
@property (nonatomic, copy) NSString *type;


//自加属性适配需要
/**
 cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 圆圈图片名字
 */
@property (nonatomic, copy) NSString *circleImageName;
/**
 箭头图片名字
 */
@property (nonatomic, copy) NSString *arrowImageName;
/**
 渐变色颜色
 */
@property (nonatomic, strong) UIColor *gradientColor;

@property (nonatomic, assign) NSInteger number;

//other add
- (id <TemplateRenderProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)trackQueryIsHeader:(BOOL)isHeader
                   success:(void(^)(InteractionCenterThePartyTraceModel *result)) successBlock
                    failed:(void(^)(id error)) failedBlock;
@end
