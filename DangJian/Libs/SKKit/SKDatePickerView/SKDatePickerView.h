//
//  SKDatePickerView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKDatePickerViewDelegate <NSObject>

- (void)sk_datePickerViewSelectDate:(NSString *)output;

@end

@interface SKDatePickerView : UIView

- (instancetype)initDatePackerWithFrame:(CGRect)frame;

//选中时显示的时间
- (void)dateYear:(NSString *)year
           month:(NSString *)month;

- (void)show;



@property (nonatomic, weak) id<SKDatePickerViewDelegate>delegate;
@end
