//
//  MyIntegralHeaderView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyIntegralHeaderViewDelegate <NSObject>

- (void)headerViewNavBarTouchDetected:(UIButton *)sender;

@end

@interface MyIntegralHeaderView : UIView


/**
 积分 比例
 */
@property (nonatomic, assign) CGFloat progressValue;


/**
 背景图的rect
 */
@property (nonatomic, assign) CGRect backViewRect;

@property (nonatomic, weak) id<MyIntegralHeaderViewDelegate>delegate;
@end
