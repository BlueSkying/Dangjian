//
//  OrganizationMemberInfoCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/13.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationMemberInfoCell.h"

@interface OrganizationMemberInfoCell ()
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
/**
 职位
 */
@property (nonatomic, strong) UILabel *positionLabel;
@end
@implementation OrganizationMemberInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    
    return self;
    
}

- (void)setupSubviews {
    
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    headImageView.image = [UIImage imageNamed:@"addressBook_placeholder_header_icon"];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.width.offset(44);
        make.height.mas_equalTo(headImageView.mas_width);
        make.centerY.mas_equalTo(self.contentView);
    }];
    headImageView.layer.cornerRadius = 22.0f;
    headImageView.layer.masksToBounds = YES;
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headImageView.contentMode =  UIViewContentModeScaleAspectFill;
    headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImageView = headImageView;
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(15);
        make.top.mas_equalTo(headImageView.mas_top);
        make.width.greaterThanOrEqualTo(@150);
    }];
    nameLabel.font = FONT_17;
    nameLabel.textColor = Color_3;
    nameLabel.text = @"张三";
    _nameLabel = nameLabel;
    
    UILabel *positionLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:COLOR_STANDARD_7 textAligment:NSTextAlignmentLeft numberOfLines:1 text:nil font:FONT_15];
    [self.contentView addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.bottom.mas_equalTo(headImageView);
        make.right.lessThanOrEqualTo(@-50);
    }];
    _positionLabel = positionLabel;
    
    UIView *bottomLine = [[UIView alloc] init];;
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(positionLabel);
        make.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
    
    __weak typeof(self) weakSelf = self;
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.offset(CELLRIGHTARROWSIZE);
        make.height.mas_equalTo(arrowImageView.mas_width);

    }];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    arrowImageView.image = [UIImage imageNamed:@"cell_rightArrow_icon"];
    
}
- (void)setMemberVo:(OrganizationalMemberVo *)memberVo {
    
    
    _nameLabel.text = memberVo.nickname;
    _positionLabel.text = memberVo.duty;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",InterfaceIPAddress,memberVo.image]] placeholderImage:[UIImage imageNamed:@"addressBook_placeholder_header_icon"]];
    
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
