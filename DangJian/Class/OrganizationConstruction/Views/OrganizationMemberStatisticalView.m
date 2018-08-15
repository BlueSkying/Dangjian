//
//  OrganizationMemberStatisticalView.m
//  DangJian
//
//  Created by Sakya on 2017/6/13.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationMemberStatisticalView.h"

//换届时间label的tag
static CGFloat const DTATLABLETAG = 10000;

static CGFloat const ITEMLABELSIZEWIDTH = 64;

//党员信息统计的的下部view
@interface OrganizationStatisticalCountView ()


@end

@implementation OrganizationStatisticalCountView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *titleAttay = @[@"党员总数",
                                @"男党员总数",
                                @"女党员总数",
                                @"汉族",
                                @"少数民族",
                                @"35岁及以下",
                                @"大专学历及以上"];
        CGFloat itemSpaceX = (CGRectGetWidth(self.frame) -  ITEMLABELSIZEWIDTH * 4)/5;
         CGFloat itemSpaceY = (CGRectGetHeight(self.frame) -  ITEMLABELSIZEWIDTH * 2)/3;
        for (NSInteger i = 0; i < 2; i ++) {
            for (NSInteger row = 0; row < 4; row ++) {
                
                @autoreleasepool {
                    
                    NSInteger indexCount = i * 4 + row;
                    if (indexCount == 7) break;
                    OrganizationItemView *itemView = [[OrganizationItemView alloc] init];
                    itemView.frame = CGRectMake((ITEMLABELSIZEWIDTH + itemSpaceX) * row + itemSpaceX, (ITEMLABELSIZEWIDTH + itemSpaceY) * i + itemSpaceY, ITEMLABELSIZEWIDTH, ITEMLABELSIZEWIDTH);
                    itemView.tag = indexCount + 1000;
                    itemView.titleLabel.text = titleAttay[indexCount];
                    itemView.countLabel.text = @"0";
                    [self addSubview:itemView];
                }
            }
        }
    }
    return self;
}

@end



@implementation OrganizationItemView

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    self.backgroundColor = SystemGrayBackgroundColor;
    self.layer.cornerRadius = ITEMLABELSIZEWIDTH/2;
    
    UILabel *countLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_system_red textAligment:NSTextAlignmentCenter numberOfLines:1 text:nil font:FONT_19];
    [self addSubview:countLabel];
    _countLabel = countLabel;
    __weak typeof(self) weakSelf = self;
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.offset(8);
    }];
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentCenter numberOfLines:2 text:nil font:FONT_12];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(countLabel.mas_bottom).offset(0);
        make.centerX.mas_equalTo(weakSelf);
        make.width.offset(60);
    }];
    _titleLabel = titleLabel;

}

@end
@interface OrganizationMemberStatisticalView ()

@property (nonatomic, strong) OrganizationStatisticalCountView *statisticalCountView;

@property (nonatomic, strong) UIView *topTransitionView;

@end

@implementation OrganizationMemberStatisticalView

- (instancetype)initWithFrame:(CGRect)frame
                   headerType:(OrganizationStatisticalHeaderType)headerType {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        [self initCustomViewHeaderType:headerType];
    }
    return self;
}
- (void)initCustomViewHeaderType:(OrganizationStatisticalHeaderType)headerType {
    
    
    CGRect countViewFrame = CGRectZero;
    if (headerType == OrganizationStatisticalNormalHeaderType) {
        
        countViewFrame = CGRectMake(0, 0, kScreen_Width, 170);
        
    } else if (OrganizationStatisticalDateHeaderType) {
        
        _topTransitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        [self addSubview:_topTransitionView];
        UILabel *transitionLable = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"下次换届时间:" font:FONT_16];
        [_topTransitionView addSubview:transitionLable];
        __weak typeof(self) weakSelf = self;
        [transitionLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.mas_equalTo(weakSelf.topTransitionView);
        }];
        
        UILabel *dateLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_system_red textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"2010年5月10日" font:FONT_16];
        [_topTransitionView addSubview:dateLabel];
        dateLabel.tag = DTATLABLETAG;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(transitionLable.mas_right).offset(5);
            make.centerY.mas_equalTo(weakSelf.topTransitionView);
        }];
        CALayer *grayLine = [CALayer layer];
        grayLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
        grayLine.frame = CGRectMake(0, CGRectGetMaxY(_topTransitionView.frame) - 0.5, CGRectGetWidth(_topTransitionView.frame), 0.5);
        [_topTransitionView.layer addSublayer:grayLine];
        
        countViewFrame = CGRectMake(0, 50, kScreen_Width, 170);

    }
    _statisticalCountView = [[OrganizationStatisticalCountView alloc] initWithFrame:countViewFrame];
    [self addSubview:_statisticalCountView];
    
}
- (void)setMemberVo:(OrganizationalMemberVo *)memberVo {
    
    if (!memberVo) return;
    
    if (_topTransitionView) {
        ((UILabel *)[_topTransitionView viewWithTag:DTATLABLETAG]).text = memberVo.changeDate;
    }
    
    for (NSInteger i = 1000; i < 1007; i ++) {
        OrganizationItemView *itmeView = (OrganizationItemView *)[_statisticalCountView viewWithTag:i];
        if (itmeView) {
            switch (i) {
                case 1000:
                    itmeView.countLabel.text = memberVo.all;
                    break;
                case 1001:
                    itmeView.countLabel.text = memberVo.man;
                    break;
                case 1002:
                    itmeView.countLabel.text = memberVo.woman;
                    break;
                case 1003:
                    itmeView.countLabel.text = memberVo.han;
                    break;
                case 1004:
                    itmeView.countLabel.text = memberVo.min;
                    break;
                case 1005:
                    itmeView.countLabel.text = memberVo.age;
                    break;
                case 1006:
                    itmeView.countLabel.text = memberVo.edu;
                    break;
                default:
                    break;
            }
        }
    }

}

@end
