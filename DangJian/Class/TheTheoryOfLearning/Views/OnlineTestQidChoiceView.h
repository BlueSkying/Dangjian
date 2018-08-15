//
//  OnlineTestQidChoiceView.h
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineTestDetailsVo.h"

@interface OnlineTestQidChoiceCell : UICollectionViewCell

@end


@interface OnlineTestQidChoiceNavBarView : UIView

@end


@protocol OnlineTestQidChoiceViewDelegate <NSObject>


/**
 上一提或者下一题被选择

 @param sender tag 0 上一题 1 下一题
 @param topicIndex  位置 从0开始

 */
- (void)onlineTestQidChoiceViewNavBarItemClicked:(UIButton *)sender topicIndex:(NSInteger)topicIndex;

/**
 选择的题号

 @param index 位置 从0开始
 */
- (void)onlineTestQidChoiceViewQidSelectedIndex:(NSInteger)index;

@end


@interface OnlineTestQidChoiceView : UIView


#pragma mark -- customView


//OnlineTestDetailsVo.h
@property (nonatomic, strong) NSArray <OnlineTestDetailsVo *>*totalArray;


@property (nonatomic, weak) id<OnlineTestQidChoiceViewDelegate>delegate;
/**
 隐藏上一个按钮
 */
@property (nonatomic, assign) BOOL hideTheLastButton;
/**
 隐藏下一个按钮
 */
@property (nonatomic, assign) BOOL hideTheNextButton;

/**
 当前选择的index 从1开始
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 需要设置的浏览题目条数
 */
@property (nonatomic, assign) NSString *itemTitle;


#pragma mark -- methoms
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

- (void)sk_show;
- (void)sk_hide;
@end
