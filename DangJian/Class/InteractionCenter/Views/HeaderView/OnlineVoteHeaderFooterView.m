//
//  OnlineVoteHeaderFooterView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineVoteHeaderFooterView.h"
#import "NSString+Util.h"
#import "SKLibsHelper.h"


@interface OnlineVoteHeaderFooterView ()


@property (nonatomic, assign) OnlineVoteHeaderFooterViewType decorationType;

@property (nonatomic, strong) DemocraticAppraisalVo *onlineVoteVo;

@property (nonatomic, strong) UIImageView *illuImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;


/**
 footer按钮
 */
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation OnlineVoteHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(OnlineVoteHeaderFooterViewType)type {
    
    if (self = [super initWithFrame:frame]) {
        
        _decorationType = type;
        [self setClipsToBounds:YES];
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    
    return self;
}
- (void)initCustomView {
    
    if (_decorationType == OnlineVoteHeaderiew ) {
        
        UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        topBackView.backgroundColor = SystemGrayBackgroundColor;
        [self addSubview:topBackView];
        
        NSMutableParagraphStyle *paragraphStyle = [SKBuildKit paragraphStyleLineSpace:5 firstLineHeadIndent:35];
        
        NSMutableAttributedString *titleText = [SKBuildKit attributedStringWithString:@"" paragraphStyle:paragraphStyle textColor:Color_3 textFont:FONT_16];
        UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:[UIColor whiteColor] textAligment:NSTextAlignmentLeft numberOfLines:0 attributedString:titleText];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.mas_equalTo(topBackView.mas_bottom).offset(10);
        }];
        _contentLabel = titleLabel;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.right.offset(-10);
            make.height.offset(180);
        }];
        _illuImageView = imageView;
        
        UILabel *describeLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:0 text:@"为您心中的”好党员“投票（单选）" font:FONT_16];
        [self addSubview:describeLabel];
        [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.right.offset(-15);
            make.top.mas_equalTo(imageView.mas_bottom).offset(20);
            make.bottom.offset(-10);
        }];
        _titleLabel = describeLabel;
    } else if (_decorationType == OnlineVoteFooterView ) {
        
        UIButton *voteButton = [SKBuildKit buttonTitle:@"投票" backgroundColor:Color_c titleColor:[UIColor whiteColor] font:FONT_16 cornerRadius:ControlsCornerRadius superview:self];
        [voteButton setFrame:CGRectMake(15, 5, CGRectGetWidth(self.frame) - 30, CGRectGetHeight(self.frame) - 10)];
        [voteButton addTarget:self action:@selector(footerViewButtonClickDetected:) forControlEvents:UIControlEventTouchUpInside];
        _commitButton = voteButton;
    }

}
- (void)reload {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerFooterView:)]) {
        self.onlineVoteVo = [self.delegate headerFooterView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForOnlineVoteHeaderView:height:)]) {
        
        [self.delegate heightForOnlineVoteHeaderView:self height:[self headerViewHeight]];
    }
}
- (void)setOnlineVoteVo:(DemocraticAppraisalVo *)onlineVoteVo {
    
    _onlineVoteVo = onlineVoteVo;
    if (!onlineVoteVo.image || _onlineVoteVo.image.length == 0) {
        [_illuImageView setHidden:YES];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.bottom.offset(-10);
        }];
    }
    [_illuImageView sd_setImageWithURL:[NSURL URLWithString:_onlineVoteVo.image] placeholderImage:[UIImage imageNamed:@"banner_placeholder_icon"]];
    NSMutableParagraphStyle *paragraphStyle = [SKBuildKit paragraphStyleLineSpace:5 firstLineHeadIndent:35];
   
    NSMutableAttributedString *titleText;
    if (_onlineVoteVo.content) {
        titleText = [SKBuildKit attributedStringWithString:_onlineVoteVo.content paragraphStyle:paragraphStyle textColor:Color_3 textFont:FONT_16];
    }
    _contentLabel.attributedText = titleText;
    _titleLabel.text = [NSString stringWithFormat:@"%@%@",_onlineVoteVo.title,_onlineVoteVo.radio ? @"（单选）" : @"（多选）"];
}


- (CGFloat)headerViewHeight {
    
    CGFloat headerHeight;
    NSMutableParagraphStyle *paragraphStyle = [SKBuildKit paragraphStyleLineSpace:5 firstLineHeadIndent:35];

    NSString *titleSting = _onlineVoteVo.content;
    CGFloat titleHeight = [titleSting boundingHeightWithSize:CGSizeMake(kScreen_Width - 20, 1000) font:FONT_16 paragraphStyle:paragraphStyle];
    headerHeight = titleHeight;

    
    
    if (!_onlineVoteVo.image || _onlineVoteVo.image.length == 0) {
        headerHeight += 0;
    } else {
        
        //待优化
//        CGSize imageSize;
//        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_onlineVoteVo.image]];
//        CGFloat imageHeight;
//        imageSize = [SKLibsHelper downloadImageSizeWithURL:imageURL];
//
//        if (imageSize.height == 0) {
//            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
//            imageSize = img.size;
//        }
//        if (imageSize.height == 0) {
//            
//            imageSize = [SKLibsHelper getURLImageSizeWithURL:imageURL];
//        }
//        
//        if (imageSize.height != 0) {
//            imageHeight = (kScreen_Width - 20) *imageSize.height/imageSize.width;
//        }
//
//        if (imageHeight != 0) {
//            
//            headerHeight += imageHeight;
//
//        }  else {
            headerHeight += 180;

//        }
    }
    
    NSString *describeString = _onlineVoteVo.title;
    headerHeight += [describeString heightWithFont:FONT_16 constrainedToWidth:kScreen_Width - 30];
    headerHeight += 60;
    [self layoutSubviews];
    return headerHeight;
}

#pragma mark - action
- (void)footerViewButtonClickDetected:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerViewSelected:)]) {
        [self.delegate footerViewSelected:sender];
    }
}
#pragma mark -- setter
- (void)setCanClicked:(BOOL)canClicked {
    
    _canClicked = canClicked;
    
    if (canClicked) {
        [_commitButton setBackgroundColor:Color_system_red];
        [_commitButton setUserInteractionEnabled:YES];
    } else {
        [_commitButton setBackgroundColor:Color_c];
        [_commitButton setUserInteractionEnabled:NO];
    }
}

@end
