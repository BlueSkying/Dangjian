//
//  UIControl+Custom.h
//  pczd_ios
//
//  Created by Sakya on 16/12/20.
//  Copyright © 2016年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Custom)
@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔
@end
