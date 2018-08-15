//
//  HomeBannerVo.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "HomeBannerVo.h"

@implementation HomeBannerVo

- (void)setImageUrl:(NSString *)imageUrl {
    if ([imageUrl containsString:@"http"]) {
        _imageUrl = imageUrl;
    } else {
        _imageUrl = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,imageUrl];
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"targetId":@"id"};
}
@end
