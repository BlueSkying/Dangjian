//
//  InteractionCenterMyIntegralModel.m
//  DangJian
//
//  Created by Sakya on 17/6/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterMyIntegralModel.h"

@implementation InteractionCenterMyIntegralModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"InteractionCenterMyIntegralModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"integralId":@"id"};
}

- (NSInteger)numberOfChildModelsInContainer {
    
    return self.totalArray.count;
}
- (NSString *)floorIdentifier {
    return @"InteractionCenterMyIntegralCell";
}
- (id <TemplateRenderProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath {
    id<TemplateRenderProtocol> rowModel;
    if (self.totalArray.count > indexPath.row) {
        rowModel = [self.totalArray objectAtIndex:indexPath.row];
    }
    return rowModel;
}
- (void)pointsIsHeader:(BOOL)isHeader
               success:(void(^)(InteractionCenterMyIntegralModel *result)) successBlock
                failed:(void(^)(id error)) failedBlock {
    if (isHeader) {
        self.pageNo = 1;
        [self.totalArray removeAllObjects];
    } else {
        self.pageNo ++ ;
    }
    __weak typeof(self) weakSelf = self;
    [InterfaceManager pointsPage:self.pageNo success:^(id result) {
        InteractionCenterMyIntegralModel *intergralVo;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            intergralVo = [InteractionCenterMyIntegralModel mj_objectWithKeyValues:[[result objectForKey:@"data"] objectForKey:@"page"]];
            [weakSelf.totalArray addObjectsFromArray:intergralVo.list];
            intergralVo.totalArray = weakSelf.totalArray;
            intergralVo.points = [[result objectForKey:@"data"] objectForKey:@"points"];
        }
        successBlock(intergralVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}
@end
