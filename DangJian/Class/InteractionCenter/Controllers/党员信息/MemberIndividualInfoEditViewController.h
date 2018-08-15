//
//  MemberIndividualInfoEditViewController.h
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberInformationVo.h"

@interface MemberIndividualInfoEditViewController : BaseViewController


/**
 对应的传入数据
 */
@property (nonatomic, strong) CellCustomVo *memberCustomVo;

@property (nonatomic, copy) void(^memberInfoEditBlock)(CellCustomVo *customVo);

@end
