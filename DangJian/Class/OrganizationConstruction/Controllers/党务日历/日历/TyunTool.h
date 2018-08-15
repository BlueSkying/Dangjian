//
//  TyunTool.h
//  Sedafojiao
//
//  Created by T_yun on 16/4/17.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface TyunTool : NSObject



+ (NSInteger)getNumberWithMonth:(NSString *)monthStirng;

/**获取今天日期 yyyy/mm/dd*/
+ (NSString *)getTodayDate;

/**获取当前月 yyyy/mm*/
+ (NSString *)getMonthDate;

/**计算某个日期是星期几 (格式为‘2016/5/13’)*/
+ (NSInteger)getWeekdayWithDate:(NSString *)date;

/**转农历只返的农历的天*/
+(NSString *)LunarForSolar:(NSString *)dayString;

/**党务日历服务器时间格式转换*/
+(NSString *)changeDoDate:(NSString *)dodate;

@end
