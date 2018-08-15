//
//  SKSegmentedView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SKSegmentedViewDelegate <NSObject>



@end

@interface SKSegmentedView : UIView
- (void) loadButtonTitleArray:(NSArray *)titleArray;

/**
 *  把当前点击的按钮在数组中得下标传出去
 */
@property (nonatomic , copy) void(^chanelButtonIdex)(NSInteger index);

- (void) chanelButtonDefaultClick;

- (void) scrollToChanelViewWithIndex:(NSInteger)index;

// -- 代理用assign修饰避免循环引用
@property (nonatomic , assign) id<SKSegmentedViewDelegate>delegate;

@property (nonatomic , strong) UIButton *moreButton;


@end
