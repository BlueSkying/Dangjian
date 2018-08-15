//
//  NewsHeaderView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "NewsHeaderView.h"

@interface NewsHeaderView ()


/**
 section 文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *backView;


@end

@implementation NewsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView {
    
    
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    backView.backgroundColor = [UIColor whiteColor];
    _backView = backView;
    UIImageView *lineImageView = [[UIImageView alloc] init];
    [backView addSubview:lineImageView];
    lineImageView.image = [UIImage imageNamed:@"headerView_vertical_icon"];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.height.offset(SKXFrom6(12));
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    [backView addSubview:titleLabel];
    titleLabel.textColor = Color_3;
    titleLabel.font = FontScale_15;
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineImageView.mas_right).offset(5);
        make.centerY.equalTo(lineImageView.mas_centerY);
    }];
    
    
}
- (void)setIsShowMore:(BOOL)isShowMore {
    
    _isShowMore = isShowMore;
    
    if (isShowMore) {
        
        UIImageView *rightArrowImageView = [[UIImageView alloc] init];
        [_backView addSubview:rightArrowImageView];
        rightArrowImageView.image = [UIImage imageNamed:@"headerView_rightArrow_icon"];
        [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(_backView.mas_centerY);
            
        }];
        UILabel *moreLabel = [[UILabel alloc] init];
        [_backView addSubview:moreLabel];
        moreLabel.text = @"更多";
        moreLabel.font = FontScale_13;
        moreLabel.textColor = Color_9;

        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightArrowImageView.mas_right).offset(-10);
            make.centerY.equalTo(_backView.mas_centerY);
        }];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];

        [self addGestureRecognizer:tapGesture];
    }
}

#pragma mark -tapGesture
- (void)tapGestureDetected:(UITapGestureRecognizer *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewTapGestureDetected:)]) {
        [self.delegate headViewTapGestureDetected:self];
    }
    
}
#pragma mark - setter
- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    _titleLabel.text = headerTitle;
}
- (void)setShowLine:(BOOL)showLine {
    
    if (showLine) {
        CALayer *bottomLayer = [[CALayer alloc] init];
        [bottomLayer setFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5)];
        
        bottomLayer.backgroundColor = SystemGraySeparatedLineColor.CGColor;
        [self.layer addSublayer:bottomLayer];
    }
}
- (void)setViewType:(NewsHeaderViewType)viewType {
    
    _viewType = viewType;
    if (viewType == NewsHeaderViewArticleGreyType) {
        self.backgroundColor = SystemGrayBackgroundColor;
        [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(10);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        [self layoutIfNeeded];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
