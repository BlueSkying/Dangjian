//
//  NewsCustomButtonCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "NewsCustomButtonCell.h"
#import "SKTableViewCustomButton.h"

@interface NewsCustomButtonCell ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation NewsCustomButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
    return self;
}
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}
- (void)setCustomArray:(NSArray<NSDictionary *> *)customArray {
    _customArray = customArray;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_buttonArray && _buttonArray.count >0) return;
    
    NSInteger titleCount = _customArray.count;
    CGFloat buttonWidth = CGRectGetWidth(rect)/titleCount;
    CGFloat buttonHeight = CGRectGetHeight(rect);
    for (NSInteger i = 0; i < _customArray.count; i ++) {
        
        SKTableViewCustomButton *customButton = [SKTableViewCustomButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *param = _customArray[i];
        [customButton setFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight)];
        [customButton setTitle:[param valueForKey:@"title"] forState:UIControlStateNormal];
        [customButton setImage:[UIImage imageNamed:[param valueForKey:@"imageName"]] forState:UIControlStateNormal];
        customButton.tag = i;
        [customButton addTarget:self action:@selector(clickEventDetected:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:customButton];
        [self.buttonArray addObject:customButton];
    }
}

#pragma mark - action
- (void)clickEventDetected:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToSelectItem:)]) {
        [self.delegate clickToSelectItem:sender];
    }
    
    //针对多个section 的需要
    if (self.delegate && [self.delegate respondsToSelector:@selector(customButtonToSelectIndexPath:)]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:_section];
        [self.delegate customButtonToSelectIndexPath:indexPath];
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
