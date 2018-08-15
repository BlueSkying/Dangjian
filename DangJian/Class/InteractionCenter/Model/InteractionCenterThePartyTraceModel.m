//
//  InteractionCenterThePartyTraceModel.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterThePartyTraceModel.h"
#import "NSString+Util.h"

NSString *const TemplateTrace          = @"Trace";

@interface InteractionCenterThePartyTraceModel ()

/**
 保存图片资源的数组
 */
@property (nonatomic, strong) NSMutableArray *resourceArray;

@end


@implementation InteractionCenterThePartyTraceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"eventId" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list" : @"InteractionCenterThePartyTraceModel"
             };
}
#pragma mark setter
//根据返回的类型
- (void)setType:(NSString *)type {
    
    
    if ([type isEqualToString:@"ZXKS"]) {
        
        type = @"参加在线考试";
    } else if ([type isEqualToString:@"GZFK"]) {
        type = @"完成工作反馈";

    } else if ([type isEqualToString:@"SXHB"]) {
        type = @"完成思想汇报";

    } else if ([type isEqualToString:@"MZPY"]) {
        type = @"参加民主评议";

    } else if ([type isEqualToString:@"ZXTP"]) {
        type = @"参加在线投票";
    }
    _type = type;
    //改变显示的文字类型拼接
    if (_subject != nil) {
        _subject =  [NSString stringWithFormat:@"%@：%@",type,_subject];
    }
}
- (void)setSubject:(NSString *)subject {
    
//    类型拼接
//    _subject为空 type不为空时
    if (!_subject && _type) {
        _subject =  [NSString stringWithFormat:@"%@：%@",_type,subject];
    } else {
        _subject = subject;
    }
}

#pragma mark - TemplateContainerProtocol

- (NSInteger)numberOfChildModelsInContainer {
    
    return self.totalArray.count;
}
- (id <TemplateRenderProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath
{
    TemplateContainerModel *floorModel;
    if (self.totalArray.count > indexPath.row) {
       floorModel = [self.totalArray objectAtIndex:indexPath.row];
    }
    id<TemplateRenderProtocol> rowModel = floorModel;
    return rowModel;
}
- (NSString *)getModelWithPattern:(NSString *)pattern
{
    if ([pattern isEqualToString:TemplateTrace]) {
        return @"InteractionCenterThePartyTraceModel";
    }
    return nil;
}
#pragma mark -  TemplateRenderProtocol
- (NSString *)floorIdentifier {
    return @"InteractionCenterThePartyTraceCell";
}

- (void)trackQueryIsHeader:(BOOL)isHeader
                   success:(void(^)(InteractionCenterThePartyTraceModel *result)) successBlock
                    failed:(void(^)(id error)) failedBlock {
    
    if (isHeader) {
        self.pageNo = 0;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager trackQueryPageNo:self.pageNo success:^(id result) {
        
        InteractionCenterThePartyTraceModel *listModel;
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            listModel = [InteractionCenterThePartyTraceModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.totalArray addObjectsFromArray:listModel.list];
//            暂时不需要用于颜色的顺序排序
            [weakSelf.totalArray enumerateObjectsUsingBlock:^(InteractionCenterThePartyTraceModel *object, NSUInteger idx, BOOL * _Nonnull stop) {
                object.number = idx;
            }];
            listModel.totalArray = weakSelf.totalArray;
        }
        successBlock(listModel);
    } failed:^(id error) {
        failedBlock(error);
    }];
}


#pragma mark -- getter
/**
 计算cell高度
 */
- (CGFloat)cellHeight {
    if (!_cellHeight) {

        CGFloat cellHeight = [_subject heightWithFont:FONT_16 constrainedToWidth:kScreen_Width - 80];
        cellHeight += 20;
        _cellHeight = cellHeight < 40 ? 40 : cellHeight;
        _cellHeight += 75;
    }
    return _cellHeight;
}

- (NSMutableArray *)resourceArray {
    if (!_resourceArray) {
        
        UIColor *redColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, kScreen_Width, 40) andColors:@[Color_systemNav_red_top,Color_systemNav_red_bottom]];
        UIColor *greenColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, kScreen_Width, 40) andColors:@[HexColor(@"#84be3f"),HexColor(@"#39ad4a")]];

        UIColor *blueColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, kScreen_Width, 40) andColors:@[HexColor(@"#00c8ff"),HexColor(@"#3fa1ed")]];

        UIColor *orangeColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, kScreen_Width, 40) andColors:@[HexColor(@"#f3a83b"),HexColor(@"#ef8b1e")]];

        NSArray *array =
        @[@{@"circleImageName":@"trace_redCircle_icon",                                           @"arrowImageName":@"trace_redArrow_icon",
            @"gradientColor":redColor},
          @{@"circleImageName":@"trace_greenCircle_icon",
            @"arrowImageName":@"trace_greenArrow_icon",
            @"gradientColor":greenColor},
          @{@"circleImageName":@"trace_blueCircle_icon",
            @"arrowImageName":@"trace_blueArrow_icon",
            @"gradientColor":blueColor},
          @{@"circleImageName":@"trace_orangeCircle_icon",
            @"arrowImageName":@"trace_orangeArrow_icon",
            @"gradientColor":orangeColor},];
        _resourceArray = [NSMutableArray arrayWithArray:array];
    }
    return _resourceArray;
}
- (NSString *)circleImageName {
    if (!_circleImageName) {
        NSInteger index = arc4random() % 4;
//        NSInteger index = self.number%4;
        if (self.resourceArray.count > index) {
            NSDictionary *dict = self.resourceArray[index];
            [self setValueWithParams:dict];
        }
    }
    return _circleImageName;
}
- (NSString *)arrowImageName {
    if (!_arrowImageName) {
        NSInteger index = arc4random() % 4;
//        NSInteger index = self.number%4;
        if (self.resourceArray.count > index) {
            NSDictionary *dict = self.resourceArray[index];
            [self setValueWithParams:dict];

        }
    }
    return _arrowImageName;
}
- (UIColor *)gradientColor {
    if (!_gradientColor) {
        NSInteger index = arc4random() % 4;
//        NSInteger index = self.number%4;
        if (self.resourceArray.count > index) {
            NSDictionary *dict = self.resourceArray[index];
            [self setValueWithParams:dict];
        }
    }
    return _gradientColor;
}
- (void)setValueWithParams:(NSDictionary *)dict {
    _circleImageName = [dict objectForKey:@"circleImageName"];
    _arrowImageName = [dict objectForKey:@"arrowImageName"];
    _gradientColor = [dict objectForKey:@"gradientColor"];
}

@end
