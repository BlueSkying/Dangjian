//
//  MyIntegralHeaderView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MyIntegralHeaderView.h"
#import "SKCircleView.h"

@interface MyIntegralHeaderView ()
@property (nonatomic, strong)SKCircleView * circleView;

/**
 背景图片
 */
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation MyIntegralHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCustomHeaderView];
    }
    return self;
}

- (void)initCustomHeaderView {
    
    //    背景颜色
    UIColor *backColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.frame)) andColors:@[Color_systemNav_red_bottom,Color_systemNav_red_top]];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backImageView.backgroundColor = backColor;
    [self addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    _backImageView = backImageView;
    /**
    //NavBar
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    [backImageView addSubview:navBarView];
    
    //navBar title
    UILabel *navigationLabel = [SKBuildKit labelWithBackgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"我的积分" font:FONT_17];
    [navBarView addSubview:navigationLabel];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.offset(0);
        make.height.offset(44);
        make.width.lessThanOrEqualTo(@120);
    }];
    
    UIButton *itemLeftButton = [SKBuildKit buttonWithImageName:@"navBar_whiteBack_icon" superview:navBarView target:self action:@selector(navBarButtonTouchUpInside:)];
    [itemLeftButton setImage:[UIImage imageNamed:@"navBar_whiteBack_icon"] forState:UIControlStateHighlighted];
    [itemLeftButton setFrame:CGRectMake(0, 20, 60, 44)];
    [itemLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    itemLeftButton.tag = 0;
    [navBarView addSubview:itemLeftButton];
    
    UIButton *itemRightButton = [SKBuildKit buttonWithImageName:@"InteractionCenter_integral_icon" superview:navBarView target:self action:@selector(navBarButtonTouchUpInside:)];
    itemRightButton.tag = 1;
    [itemRightButton setImage:[UIImage imageNamed:@"InteractionCenter_integral_icon"] forState:UIControlStateHighlighted];
    [itemRightButton setFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 20, 60, 44)];
    [navBarView addSubview:itemRightButton];
*/
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, CGRectGetHeight(self.frame) - 64)];
    [backImageView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.top.offset(64);
        make.right.offset(0);
        
    }];
    _circleView = [[SKCircleView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.frame)/2 - 70, CGRectGetHeight(bottomView.frame)/2 - 70, 140, 140)];
    [bottomView addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.width.offset(140);
        make.height.offset(140);
        make.left.offset(kScreen_Width/2 - 70);
    }];

}

#pragma mark - action
- (void)navBarButtonTouchUpInside:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewNavBarTouchDetected:)]) {
        
        [self.delegate headerViewNavBarTouchDetected:sender];
    }
}
- (void)setProgressValue:(CGFloat)progressValue {
    
    _progressValue = progressValue;
    
    
    if (progressValue <= 1.0 && progressValue >= 0.0) {
       
        _circleView.progressValue = progressValue;
    }
}

- (void)setBackViewRect:(CGRect)backViewRect {
    
    _backImageView.frame = backViewRect;
    
    
}
@end
