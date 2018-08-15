//
//  PublickSingleTitleCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PublickSingleTitleCell.h"

@interface PublickSingleTitleCell ()
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomLine;

/**
 右侧描述label
 */
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *rightArrowImageView;
@end

@implementation PublickSingleTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
#pragma mark - init
- (void)initCustomView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.text = @"主题";
    titleLabel.textColor = Color_3;
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.right.lessThanOrEqualTo(self.contentView).offset(-25);
    }];
    titleLabel.font = FontScale_15;
    _titleLabel = titleLabel;
    
    //
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.offset(CELLRIGHTARROWSIZE);
        make.height.mas_equalTo(arrowImageView.mas_width);

    }];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    arrowImageView.image = [UIImage imageNamed:@"cell_rightArrow_icon"];
    _rightArrowImageView = arrowImageView;
    
    UILabel *detailLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentRight numberOfLines:1 text:nil font:FONT_15];
    [self.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(arrowImageView.mas_centerY);
        make.left.mas_equalTo(titleLabel.mas_right).offset(-5);
    }];
    _detailLabel = detailLabel;
    //
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.height.offset(.5);
    }];
    _bottomLine = bottomLine;
    _bottomLine.backgroundColor = SystemGraySeparatedLineColor;
}
- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = title ? title : @"";
}
- (void)setContent:(NSString *)content {
    
    _detailLabel.text = content ? content : @"";
}

- (void)setShowArrow:(BOOL)showArrow {
    _showArrow = showArrow;
    if (showArrow) {
        _rightArrowImageView.hidden = NO;
    } else {
        _rightArrowImageView.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
