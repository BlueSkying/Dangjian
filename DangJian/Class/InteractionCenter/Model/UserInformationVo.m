//
//  UserInformationVo.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UserInformationVo.h"

@implementation UserInformationVo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        [self mj_decode:aDecoder];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self mj_encode:aCoder];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userID":@"id"};
}


//特殊字段的处理
- (void)setImage:(NSString *)image {
    
    if ([image containsString:@"http"]) {
        _image = image;
    } else {
        _image = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,image];
    }
}
- (void)setNickname:(NSString *)nickname {
    
    if (nickname && nickname.length > 0) {
        _nickname = nickname;
    } 
}
- (void)setBirth:(NSString *)birth {
    
    NSArray *stringArray = [birth componentsSeparatedByString:@"-"];
    if (stringArray.count > 2) {
        
        _birth = [NSString stringWithFormat:@"%@-%@",stringArray[0],stringArray[1]];
    } else {
        _birth = birth;
    }
    
}
- (void)setPartyTime:(NSString *)partyTime {
    NSArray *stringArray = [partyTime componentsSeparatedByString:@"-"];
    if (stringArray.count > 2) {
        
        _partyTime = [NSString stringWithFormat:@"%@-%@",stringArray[0],stringArray[1]];
    } else {
        _partyTime = partyTime;
    }
}

@end
