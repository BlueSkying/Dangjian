//
//  dayWorkModel.m
//  ThePartyBuild
//
//  Created by TuringLi on 17/5/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "dayWorkModel.h"

@implementation dayWorkModel

- (void)setDoDate:(NSString *)doDate {
    
    if (![doDate isEqualToString:@""] || doDate != nil) {
        
        _doDate = doDate;
        //赋值星期几
        self.workDayDate = [TyunTool changeDoDate:doDate];
        
    }
}
@end
