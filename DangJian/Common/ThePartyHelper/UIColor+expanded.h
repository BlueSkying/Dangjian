//
//  UIColor+expanded.h
//  HealthExpress
//
//  Created by ChenHuang on 15/5/20.
//  Copyright (c) 2015年 bilab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (expanded)
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
