//
//  DuesRecordCell.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DuesRecordCell.h"

@implementation DuesRecordContentView

- (instancetype)init {
    if (self = [super init]) {
        
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UILabel *dateLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"2017年06月" font:FONT_16];
    [self addSubview:dateLabel];
    __weak typeof(self) weakSelf = self;
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakSelf);
        make.left.offset(15);
        make.width.offset(110);
    }];
    _dateLabel = dateLabel;
    
    UILabel *toBePaidLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"350.00元" font:FONT_16];
    [self addSubview:toBePaidLabel];
    [toBePaidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(dateLabel.mas_right).offset(15);
        make.centerY.mas_equalTo(weakSelf);

    }];
    _toBePaidLabel = toBePaidLabel;
    
    UILabel *alreadyPayLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"350.00元" font:FONT_16];
    [self addSubview:alreadyPayLabel];
    [alreadyPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(toBePaidLabel.mas_right).offset(5);
        make.width.mas_equalTo(toBePaidLabel);
    }];
    _alreadyPayLabel = alreadyPayLabel;
    
}


@end

@interface DuesRecordCell ()


@property (nonatomic, strong) DuesRecordContentView *duesRecordView;

@end

@implementation DuesRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    _duesRecordView = [[DuesRecordContentView alloc] init];
    [self.contentView addSubview:_duesRecordView];
    __weak typeof(self) weakSelf = self;

    [_duesRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
    }];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, 44.5, kScreen_Width, 0.5);
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.layer addSublayer:bottomLine];
    
}
- (void)setDuesVo:(DuesVo *)duesVo {
   
    _duesVo = duesVo;
    _duesRecordView.dateLabel.text = duesVo.year ? duesVo.year : @"年月";
    _duesRecordView.toBePaidLabel.text = [NSString stringWithFormat:@"%g元",duesVo.feeReceived > 0 ? duesVo.feeReceived : 0.00];
    _duesRecordView.alreadyPayLabel.text = [NSString stringWithFormat:@"%@元",duesVo.payment ? duesVo.payment : @"0.00"];
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
