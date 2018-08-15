//
//  GroupMemberListCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "GroupMemberListCell.h"
#import "UserFmdbManager.h"

@interface GroupMemberListCell ()

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UIImageView *headImageView;


@end

@implementation GroupMemberListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];

    }
    return self;
}
- (void)initCustomView {
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:headImageView];
    [headImageView setImage:[UIImage imageNamed:@"addressBook_placeholder_header_icon"]];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    __weak typeof(self) weakSelf = self;
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.height.offset(40);
        make.width.mas_equalTo(headImageView.mas_height);
    }];
    headImageView.layer.cornerRadius = 20.0f;
    headImageView.layer.masksToBounds = YES;
    _headImageView = headImageView;
    UILabel *nameLable = [[UILabel alloc] init];
    [self.contentView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(headImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(headImageView);
    }];
    nameLable.text = @"昵称";
    _nameLable = nameLable;
    
    CALayer *bottomLine = [CALayer layer];
    [bottomLine setFrame:CGRectMake(0, 59.5, kScreen_Width, 0.5)];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
}


- (void)setName:(NSString *)name {
    
    UserContactModel *groupMember = [UserFmdbManager searchUserName:name];
    if (groupMember.nickname && groupMember.nickname.length > 0) {
        _nameLable.text = groupMember.nickname;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:groupMember.image] placeholderImage:[UIImage imageNamed:groupMember.placeholderImage]];
    } else {
        _nameLable.text = name;
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
