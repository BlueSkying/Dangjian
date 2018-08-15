//
//  OrganzationPersonalDuesViewController.h
//  DangJian
//
//  Created by Sakya on 2017/6/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DuesRecordViewController.h"

@interface OrganzationPersonalDuesViewController : DuesRecordViewController

/**
 事项id 如果没有则查询全部有的则查询指定
 */
@property (nonatomic, copy) NSString *backlogId;
@end
