//
//  DemocraticAppraisalVo.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DemocraticAppraisalVo.h"

@implementation DemocraticAppraisalVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"contentId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data":@"DemocraticAppraisalVo"};
}
- (void)setChoice:(NSString *)choice {
    
    if ([choice containsString:@","]) {
        _choiceArray = [choice componentsSeparatedByString:@","];
    } else if ([choice containsString:@"，"]) {
        _choiceArray = [choice componentsSeparatedByString:@"，"];

    }
}
- (void)setImage:(NSString *)image {
    
    if (image.length > 0 && image) {
        if ([image containsString:@"http:"]) {
            _image = image;
        } else {
            _image = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,image];
        }
    }
}
@end
