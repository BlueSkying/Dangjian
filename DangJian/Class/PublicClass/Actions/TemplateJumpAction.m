//
//  TemplateJumpAction.m
//  MVP
//
//  Created by sunnyvale on 15/12/19.
//  Copyright © 2015年 sunnyvale. All rights reserved.
//

#import "TemplateJumpAction.h"


NSString * const TemplateJumpToProductDetail = @"ProductDetail";
NSString * const TemplateJumpToActivityM     = @"m";

@implementation TemplateJumpAction

- (void)performTaskWithCompletionBlock:(void(^)(void))completion
{
    if ([self.jumpToType isEqualToString:TemplateJumpToActivityM]) {
  
        
    }
}
@end
