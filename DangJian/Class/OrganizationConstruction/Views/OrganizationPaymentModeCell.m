//
//  OrganizationPaymentModeCell.m
//  DangJian
//
//  Created by Sakya on 17/6/5.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationPaymentModeCell.h"


//支付宝buttontag
static CGFloat const ALIPAYBUTTONTAG = 1000;
//微信tag
static CGFloat const WECHATBUTTONTAG = 1001;
//选中图片tag
static CGFloat const SELECTIMAGEVIEWTAG = 1002;

@interface PaymentModeView ()

@end
@implementation PaymentModeView

- (instancetype)init {
    if (self = [super init]) {
        
        //支付宝
        UIButton *aliPayView = [self creatViewDependsMode:PaymentModeAlipay];
        [self addSubview:aliPayView];
        aliPayView.tag = ALIPAYBUTTONTAG;
        [aliPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.right.offset(0);
        }];
//        设置默认选中状态
//        [(UIImageView *)[aliPayView viewWithTag:SELECTIMAGEVIEWTAG] setHighlighted:YES];
        
        UIView *midLine = [[UIView alloc] init];
        [self addSubview:midLine];
        midLine.backgroundColor = SystemGraySeparatedLineColor;
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(0);
            make.top.mas_equalTo(aliPayView.mas_bottom);
            make.right.offset(0);
            make.height.offset(.5);
        }];
//        微信
        UIButton *weChatView = [self creatViewDependsMode:PaymentModeWeChat];
        [self addSubview:weChatView];
        weChatView.tag = WECHATBUTTONTAG;
        [weChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(aliPayView);
            make.top.mas_equalTo(aliPayView.mas_bottom).offset(.5);
            make.bottom.offset(0);
            make.height.mas_equalTo(aliPayView.mas_height);
            make.right.offset(0);
        }];
        [(UIImageView *)[weChatView viewWithTag:SELECTIMAGEVIEWTAG] setHighlighted:YES];

    }
    return self;
}
- (UIButton *)creatViewDependsMode:(PaymentChannelMode)paymentMode  {
    
    UIButton *paymentBackView = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self addSubview:paymentBackView];
    
    UIImageView *selectStateImageView = [[UIImageView alloc] init];
    [paymentBackView addSubview:selectStateImageView];
    selectStateImageView.image = [UIImage imageNamed:@"organization_payChannel_unSelected_icon"];
    selectStateImageView.highlightedImage = [UIImage imageNamed:@"organization_payChannel_selected_icon"];
    [selectStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(15);
        make.height.mas_equalTo(selectStateImageView.mas_width);
        make.centerY.mas_equalTo(paymentBackView);
    }];
    selectStateImageView.tag = SELECTIMAGEVIEWTAG;

    UIImageView *paymentImageView = [[UIImageView alloc] init];
    [paymentBackView addSubview:paymentImageView];
    if (paymentMode == PaymentModeAlipay) {
        paymentImageView.image = [UIImage imageNamed:@"organization_alipayPay_icon"];

    } else {
        paymentImageView.image = [UIImage imageNamed:@"organization_weChatPay_icon"];
    }
    [paymentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectStateImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(paymentBackView);

    }];
    [paymentBackView addTarget:self action:@selector(paymentChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
    return paymentBackView;
}

- (void)paymentChangeSelected:(UIButton *)sender {
    
    
    if (sender.tag == ALIPAYBUTTONTAG) {
    
        [SKHUDManager showBriefAlert:@"支付宝支付功能暂未开通"];
        return;
    }
    
    
    [(UIImageView *)[sender viewWithTag:SELECTIMAGEVIEWTAG] setHighlighted:YES];
    if (sender.tag == ALIPAYBUTTONTAG) {
        [(UIImageView *)[[self viewWithTag:WECHATBUTTONTAG] viewWithTag:SELECTIMAGEVIEWTAG] setHighlighted:NO];
        
    } else {
        
        [(UIImageView *)[[self viewWithTag:ALIPAYBUTTONTAG] viewWithTag:SELECTIMAGEVIEWTAG] setHighlighted:NO];
    }
    
    if (self.paymentCell.delegate && [self.paymentCell.delegate respondsToSelector:@selector(paymentChannelSelected:)]) {
        [self.paymentCell.delegate paymentChannelSelected:sender];
    }
    
}

@end


@implementation OrganizationPaymentModeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    

    PaymentModeView *payView = [[PaymentModeView alloc] init];
    [self.contentView addSubview:payView];
    payView.paymentCell = self;
    [payView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.offset(15 + 120);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
        
    }];
 

    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"支付方式" font:FONT_16];
    [self addSubview:titleLabel];
    __weak typeof(self) weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo([weakSelf viewWithTag:1000]);
        make.width.offset(120);
    }];
    
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
