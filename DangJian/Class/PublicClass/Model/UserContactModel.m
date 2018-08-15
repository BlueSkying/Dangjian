//
//  UserContactModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UserContactModel.h"
#import "UserFmdbManager.h"


@implementation UserContactModel


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        [self mj_decode:aDecoder];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self mj_encode:aCoder];
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":@"UserContactModel",
             @"user":@"UserContactModel"};
}
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
- (NSString *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = @"addressBook_placeholder_header_icon";
    }
    return _placeholderImage;
}
+ (void)contactListVersionShowPrompt:(BOOL)showPrompt
                             success:(void(^)(NSArray <UserContactModel *>* result)) successBlock
                              failed:(void(^)(id error)) failedBlock {
    
    NSString *version = [UserOperation shareInstance].version;
    
    [InterfaceManager contactListVersion:version success:^(id result) {
        UserContactModel *addressBookVo;
        if ([ThePartyHelper showPrompt:showPrompt returnCode:result]) {
            
            addressBookVo = [UserContactModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            if (addressBookVo.list.count > 0) {
                [addressBookVo.list enumerateObjectsUsingBlock:^(UserContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //保存用户信息
                    [UserFmdbManager updateUsers:obj.user groupName:obj.name];
                }];
//                整个信息整体保存
                [UserFmdbManager eidtAddressBookVo:addressBookVo userAccount:[UserOperation shareInstance].account];
                [UserOperation shareInstance].version = addressBookVo.version;
            }
        }
        successBlock(addressBookVo.list);
    } failed:^(id error) {
        failedBlock(error);
    }];
}

@end
