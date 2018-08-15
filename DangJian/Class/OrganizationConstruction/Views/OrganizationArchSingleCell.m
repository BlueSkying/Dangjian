//
//  OrganizationArchSingleCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/16.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationArchSingleCell.h"

@interface OrganizationArchSingleCell ()
@property (nonatomic, strong) UIView *backView;
@end
@implementation OrganizationArchSingleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = SystemGrayBackgroundColor;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius = ControlsCornerRadius;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(20);
        make.top.offset(30);
        make.bottom.offset(0);
        make.right.offset(-20);
    }];
    backView.layer.borderColor = Color_c.CGColor;
    backView.layer.borderWidth = 0.5f;
    _backView = backView;
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:[UIColor clearColor] textColor:Color_3 textAligment:NSTextAlignmentCenter numberOfLines:2 text:nil font:FONT_16];
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(10);
        make.bottom.offset(-10);
    }];
    _titleLabel = titleLabel;
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _backView.backgroundColor = Color_system_red;
        _titleLabel.textColor = [UIColor whiteColor];
        
    } else {
        _backView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = Color_3;
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
