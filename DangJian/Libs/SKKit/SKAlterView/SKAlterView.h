//
//  SKAlterView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterTitleView : UIView


@end




typedef NS_OPTIONS(NSInteger, SKPromptNavBarType) {
    
    //默认两侧都有按钮
    SKPromptNavBarDefaultType = 0,
    //左侧有按钮
    SKPromptNavBarLeftButtonType = 1,
    //右侧有按钮
    SKPromptNavBarRighrButtonType
};

typedef NS_OPTIONS(NSInteger, SKPromptStyle) {
    
    /**文本输入单按钮*/
    SKPromptTextViewType = 0,
    /**年月滚动选择*/
    SKPromptDatePickViewType = 2,
    /**地址滚动选择*/
    SKPromptAddressPickViewType,
    /**性别选择*/
    SKPromptCustomPickerDefaultType,
    /**数字选择*/
    SKPromptNumberPickerType
};
@protocol SKAlterViewDelegate <NSObject>

/**
 点击左右导航条按钮的delegate
 @param sender 点击的按钮
 @param indexPath 对应的下标
 */
- (void)sk_alterNavBarClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;


/**
 对应输出的值

 @param key 对应的key
 @param content key对应的内容
 @param indexPath 对应的下标
 */
- (void)sk_alterViewPutputKey:(NSString *)key content:(NSString *)content indexPath:(NSIndexPath *)indexPath;

@end
@interface SKAlterView : UIView

#pragma mark -- customView
//初始化主界面
-(instancetype)initWithTitle:(NSString *)title
                        type:(SKPromptStyle)type
             withInputString:(NSString *)input
                 selectArray:(NSArray *)selectArray;
//初始化弹窗风格信息 animation 是否需要动画
- (void)initAlertTitle:(NSString *)title
                  type:(SKPromptStyle)type
             animation:(BOOL)animation
       withInputString:(NSString *)input
           selectArray:(NSArray *)selectArray;
/**
 提示语
 */
@property (nonatomic, copy) NSString *placeholder;
//输出
@property (nonatomic, copy) NSString *output;
//AlterViewNavBar 样式
@property (nonatomic, assign) SKPromptNavBarType promptNavBarType;

@property (nonatomic, weak) id<SKAlterViewDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

#pragma mark -- show hide
//show methoms
- (void)sk_show;
@end
