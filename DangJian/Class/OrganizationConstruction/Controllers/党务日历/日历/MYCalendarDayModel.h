//
//  MYCalendarDayModel.h
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//


#import "dayWorkModel.h"
//日历model
@interface MYCalendarDayModel : NSObject

/**自加属性 转换后的执行时间*/
@property (nonatomic, copy) NSString *workDayDate;

/**自加属性 显示周几*/
@property (nonatomic, assign) NSInteger weekday;

/**自加属性 显示公历日*/
@property (nonatomic, copy) NSString *gongli_Day;

/**自加属性 月份*/
@property (nonatomic, copy) NSString *month;

/**自加属性 年份*/
@property (nonatomic, copy) NSString *zangli_year;

/**自加属性 阴历*/
@property (nonatomic, copy) NSString *day;

/**自加属性 公历年月日*/
@property (nonatomic, copy) NSString *gong_li;

/**自加属性 当天的事项数组*/
@property (nonatomic, strong) NSMutableArray <dayWorkModel *>*dayWorkArr;




@end
