//
//  MYCalendarDayModel.m
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "MYCalendarDayModel.h"

@implementation MYCalendarDayModel

- (void)setGong_li:(NSString *)gong_li {

    if (![gong_li isEqualToString:@""] || gong_li != nil) {
        
        _gong_li = gong_li;
        //赋值星期几
        self.weekday = [TyunTool getWeekdayWithDate:gong_li];
        
        //赋值公历日
        NSArray *arr = [gong_li componentsSeparatedByString:@"/"];
        self.gongli_Day = arr.lastObject;
    }
}

- (NSMutableArray<dayWorkModel *> *)dayWorkArr
{
    if (!_dayWorkArr) {
        _dayWorkArr = [NSMutableArray array];
    }
    return _dayWorkArr;
}



@end
