//
//  TheoryReviewCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TheoryReviewCell.h"



@interface TheoryReviewView ()

/**
 图标
 */
@property (nonatomic, strong) UIImageView *reviewImageView;
/**
 文字
 */
@property (nonatomic, strong) UILabel *reviewLabel;
@end

@implementation TheoryReviewView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initMainCustomView];
        
    }
    return self;
}
- (void)initMainCustomView {
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:[UIColor whiteColor] textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:0 text:nil font:FontScale_15];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    _reviewLabel = titleLabel;
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(- 15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height).multipliedBy(.5);
        make.width.mas_equalTo(imageView.mas_height);
    }];
    _reviewImageView = imageView;
}

@end

@implementation TheoryReviewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView {
    
    TheoryReviewView *handoverView;
    
    NSArray *imageArray = @[@"learn_onlineTest_icon",
                            @"learn_historicalPerformance_icon"];
    NSArray *titleArray = @[@"在线考试",
                            @"历史成绩"];
    for (NSInteger i = 0; i < 2; i ++) {
        TheoryReviewView *reviewView = [[TheoryReviewView alloc] init];
        [self.contentView addSubview:reviewView];
        if (handoverView) {
           
            [reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(handoverView.mas_right).offset(.5);
                make.centerY.mas_equalTo(handoverView.mas_centerY);
                make.height.mas_equalTo(handoverView.mas_height);
                make.right.mas_equalTo(self.contentView.mas_right);
                make.width.mas_equalTo(handoverView.mas_width);
            }];
        } else {
            [reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(0);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.height.mas_equalTo(self.contentView.mas_height);
            }];
        }
        if (i != 1) {
            UIView *grayLine = [[UIView alloc] init];
            [self.contentView addSubview:grayLine];
            grayLine.backgroundColor = SystemGraySeparatedLineColor;
            [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(reviewView.mas_right);
                make.height.equalTo(reviewView.mas_height);
                make.centerY.mas_equalTo(reviewView.mas_centerY);
                make.width.offset(.5);
            }];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theoryReviewItemSelect:)];
        [reviewView addGestureRecognizer:tapGesture];

        UIView *singleTapView = [tapGesture view];
        singleTapView.tag = i;
        
        reviewView.reviewImageView.image = [UIImage imageNamed:imageArray[i]];
        reviewView.reviewLabel.text = titleArray[i];
        handoverView = reviewView;
    }
    handoverView = nil;
}
- (void)theoryReviewItemSelect:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag;
    if (_delegate && [_delegate respondsToSelector:@selector(theoryReviewCellItemSelectIndex:)]) {
        [_delegate theoryReviewCellItemSelectIndex:index];
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
