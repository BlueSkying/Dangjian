//
//  AddressBookContactInfoCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AddressBookContactInfoCell.h"

@interface AddressBookContactInfoCell ()
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation AddressBookContactInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(headImageView);
        make.width.greaterThanOrEqualTo(@150);

    }];
    nameLabel.font = FONT_17;
    nameLabel.textColor = Color_3;
    nameLabel.text = @"张三";
    _nameLabel = nameLabel;
    
    UIView *bottomLine = [[UIView alloc] init];;
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headImageView.mas_right).offset(5);
        make.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];

    
}
- (void)setUser:(UserContactModel *)user {
    
    _user = user;
    _nameLabel.text = (user.nickname && user.nickname.length > 0) ? user.nickname : user.account;
    NSURL *iamgeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",user.image]];
    [_headImageView sd_setImageWithURL:iamgeUrl placeholderImage:[UIImage imageNamed:@"addressBook_placeholder_header_icon"]];
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
