//
//  SKScrollView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKListView.h"

@interface SKScrollView : UIView
/**
 *  添加视图
 *
 *  view  加载的
 */
- (void) loadNewsListView:(UIView *)view;

/**
 *  获取当前视图
 *
 *  @return UIView
 */
- (UIView *) getCurrentNewsListView;

// -- 返回值+函数名+参数
// -- 声明 实现 调用
// -- 把当前视图传出去让外部能调用
@property (nonatomic , copy) void(^getEndToView)(UIView *view);

@property (nonatomic , copy) void(^getEndscrollToIndex)(NSInteger index);

/**
 *  根据点击频道按钮的index设置滚动视图的偏移量
 *
 *  @param index NSInteger
 */
- (void) scrollToNewListViewWithIndex:(NSInteger)index;



@end
