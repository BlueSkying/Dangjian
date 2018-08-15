//
//  OnlineTestCountdownView.h
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnlineTestCountdownViewDelegate <NSObject>

/**
 时间用完提示
 */
- (void)onlineTestCountdownViewOutOfTime;

@end

@interface OnlineTestCountdownView : UIView

/**
设置倒计时时间  传进来的为分钟
 */
@property (nonatomic, assign) NSInteger countdown;

@property (nonatomic, copy) NSString *testDescribe;

@property (nonatomic, weak) id<OnlineTestCountdownViewDelegate>delegate;

@end
