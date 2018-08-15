//
//  PublickSingleTextFieldCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PublickSingleTextFieldCell.h"
#import "SKTextField.h"

//左侧title宽度
static CGFloat const CellLeftTitleWidth = 100;

@interface PublickSingleTextFieldCell ()<UITextFieldDelegate>

@property (nonatomic, strong) SKTextField *textField;

@property (nonatomic, copy) NSString *key;
@end
@implementation PublickSingleTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    
    return self;
}
- (void)initCustomView {
   
    SKTextField *textField = [[SKTextField alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44) leftSpace:CellLeftTitleWidth style:SKTextFieldNormalStyle];
    textField.font = FontScale_14;
    textField.textColor = Color_3;
    textField.delegate = self;
    [self.contentView addSubview:textField];
    _textField = textField;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *changeText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldChangedText:key:)]) {
        [self.delegate textFieldChangedText:changeText key:_key];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldChangedText:key:)]) {
        [self.delegate textFieldChangedText:textField.text key:_key];
    }
}
- (void)setConfigParams:(NSDictionary *)configParams {
    
    _textField.leftTitle = configParams[@"title"];
    _textField.placeholder = configParams[@"placeholder"];
    _key = configParams[@"submitKey"];
}
- (void)setFillInText:(NSString *)fillInText {
    
    _textField.text = fillInText;
}
- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (canEdit) {
        _textField.userInteractionEnabled = YES;
    } else {
        _textField.userInteractionEnabled = NO;
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
