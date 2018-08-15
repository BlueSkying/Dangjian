//
//  InteractionCenterHeaderView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


@class InteractionCenterHeaderView;
@protocol InteractionCenterHeaderViewDelegate <NSObject>

- (void)headerViewActionDetected:(InteractionCenterHeaderView *)sender;

@end
@interface InteractionCenterHeaderView : UIView


@property (nonatomic, strong) UserInformationVo *user;

@property (nonatomic, copy) NSString *name;


/**
 背景图片
 */
@property (nonatomic, strong) UIImageView *backImageView;


/**
 背景图的rect
 */
@property (nonatomic, assign) CGRect backViewRect;
/**
 导航标题
 */
@property (nonatomic, strong) UILabel *navigationLabel;

@property (nonatomic, weak) id<InteractionCenterHeaderViewDelegate>delegate;
@end
