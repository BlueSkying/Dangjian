//
//  OrganizationPaymentInfoCell.m
//  DangJian
//
//  Created by Sakya on 17/6/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationPaymentInfoCell.h"

@interface OrganizationPaymentInfoCell ()


@end

@implementation OrganizationPaymentInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"缴纳年份" font:FONT_16];
    [self addSubview:titleLabel];
    __weak typeof(self) weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(weakSelf);
        make.width.offset(120);
    }];
    _titleLabel = titleLabel;
    
    UILabel *contentLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"2039年" font:FontScale_15];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.centerY.mas_equalTo(weakSelf);
        make.right.offset(-15);
    }];
    _contentLabel = contentLabel;
    
    CALayer *bottomLine = [[CALayer alloc] init];
    bottomLine.frame = CGRectMake(0, 47.5, kScreen_Width, .5);
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
    
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
