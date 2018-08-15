//
//  InteractionCenterHeaderView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterHeaderView.h"

@interface InteractionCenterHeaderView ()

@property (nonatomic, strong) UIImageView *headImaegView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation InteractionCenterHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blueColor];
        [self initCustomHeaderView];
        
    }
    return self;
}
- (void)initCustomHeaderView {
    
    //    导航条红色
    UIColor *backColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, kScreen_Width, 64) andColors:@[Color_systemNav_red_bottom,Color_systemNav_red_top]];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = backColor;
    [self addSubview:backImageView];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);

    }];
    _backImageView = backImageView;
    
    /**
    //NavBar title
    UILabel *navigationLabel = [SKBuildKit labelWithBackgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"互动中心" font:FONT_17];
    [backImageView addSubview:navigationLabel];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.offset(44);
    }];
    _navigationLabel = navigationLabel;
    */
    
    //创建个人信息底部view
    UIView *bottomView = [[UIView alloc] init];
    [backImageView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.offset(0);
        make.width.mas_equalTo(self.mas_width);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
   
    [bottomView addGestureRecognizer:tapGesture];
    
//    头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    [headImageView setImage:[UIImage imageNamed:@"user_headRedPlaceholder_icon"]];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.offset(SKXFrom6(60));
        make.width.mas_equalTo(headImageView.mas_height);
    }];
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headImageView.contentMode =  UIViewContentModeScaleAspectFill;
    headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    headImageView.clipsToBounds  = YES;
    [headImageView.layer setCornerRadius:SKXFrom6(60)/2];
    _headImaegView = headImageView;
    //用户姓名
    UILabel *nameLable = [SKBuildKit labelWithBackgroundColor:nil textColor:[UIColor whiteColor] textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"用户名" font:FontScale_17];
    [self addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(headImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(headImageView.mas_centerY);
        make.width.offset(160);
    }];
    _nameLabel = nameLable;
    /**
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self addSubview:arrowImageView];
    arrowImageView.image = [UIImage imageNamed:@"personal_rightArrow_icon"];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.centerY.mas_equalTo(headImageView.mas_centerY);
    }];
     */
}
#pragma mark - gesture
- (void)tapGestureDetected:(UITapGestureRecognizer *)sender {
    
    /**
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewActionDetected:)]) {
        [self.delegate headerViewActionDetected:self];
    }
     */
}
- (void)setUser:(UserInformationVo *)user {
    
    _user = user;
    NSURL *imageUrl = [NSURL URLWithString:user.image];
    [_headImaegView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_headRedPlaceholder_icon"]];
    _nameLabel.text = user.nickname ? user.nickname : [UserOperation shareInstance].account;
}
- (void)setBackViewRect:(CGRect)backViewRect {

    _backImageView.frame = backViewRect;
    
//    _headImaegView.frame = CGRectMake(15, backViewRect.size.height - 80, SKXFrom6(60), SKXFrom6(60));
//    [_headImaegView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.bottom.offset(backViewRect.size.height - 80);
//        make.height.offset(SKXFrom6(60));
//        make.width.mas_equalTo(_headImaegView.mas_height);
//    }];
    
}
@end
