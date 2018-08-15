//
//  SKAreaPickerView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKAreaPickerView;
@protocol SKPickerViewDelegate <NSObject>

@optional
// 确定按钮点击回调
- (void)sk_selectedAreaResultWithProvince:(NSString *)provinceTitle
                                     city:(NSString *)cityTitle
                                     area:(NSString *)areaTitle;
// 取消按钮点击回调
- (void)sk_cancelButtonClicked;
@end

@interface SKAreaPickerView : UIView
/** 标题大小 */
@property (nonatomic, strong)UIFont  *titleFont;
/** 选择器背景颜色 */
@property (nonatomic, strong)UIColor *pickViewBackgroundColor;
/** 选择器头部视图颜色 */
@property (nonatomic, strong)UIColor *topViewBackgroundColor;
/** 取消按钮颜色 */
@property (nonatomic, strong)UIColor *cancelButtonColor;
/** 确定按钮颜色 */
@property (nonatomic, strong)UIColor *sureButtonColor;

/** 选择器代理 */
@property (nonatomic, weak) id<SKPickerViewDelegate> pickViewDelegate;

/** 显示选择器 */
- (void)sk_show;
@end
