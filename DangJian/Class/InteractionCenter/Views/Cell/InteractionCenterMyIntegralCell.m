//
//  InteractionCenterMyIntegralCell.m
//  DangJian
//
//  Created by Sakya on 17/6/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterMyIntegralCell.h"
#import "InteractionCenterMyIntegralModel.h"


@interface InteractionCenterMyIntegralCell ()


/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 得分
 */
@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation InteractionCenterMyIntegralCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:nil font:FONT_16];
    [self.contentView addSubview:titleLabel];
    __weak typeof(self) weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView);
        
    }];
    _titleLabel = titleLabel;
    
    UILabel *scoreLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_system_red textAligment:NSTextAlignmentRight numberOfLines:1 text:nil font:FONT_16];
    [self.contentView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.left.greaterThanOrEqualTo(titleLabel.mas_right).offset(10);
    }];
    _scoreLabel = scoreLabel;
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, 44.5, kScreen_Width, .5);
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.contentView.layer addSublayer:bottomLine];
}
+ (CGSize)calculateSizeWithData:(id<TemplateRenderProtocol>)data constrainedToSize:(CGSize)size {
    
    return CGSizeMake(kScreen_Width, 45);
}

- (void)processData:(id <TemplateRenderProtocol>)data {
    
    InteractionCenterMyIntegralModel *integralVo = (InteractionCenterMyIntegralModel *)data;
    _titleLabel.text = integralVo.desc;
    _scoreLabel.text = [NSString stringWithFormat:@"+%@分",integralVo.result];
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
