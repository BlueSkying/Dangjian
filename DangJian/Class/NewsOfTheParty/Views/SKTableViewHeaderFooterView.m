//
//  SKTableViewHeaderFooterView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKTableViewHeaderFooterView.h"

@interface SKTableViewHeaderFooterView ()
/**
 section 文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *rightArrowImageView;

@property (nonatomic, strong) UILabel *moreLabel;
@end

@implementation SKTableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *headerId = @"headerView";
    SKTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    if (headerView == nil) {
        headerView = [[SKTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerId];
    }
    
    return headerView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = SystemGrayBackgroundColor;
        [self initCustomView];
    }
    return self;
}
/**
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initCustomView];
    }
    return self;
}
*/
- (void)initCustomView {
    
    
    UIView *backView = [[UIView alloc] init];
    [self.contentView addSubview:backView];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
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
    
    UIImageView *rightArrowImageView = [[UIImageView alloc] init];
    [_backView addSubview:rightArrowImageView];
    rightArrowImageView.image = [UIImage imageNamed:@"cell_rightArrow_icon"];
    __weak typeof(self) weakSelf = self;
    [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(weakSelf.backView.mas_centerY);
        make.width.offset(CELLRIGHTARROWSIZE);
    }];
    [rightArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    _rightArrowImageView = rightArrowImageView;
    _rightArrowImageView.hidden = YES;

    
    UILabel *moreLabel = [[UILabel alloc] init];
    [_backView addSubview:moreLabel];
    moreLabel.text = @"更多";
    moreLabel.font = FontScale_13;
    moreLabel.textColor = Color_9;
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightArrowImageView.mas_left).offset(0);
        make.centerY.equalTo(weakSelf.backView.mas_centerY);
    }];
    _moreLabel = moreLabel;
    _moreLabel.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    [self.contentView addGestureRecognizer:tapGesture];
    
}
- (void)setIsShowMore:(BOOL)isShowMore {
    
    _isShowMore = isShowMore;
    
    if (isShowMore) {
        _moreLabel.hidden = NO;
        _rightArrowImageView.hidden = NO;
        
    } else {

        _moreLabel.hidden = YES;
        _rightArrowImageView.hidden = YES;
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
        UIImageView *bottomLine = [[UIImageView alloc] init];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(0.5);
            make.bottom.offset(0);
        }];
        bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    }
}
- (void)setViewType:(SKTableViewHeaderFooterViewType)viewType {
    
    _viewType = viewType;
    if (viewType == SKTableViewHeaderFooterViewArticleGreyType) {

        [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(10);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
}

@end
