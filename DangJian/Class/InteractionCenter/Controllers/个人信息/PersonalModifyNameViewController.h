//
//  PersonalModifyNameViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalModifyNameViewController : BaseViewController

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) void(^modifyNickNameBlock)(NSString *nickName);
@end
