//
//  InteractionCenterThePartyTraceCell.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterThePartyTraceCell.h"
#import "InteractionCenterThePartyTraceModel.h"

@interface InteractionCenterThePartyTraceCell ()


/**
 党迹内容
 */
@property (nonatomic, strong) UILabel *subjectLabel;

/**
 党迹时间
 */
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *dateBackView;

@end

@implementation InteractionCenterThePartyTraceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    
    UIImageView *grayLineImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:grayLineImageView];
    [grayLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.bottom.offset(0);
        make.width.offset(4);
    }];
    grayLineImageView.backgroundColor = SystemGraySeparatedLineColor;
    
    //背景
    UIView *traceBackView = [[UIView alloc] init];
    [self.contentView addSubview:traceBackView];
    traceBackView.backgroundColor = [UIColor whiteColor];
    [traceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(grayLineImageView.mas_right).offset(20);
        make.right.offset(-10);
        make.top.offset(20);
        make.bottom.offset(0);
    }];
    traceBackView.layer.masksToBounds = YES;
    traceBackView.layer.cornerRadius = ControlsCornerRadius;

    


    
//    日期背景
    UIView *dateBackView = [[UIView alloc] init];
    [traceBackView addSubview:dateBackView];
    [dateBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.height.offset(35);
        make.right.offset(0);
    }];
    _dateBackView = dateBackView;

    
//    日期
    UILabel *dateLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:[UIColor whiteColor] textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"2017/4/04" font:FONT_17];
    [dateBackView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-10);
    }];
    _dateLabel = dateLabel;
    
//    主题
    UILabel *subjectLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:0 text:@"测试数据" font:FONT_16];
    [traceBackView addSubview:subjectLabel];
    [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.right.offset(-10);
        make.top.mas_equalTo(dateBackView.mas_bottom).offset(10);
        make.bottom.offset(-10);
        
    }];
    _subjectLabel = subjectLabel;
    
//    圆圈
    UIImageView *signImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:signImageView];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(dateLabel);
        make.centerX.mas_equalTo(grayLineImageView);
        make.width.offset(20);
        make.height.mas_equalTo(signImageView.mas_width);
    }];
    signImageView.image = [UIImage imageNamed:@"trace_redCircle_icon"];
    _circleImageView = signImageView;
    
    //箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(signImageView);
        make.right.mas_equalTo(traceBackView.mas_left).offset(0);
        make.width.offset(10);
        make.height.mas_equalTo(arrowImageView.mas_width);
    }];
    arrowImageView.image = [UIImage imageNamed:@"trace_redArrow_icon"];
    _arrowImageView = arrowImageView;
 
}

+ (CGSize)calculateSizeWithData:(id<TemplateRenderProtocol>)data constrainedToSize:(CGSize)size {
      InteractionCenterThePartyTraceModel *traceModel = (InteractionCenterThePartyTraceModel *)data;
    return CGSizeMake(kScreen_Width, traceModel.cellHeight);
}

- (void)processData:(id <TemplateRenderProtocol>)data {
    
    InteractionCenterThePartyTraceModel *traceModel = (InteractionCenterThePartyTraceModel *)data;
    _dateLabel.text = traceModel.date;
    _subjectLabel.text = traceModel.subject;
    _arrowImageView.image = [UIImage imageNamed:traceModel.arrowImageName];
    _circleImageView.image = [UIImage imageNamed:traceModel.circleImageName];
    _dateBackView.backgroundColor = traceModel.gradientColor;
}

- (void)tapOnePlace:(TapBlock) block
{
    
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
