//
//  PersonalInformationModifyCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInformationVo.h"

typedef NS_OPTIONS(NSInteger, PersonalInformationModifyCellType) {
    
//    修改头像
    PersonalModifyHeaderCellType = 0,
    //修改姓名
    PersonalModifyNameCellType = 1,

};

@interface PersonalInformationModifyCell : UITableViewCell

@property (nonatomic, assign) PersonalInformationModifyCellType type;

@property (nonatomic, strong) CellCustomVo *customVo;


/**
 针对特殊的数据处理
 */
@property (nonatomic, strong) NSDictionary *configParams;

@property (nonatomic, strong) NSDictionary *imageParams;

@property (nonatomic, copy) NSString *contentText;


@end
