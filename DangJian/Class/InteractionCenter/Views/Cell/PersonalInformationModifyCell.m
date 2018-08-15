//
//  PersonalInformationModifyCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PersonalInformationModifyCell.h"

@interface PersonalInformationModifyCell ()

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *contentLabel;

/**
 头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation PersonalInformationModifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {

    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_3 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"头像" font:FONT_16];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.offset(150);
    }];
    _titleLable = titleLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.offset(CELLRIGHTARROWSIZE);
        make.height.mas_equalTo(arrowImageView.mas_width);

    }];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    arrowImageView.image = [UIImage imageNamed:@"cell_rightArrow_icon"];

    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:headImageView];
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headImageView.contentMode =  UIViewContentModeScaleAspectFill;
    headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    headImageView.clipsToBounds  = YES;
    [headImageView.layer setCornerRadius:SKXFrom6(50)/2];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(arrowImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.offset(SKXFrom6(50));
        make.width.mas_equalTo(headImageView.mas_height);
    }];
    [headImageView setHidden:YES];

    [headImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493039372515&di=aa110453ff97e55bd1d453b5e4dd645a&imgtype=0&src=http%3A%2F%2Ft1.niutuku.com%2F960%2F56%2F56-441647.jpg"] placeholderImage:[UIImage imageNamed:@"user_headGrayPlaceholder_icon"]];
    _headImageView = headImageView;
    
    UILabel *contenLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_9 textAligment:NSTextAlignmentRight numberOfLines:1 text:@"用户名" font:FontScale_15];
    [self.contentView addSubview:contenLabel];
    [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(arrowImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.offset(160);
        
    }];
    
    [contenLabel setHidden:YES];
    _contentLabel = contenLabel;
    
    UIImageView *bottomLine = [[UIImageView alloc] init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(.5);
    }];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
}
#pragma mark - setter
- (void)setType:(PersonalInformationModifyCellType)type {
    
    switch (type) {
        case PersonalModifyHeaderCellType:
            [_contentLabel setHidden:YES];
            [_headImageView setHidden:NO];
            break;
        case PersonalModifyNameCellType:
            [_contentLabel setHidden:NO];
            [_headImageView setHidden:YES];
            
            break;
        default:
            break;
    }
}

- (void)setConfigParams:(NSDictionary *)configParams {
    
    _titleLable.text = configParams[@"title"];
}
- (void)setImageParams:(NSDictionary *)imageParams {
    id image = [imageParams objectForKey:@"image"];
    if ([image isKindOfClass:[UIImage class]]) {
        _headImageView.image = image;
    } else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_headGrayPlaceholder_icon"]];
    }
}

- (void)setCustomVo:(CellCustomVo *)customVo {
   
    _customVo = customVo;
    
    _titleLable.text = customVo.title;
    if ([customVo.key isEqualToString:@"image"]) {
        id image = customVo.content;
        if ([image isKindOfClass:[UIImage class]]) {
            _headImageView.image = image;
        } else {
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_headGrayPlaceholder_icon"]];
        }
    } else {
        _contentLabel.text = customVo.content;
    }
}
- (void)setContentText:(NSString *)contentText {
    
    _contentLabel.text = contentText;
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
