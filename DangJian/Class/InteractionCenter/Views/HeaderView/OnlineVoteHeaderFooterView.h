//
//  OnlineVoteHeaderFooterView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemocraticAppraisalVo.h"
typedef NS_OPTIONS(NSInteger, OnlineVoteHeaderFooterViewType) {
    OnlineVoteHeaderiew = 0,
    OnlineVoteFooterView ,
};

@class OnlineVoteHeaderFooterView;

@protocol OnlineVoteHeaderFooterViewDelegate <NSObject>


@optional
- (DemocraticAppraisalVo *)headerFooterView:(OnlineVoteHeaderFooterView *)decorationView;
- (void)heightForOnlineVoteHeaderView:(OnlineVoteHeaderFooterView *)decorationView height:(CGFloat)height;
- (CGFloat)heightForOnlineVoteFooterView:(OnlineVoteHeaderFooterView *)decorationView;

//footerViewDelegate
- (void)footerViewSelected:(UIButton *)sender;

@end

@interface OnlineVoteHeaderFooterView : UIView


@property (nonatomic, weak) id<OnlineVoteHeaderFooterViewDelegate>delegate;


/**
 是否可以点击 投票按钮
 */
@property (nonatomic, assign) BOOL canClicked;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(OnlineVoteHeaderFooterViewType)type;
- (void)reload;


@end
