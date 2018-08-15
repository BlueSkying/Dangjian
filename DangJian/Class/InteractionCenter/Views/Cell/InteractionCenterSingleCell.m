//
//  InteractionCenterSingleCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterSingleCell.h"

@interface InteractionCenterSingleCell ()

/**
 左侧图像
 */
@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *bottomLine;

@end
@implementation InteractionCenterSingleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(11);
        make.bottom.offset(-11);
        make.width.mas_equalTo(imageView.mas_height).multipliedBy(1);
    }];
    self.leftImageView = imageView;
//
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:arrowImageView];
    __weak typeof(self) weakSelf = self;
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.offset(CELLRIGHTARROWSIZE);
        make.height.mas_equalTo(arrowImageView.mas_width);
    }];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    arrowImageView.image = [UIImage imageNamed:@"cell_rightArrow_icon"];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = Color_3;
    titleLabel.font = FONT_16;
    [self.contentView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.lessThanOrEqualTo(arrowImageView.mas_left).offset(-100);
    }];
    self.titleLabel = titleLabel;
//
    UIImageView *bottomLine = [[UIImageView alloc] init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.height.offset(0.5);
    }];
    self.bottomLine = bottomLine;
    self.bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    
}

#pragma mark - setter
- (void)setConfigParams:(NSDictionary *)configParams {
  
    _titleLabel.text = [configParams objectForKey:@"title"];
    _leftImageView.image = [UIImage imageNamed:[configParams objectForKey:@"imageName"]];
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
