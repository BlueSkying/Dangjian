//
//  MYCalendarView.h
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCalendarDayModel.h"

typedef void(^PUSHBLOCK)(dayWorkModel *);
@interface MYCalendarView : UIView

/**年月*/
@property (nonatomic, strong) UILabel *yearMonthLabel;

/**日历数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**详情点击回调*/
@property (nonatomic, copy) PUSHBLOCK pushBlock;
//获取数据
- (void)getData;

@end
