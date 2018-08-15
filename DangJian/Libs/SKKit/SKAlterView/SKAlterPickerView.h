//
//  SKAlterPickerView.h
//  DangJian
//
//  Created by Sakya on 17/5/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKAlterPickerViewDelegate <NSObject>

- (void)sk_alterPickerViewSelectText:(NSString *)text;

@end

@interface SKAlterPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<SKAlterPickerViewDelegate>delegate;


//methoms
/**
 设置初始值
 */
- (void)setUpInitialValue:(NSString *)initialValue;

@end
