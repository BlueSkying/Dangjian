//
//  MemberEditTextFieldCell.m
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MemberEditTextFieldCell.h"

@interface MemberEditTextFieldCell ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation MemberEditTextFieldCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    _textField = [[UITextField alloc] init];
    [self.contentView addSubview:_textField];
    _textField.font = FONT_16;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.right.offset(-10);
    }];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.tintColor = Color_system_red;
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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
    arrowImageView.hidden = YES;
    _arrowImageView = arrowImageView;
    
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
- (void)setCustomVo:(CellCustomVo *)customVo {
    _customVo = customVo;
    
    if ([customVo.key isEqualToString:@"train"] ||
        [customVo.key isEqualToString:@"award"] ||
        [customVo.key isEqualToString:@"punishment"]||
        [customVo.key isEqualToString:@"sex"]||
        [customVo.key isEqualToString:@"birth"]||
        [customVo.key isEqualToString:@"partyTime"]||
        [customVo.key isEqualToString:@"education"]) {
        
        self.arrowImageView.hidden = NO;
        _textField.userInteractionEnabled = NO;
    } else {

        self.arrowImageView.hidden = YES;
        _textField.userInteractionEnabled = YES;

    }
    _textField.placeholder = customVo.title;
    _textField.text = (customVo.content && ((NSString *)customVo.content).length > 0) ? customVo.content : nil;
    if ([customVo.key isEqualToString:@"train"] ||
        [customVo.key isEqualToString:@"award"] ||
        [customVo.key isEqualToString:@"punishment"]) {
        
        _textField.text = customVo.title;
    }
 
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _textField.indexPath = indexPath;
}
#pragma mark - textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    NSString *contentText = textField.text;
    NSString *fillString;
    //
    if ([_customVo.key isEqualToString:@"address"]) {
//        个别特殊信息限制
        fillString =  contentText.length > 20 ? [contentText substringToIndex:20] : contentText;
        textField.text = fillString;
        
    } else {
        //限制输入10个字以内
        fillString =  contentText.length > 10 ? [contentText substringToIndex:10] : contentText;
        textField.text = fillString;
    }
 
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldCellChangeText:key:indexPath:)]) {
        [_delegate textFieldCellChangeText:fillString key:_customVo.key indexPath:_indexPath];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[Helper superViewControllerWithView:self].view endEditing:YES];
    return YES;
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
