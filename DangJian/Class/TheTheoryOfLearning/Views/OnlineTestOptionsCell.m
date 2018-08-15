//
//  OnlineTestOptionsCell.m
//  DangJian
//
//  Created by Sakya on 17/5/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestOptionsCell.h"

@interface OnlineTestOptionsCell ()


/**
 选项
 */
@property (nonatomic, strong) UILabel *optionLabel;

@property (nonatomic, strong) UIView *backView;

@end

@implementation OnlineTestOptionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = SystemGrayBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    
    UIView *bakView = [[UIView alloc] init];
    [self.contentView addSubview:bakView];
    [bakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.bottom.offset(0);
    }];
    bakView.layer.cornerRadius = 5.0f;
    bakView.backgroundColor = [UIColor whiteColor];
    bakView.layer.borderWidth = .5f;
    bakView.layer.borderColor = HexRGB(0xe6e6e6).CGColor;
    _backView = bakView;
    
    UILabel *optionLabel = [[UILabel alloc] init];
    [bakView addSubview:optionLabel];
    optionLabel.backgroundColor = [UIColor clearColor];
    [optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    optionLabel.textAlignment = NSTextAlignmentCenter;
    optionLabel.textColor = Color_6;
    optionLabel.font = FONT_15;
    optionLabel.numberOfLines = 0;
    optionLabel.text = @"默认选认选项";
    _optionLabel = optionLabel;
    
}
- (void)setSelectedOption:(BOOL)selectedOption {
    
    _selectedOption = selectedOption;
    if (_selectedOption) {
        
        _backView.backgroundColor = Color_system_red;
        _optionLabel.textColor = [UIColor whiteColor];
        
    } else {
        _optionLabel.textColor = Color_6;
        _backView.backgroundColor = [UIColor whiteColor];

    }
}

- (void)setOptionVo:(OnlineTestOptionsVo *)optionVo {
    
    _optionVo = optionVo;
    _optionLabel.attributedText = [SKBuildKit attributedStringWithString:optionVo.topicTitle paragraphStyle:optionVo.paragraphStyle textColor:Color_6 textFont:FONT_15];
    _optionLabel.textAlignment = optionVo.textAlignment;
    if (optionVo.isSelected) {
        _backView.backgroundColor = Color_system_red;
        _optionLabel.textColor = [UIColor whiteColor];
    } else {
        _optionLabel.textColor = Color_6;
        _backView.backgroundColor = [UIColor whiteColor];
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
