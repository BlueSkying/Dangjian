//
//  OrganizationPatCostListCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/20.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationPatCostListCell.h"

@interface OrganizationPatCostListCell ()


/**
 缴费日期
 */
@property (nonatomic, strong) UILabel *dateLabel;
/**
 待缴党费
 */
@property (nonatomic, strong) UILabel *noPayLabel;
/**
 已缴党费
 */
@property (nonatomic, strong) UILabel *alreadyPayLabel;
@end

@implementation OrganizationPatCostListCell
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
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.bottom.offset(0);
    }];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = ControlsCornerRadius;
    
    UILabel *dateLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"2017年06月" font:FONT_17];
    [backView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(0);
        make.height.offset(50);
    }];
    _dateLabel = dateLabel;
    
    //虚线
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    CGPathMoveToPoint(dotteShapePath, NULL, 15, 50);
    CGPathAddLineToPoint(dotteShapePath, NULL, kScreen_Width - 45, 50);
    [Helper drawShapeLayerLineWidth:1 strokeColor:Color_textField_border shapePath:dotteShapePath addView:backView];
    
//    backView.layer.shadowColor= Color_c.CGColor;
//    backView.layer.shadowOffset= CGSizeMake(1, 1);
//    backView.layer.shadowOpacity=0.5;
//    backView.layer.shadowRadius=1;
    /**
//    左边的半圆
    CALayer *circleLeftLayer = [CALayer layer];
    circleLeftLayer.frame = CGRectMake(-10, 40, 20, 20);
    circleLeftLayer.cornerRadius = 10;
    circleLeftLayer.masksToBounds = YES;
    circleLeftLayer.backgroundColor = SystemGrayBackgroundColor.CGColor;
    [backView.layer addSublayer:circleLeftLayer];
//右边半圆
    CALayer *circleRightLayer = [CALayer layer];
    circleRightLayer.frame = CGRectMake(kScreen_Width - 40, 40, 20, 20);
    circleRightLayer.cornerRadius = 10;
    circleRightLayer.masksToBounds = YES;
    circleRightLayer.backgroundColor = SystemGrayBackgroundColor.CGColor;
    [backView.layer addSublayer:circleRightLayer];
*/
    //背景中扣住圆形
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreen_Width - 30, 130)];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kScreen_Width - 40, 40, 20, 20) cornerRadius:10] bezierPathByReversingPath]];
     [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(-10, 40, 20, 20) cornerRadius:10] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    backView.layer.mask = maskLayer;
    
    UILabel *alreadyPayTitleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"已缴党费" font:FONT_15];
    [backView addSubview:alreadyPayTitleLabel];
    [alreadyPayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dateLabel);
        make.top.mas_equalTo(dateLabel.mas_bottom).offset(10);
        make.width.offset(70);
    }];
    
    UILabel *noPayTitleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"待缴党费" font:FONT_15];
    [backView addSubview:noPayTitleLabel];
    [noPayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alreadyPayTitleLabel);
        make.top.mas_equalTo(alreadyPayTitleLabel.mas_bottom).offset(5);
        make.bottom.offset(-5);
        make.height.mas_equalTo(alreadyPayTitleLabel.mas_height);
        make.width.mas_equalTo(alreadyPayTitleLabel);
    }];
    
    
    //缴费的金额
    UILabel *alreadyPayLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"350.00元" font:FONT_17];
    [backView addSubview:alreadyPayLabel];
    [alreadyPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alreadyPayTitleLabel);
        make.left.mas_equalTo(alreadyPayTitleLabel.mas_right).offset(5);
    }];
    _alreadyPayLabel = alreadyPayLabel;
    
//    待缴金额
    UILabel *noPayLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_system_red textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"350.00元" font:FONT_17];
    [backView addSubview:noPayLabel];
    [noPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(noPayTitleLabel);
        make.left.mas_equalTo(noPayTitleLabel.mas_right).offset(5);
    }];
    _noPayLabel = noPayLabel;
//    缴费按钮
    UIButton *payCostButton =
    [SKBuildKit buttonTitle:@"缴费"
            backgroundColor:Color_system_red
                 titleColor:[UIColor whiteColor]
                       font:FONT_17
               cornerRadius:ControlsCornerRadius
                  superview:backView];
    [payCostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.width.offset(70);
        make.height.offset(35);
        make.bottom.mas_equalTo(noPayLabel.mas_bottom);
    }];
    [payCostButton addTarget:self action:@selector(payCostEventDetected:) forControlEvents:UIControlEventTouchUpInside];

    
}
#pragma mark - action
- (void)payCostEventDetected:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(payCostListCellDuesVo:)]) {
        [_delegate payCostListCellDuesVo:_duesVo];
    }
}
- (void)setDuesVo:(DuesVo *)duesVo {
    _duesVo = duesVo;
    _dateLabel.text = duesVo.year ? duesVo.year : @"年月";
    //
    NSString *alreadyTitle = [NSString stringWithFormat:@"%g元",duesVo.feeReceived > 0 ? duesVo.feeReceived : 0.00];
    _alreadyPayLabel.attributedText = [self attributedTextFromString:alreadyTitle];
    
    NSString *noPayTitle = [NSString stringWithFormat:@"%@元",duesVo.payment ? duesVo.payment : @"0.00"];
    _noPayLabel.attributedText = [self attributedTextFromString:noPayTitle];
    
}
- (NSMutableAttributedString *)attributedTextFromString:(NSString *)string {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    if (string.length > 0) {
        [attributeString addAttributes:@{NSFontAttributeName : FONT_20} range:NSMakeRange(0, string.length - 1)];
        [attributeString addAttributes:@{NSFontAttributeName : FONT_15} range:NSMakeRange(string.length - 1, 1)];
    }
    return attributeString;
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
