//
//  DemocraticReviewOptionCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DemocraticReviewOptionCell.h"
#import "DemocraticSelectOptionButton.h"


static CGFloat const NameLabelWidth = 90.0f;
@interface DemocraticReviewOptionCell ()

@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *bottomLine;
@end

@implementation DemocraticReviewOptionCell

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
    
    
    
    UILabel *nameLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:nil font:FONT_15];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.offset(NameLabelWidth);
    }];
    nameLabel.text = @"张三";
    _nameLabel = nameLabel;
    
    DemocraticSelectOptionButton *tmpButton;
    CGFloat buttonWidth = (kScreen_Width - 15 - NameLabelWidth)/3;
    for (NSInteger i = 0; i < 3; i ++) {
        DemocraticSelectOptionButton *button = [DemocraticSelectOptionButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"优秀" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToSelectOption:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.contentView addSubview:button];
        if (!tmpButton) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15 + NameLabelWidth);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.width.offset(buttonWidth);
                make.height.mas_equalTo(self.mas_height);
            }];
        } else {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tmpButton.mas_right);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.width.offset(buttonWidth);
                make.height.mas_equalTo(tmpButton.mas_height);
            }];
        }
        [self.buttonArray addObject:button];
        tmpButton = button;
    }
    
    //实例化一个CAShapeLayer对象
    CALayer *border = [CALayer layer];
    [border setFrame:CGRectMake(0, 50 - 0.5, kScreen_Width, 0.5)];
    //不设置填充颜色,如果不置空默认为黑色
    border.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    //添加到当前view的layer层上 , 这里注意不要无意义的重复添加哦
    [self.contentView.layer addSublayer:border];
    
}
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}
#pragma mark - action
- (void)clickToSelectOption:(UIButton *)sender {
    
    __block NSInteger selectIndex;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag == sender.tag) {
            
            obj.selected = YES;
            selectIndex = idx + 1;
        } else {
            obj.selected = NO;
        }
    }];
    _appraisalVo.choiceResult = [NSString stringWithFormat:@"%ld",(long)selectIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(democraticReviewOption:indexPath:)]) {
        [self.delegate democraticReviewOption:_appraisalVo indexPath:_indexPath];
    }

}
- (void)setAppraisalVo:(DemocraticAppraisalVo *)appraisalVo {
    
    _appraisalVo = appraisalVo;
    if (self.buttonArray.count == appraisalVo.choiceArray.count) {
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = appraisalVo.choiceArray[idx];
            [obj setTitle:title forState:UIControlStateNormal];
        }];
    }
    _nameLabel.text = appraisalVo.userName;
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    
    _indexPath = indexPath;
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
