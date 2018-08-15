/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseBubbleView.h"

@interface EaseBubbleView (Gif)

/*!
 @method
 @brief 构建gif自定义表情气泡

 */
- (void)setupGifBubbleView;

/*!
 @method
 @brief 变更gif表情气泡的边距，并更新改子视图约束
 @param margin 气泡边距
 */
- (void)updateGifMargin:(UIEdgeInsets)margin;

@end