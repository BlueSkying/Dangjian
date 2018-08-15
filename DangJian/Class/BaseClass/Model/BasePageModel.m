//
//  BasePageModel.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BasePageModel.h"

@implementation BasePageModel


- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalArray;
}
@end
