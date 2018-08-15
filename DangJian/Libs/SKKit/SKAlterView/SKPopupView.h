//
//  SKPopupView.h
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SKPopupNavBarView : UIView


@end
typedef NS_OPTIONS(NSInteger, SKPopupViewStyle) {
    
    /**单项的选择*/
    SKPopupViewPickerDefaultType = 0,
    /**年月滚动选择*/
    SKPopupViewDatePickViewType
};

@protocol SKPopupViewDelegate <NSObject>

/**
 对应输出的值
 
 @param key 对应的key
 @param content key对应的内容
 @param indexPath 对应的下标
 */
- (void)sk_alterViewPutputKey:(NSString *)key content:(NSString *)content indexPath:(NSIndexPath *)indexPath;

@end

@interface SKPopupView : UIView
//初始化主界面
-(instancetype)initWithTitle:(NSString *)title
                        type:(SKPopupViewStyle)type
             withInputString:(NSString *)input
                 selectArray:(NSArray *)selectArray;
//初始化弹窗风格信息 animation 是否需要动画
- (void)initAlertTitle:(NSString *)title
                  type:(SKPopupViewStyle)type
             animation:(BOOL)animation
       withInputString:(NSString *)input
           selectArray:(NSArray *)selectArray;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SKPopupViewDelegate>delegate;

/**
 对应上传字段的key
 */
@property (nonatomic, copy) NSString *key;


- (void)sk_close;
- (void)sk_show;

@end
