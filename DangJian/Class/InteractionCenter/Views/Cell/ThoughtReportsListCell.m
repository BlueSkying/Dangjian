//
//  ThoughtReportsListCell.m
//  DangJian
//
//  Created by Sakya on 2017/7/6.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThoughtReportsListCell.h"
#import "ReportFeedbackModel.h"

@interface ThoughtReportsListCell ()

/**
 汇报人
 */
@property (nonatomic, strong) UILabel *reportPersonLabel;

/**
 汇报主题
 */
@property (nonatomic, strong) UILabel *reportObjectLabel;

@end

@implementation ThoughtReportsListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
  
    
    UILabel *reportTitleLabel = [UILabel new];
    [self.contentView addSubview:reportTitleLabel];
    [reportTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(5);
    }];
    reportTitleLabel.font = FONT_15;
    reportTitleLabel.textColor = Color_6;
    reportTitleLabel.text = @"汇报人：";

    
    UILabel *objectTitleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:nil font:FONT_15];
    [self.contentView addSubview:objectTitleLabel];
    [objectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-5);
        make.top.mas_equalTo(reportTitleLabel.mas_bottom);
        make.height.mas_equalTo(reportTitleLabel.mas_height);
    }];
    objectTitleLabel.text = @"汇报主题：";

    
    //汇报人
    UILabel *reportPersonLabel = [UILabel new];
    [self.contentView addSubview:reportPersonLabel];
    [reportPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reportTitleLabel.mas_right).offset(5);
        make.top.mas_equalTo(reportTitleLabel.mas_top);
        make.width.greaterThanOrEqualTo(@180);
        make.height.mas_equalTo(reportTitleLabel.mas_height);

    }];
    reportPersonLabel.font = FONT_16;
    reportPersonLabel.textColor = Color_3;
    _reportPersonLabel = reportPersonLabel;
    
    
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
    
//    汇报主题
    UILabel *reportObjectLabel = [UILabel new];
    [self.contentView addSubview:reportObjectLabel];
    [reportObjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(objectTitleLabel.mas_right).offset(5);
        make.top.mas_equalTo(objectTitleLabel.mas_top);
        make.right.lessThanOrEqualTo(arrowImageView.mas_left).offset(-10);
        make.height.mas_equalTo(objectTitleLabel.mas_height);

    }];
    reportObjectLabel.font = FONT_16;
    reportObjectLabel.textColor = Color_3;
    _reportObjectLabel = reportObjectLabel;

    UIView *bottomLine = [[UIView alloc] init];;
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(reportTitleLabel);
        make.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
    
}
- (void)setThoughtReportsVo:(ReportFeedbackModel *)thoughtReportsVo {
    _reportObjectLabel.text = thoughtReportsVo.subject;
    _reportPersonLabel.text = thoughtReportsVo.username;
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
