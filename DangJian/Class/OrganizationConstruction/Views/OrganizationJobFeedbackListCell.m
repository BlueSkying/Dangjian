//
//  OrganizationJobFeedbackListCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackListCell.h"

@interface OrganizationJobFeedbackListCell ()


/**
 工作反馈左侧图片
 */
@property(nonatomic, strong) UIImageView *listImageView;
/**
 工作反馈列表的title
 */
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation OrganizationJobFeedbackListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    imageView.layer.cornerRadius = ControlsCornerRadius;
    imageView.layer.masksToBounds = YES;
    __weak typeof(self) weakSelf = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(10);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.width.offset(50);
        make.height.mas_equalTo(imageView.mas_width);
    }];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds  = YES;
    imageView.image = [UIImage imageNamed:@"organization_feedbackList_placeholder_icon"];
    _listImageView = imageView;

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
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:nil font:FONT_16];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(arrowImageView.mas_left).offset(-10);;
        
    }];
    _titleLabel = titleLabel;
    //
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(10);
        make.bottom.offset(0);
        make.height.offset(.5);
    }];
    bottomLine = bottomLine;
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
}
- (void)setJobFeedbacListVo:(OrganizationJobFeedbackModel *)jobFeedbacListVo {
    
    [_listImageView sd_setImageWithURL:[NSURL URLWithString:jobFeedbacListVo.image1] placeholderImage:[UIImage imageNamed:@"organization_feedbackList_placeholder_icon"]];
    _titleLabel.text = jobFeedbacListVo.subject;
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
