//
//  OnlineTestHeaderView.m
//  DangJian
//
//  Created by Sakya on 17/5/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestHeaderView.h"
#import "NSString+Util.h"



@interface OnlineTestHeaderView ()

/**
 题号
 */
@property (nonatomic, strong) UILabel *qidLabel;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;


/**
 题目排布风格
 */
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

@end

@implementation OnlineTestHeaderView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *headerId = @"headerView";
    OnlineTestHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    if (headerView == nil) {
        headerView = [[OnlineTestHeaderView alloc] initWithReuseIdentifier:headerId];
    }
    
    return headerView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:[UIColor whiteColor] textAligment:NSTextAlignmentLeft numberOfLines:0 attributedString:nil];
    
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.top.offset(0);
        make.right.offset(-15);
        make.bottom.offset(0);
    }];
    _titleLabel = titleLabel;

    
}
- (void)setTitle:(NSString *)title {
    
    _title = title;

    NSAttributedString *string = [SKBuildKit attributedStringWithString:title paragraphStyle:self.paragraphStyle textColor:Color_3 textFont:FONT_17];
    _titleLabel.attributedText = string;
    
}

- (CGFloat)heighthHeaderView {
   
    //计算header高度

    CGFloat height = [_title boundingHeightWithSize:CGSizeMake(kScreen_Width - 30, 1000) font:FONT_17 paragraphStyle:self.paragraphStyle];
    if (height < 45)
        
        height = 45;
    else
        height += 30;
    
    return height;
}
- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        NSString *testContentStr = _qidId;
        CGFloat labelWidth = [testContentStr  widthWithFont:FONT_17 constrainedToHeight:18];
        paragraphStyle.headIndent = labelWidth;//整体缩进(首行除外)
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5.0f;
        _paragraphStyle = paragraphStyle;
    }
    return _paragraphStyle;
}
- (NSString *)qidId {
    if (!_qidId) {
        _qidId = @"Q0.";
    }
    return _qidId;
}
@end
