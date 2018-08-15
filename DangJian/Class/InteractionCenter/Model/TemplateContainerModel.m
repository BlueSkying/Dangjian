//
//  TemplateContainerModel.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TemplateContainerModel.h"

@implementation TemplateContainerModel

#pragma mark - TemplateContainerProtocol

- (NSInteger)numberOfChildModelsInContainer {
    return [self.totalArray count];
}

- (id <TemplateRenderProtocol>)childFloorModelAtIndex:(NSInteger)index {
    return nil;
}

- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalArray;
}
#pragma mark -  TemplateRenderProtocol
- (NSString *)floorIdentifier
{
    return nil;
}
@end
