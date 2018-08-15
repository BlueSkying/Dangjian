//
//  PublickNewsListCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PublickNewsListCell.h"

@interface PublickNewsListCell ()


/**
 新闻图片
 */
@property (nonatomic, strong) UIImageView *newsImageView;
/**
 文章标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 阅读量
 */
@property (nonatomic, strong) UILabel *readLabel;


@end

@implementation PublickNewsListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
#pragma mark - init
- (void)initCustomView {
    
    UIImageView *newsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:newsImageView];
    newsImageView.image = [UIImage imageNamed:@"newsCell_placeholder_icon"];
    [newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(SKXFrom6(65));
        make.centerY.mas_equalTo(self.contentView);
        make.width.offset(SKXFrom6(85));
        
    }];
    [newsImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    newsImageView.contentMode =  UIViewContentModeScaleAspectFill;
    newsImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    newsImageView.clipsToBounds  = YES;
    [newsImageView.layer setCornerRadius:3.0f];
    _newsImageView = newsImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(_newsImageView.mas_top);
        make.right.mas_equalTo(_newsImageView.mas_left).offset(-12);
    }];
    _titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.text = @"2017-01-12";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.mas_equalTo(newsImageView.mas_bottom);
        make.width.offset(120);
        
    }];
    timeLabel.textColor = Color_gray_d;
    timeLabel.font = FontScale_11;
    _timeLabel = timeLabel;
    
    
    UILabel *readLabel = [[UILabel alloc] init];
    [self.contentView addSubview:readLabel];
    readLabel.text = @"999";
    readLabel.textColor = Color_gray_d;
    readLabel.font = FontScale_11;
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_newsImageView.mas_left).offset(-12);
        make.centerY.mas_equalTo(timeLabel.mas_centerY);
    }];
    _readLabel = readLabel;
    UIImageView *readImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:readImageView];
    readImageView.image = [UIImage imageNamed:@"cell_read_icon"];
    [readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(readLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(readLabel.mas_centerY);
        make.width.offset(12);
        make.height.mas_equalTo(readImageView.mas_width);
    }];
    
//    UIImageView *bottomLine = [[UIImageView alloc] init];
//    [self.contentView addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.right.offset(0);
//        make.bottom.offset(0);
//        make.height.offset(.5);
//    }];
//    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, SKXFrom6(CellNewsListHeight) - 0.5, kScreen_Width, 0.5);
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
}
- (void)setArticleVo:(ArticleListBaseModel *)articleVo {
    
    NSString *readCount;
    if ([articleVo.count integerValue] > 1000) {
        readCount = @"999";
    } else if (!articleVo.count ||
               [articleVo.count isEqualToString:@""]) {
        
        readCount = @"0";
    } else {
        readCount = articleVo.count;
    }
    _readLabel.text = readCount;
    NSURL *imageUrl = [NSURL URLWithString:articleVo.imgUrl];
    [_newsImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"newsCell_placeholder_icon"]];
    _timeLabel.text = articleVo.createTime;
    
    //添加行距设置mutableString
    NSMutableParagraphStyle *style = [SKBuildKit paragraphStyleLineSpace:4 firstLineHeadIndent:0];

    _titleLabel.attributedText = [SKBuildKit attributedStringWithString:articleVo.title paragraphStyle:style textColor:Color_3 textFont:FontScale_14];
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
