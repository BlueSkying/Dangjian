//
//  PublickTextViewCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PublickTextViewCell.h"

//左侧title宽度
static CGFloat const CellLeftTitleWidth = 85;

@interface PublickTextViewCell ()

@property (nonatomic, copy) NSString *key;
@end

@implementation PublickTextViewCell {
    
    UILabel * titleLabel;
    UITextView* _textView;
    UILabel * placeholderLabel;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _keyType = UIReturnKeyDone;
        [self uiConfigure];
    }
    return self;
}
- (void)uiConfigure {
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SKXFrom6(CellLeftTitleWidth), 44)];
    titleLabel.textColor = Color_6;
    titleLabel.font = FONT_16;
    [self.contentView addSubview:titleLabel];
    

    _textView=[[UITextView alloc]initWithFrame:CGRectMake(SKXFrom6(CellLeftTitleWidth) + 15, 4, kScreen_Width-SKXFrom6(CellLeftTitleWidth)  -  15 - 10, 44)];
    [self.contentView addSubview:_textView];

    _textView.tintColor = Color_system_red;
    _textView.delegate=self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.font=FontScale_14;
    _textView.scrollEnabled=NO;
    _textView.textColor = Color_3;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType=_keyType;
    _textView.keyboardType=UIKeyboardTypeDefault;
    _textView.backgroundColor=[UIColor clearColor];
    
    
    placeholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, -4, kScreen_Width-SKXFrom6(CellLeftTitleWidth)  -  15, 44)];
    placeholderLabel.text=@"请输入内容";
    placeholderLabel.textColor=Color_c;
    placeholderLabel.font=FontScale_14;
    [_textView addSubview:placeholderLabel];
    
    UIImageView *bottomLine = [[UIImageView alloc] init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.right.offset(0);
        make.height.offset(.5);
    }];
    bottomLine.backgroundColor = SystemGraySeparatedLineColor;
}
- (void)setContentStr:(NSString *)contentStr {
    _contentStr=contentStr;
    _textView.text=_contentStr;
    if (contentStr && [contentStr length] > 0) placeholderLabel.hidden=YES;
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
   
    _indexPath=indexPath;
}
- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (canEdit) {
        _textView.userInteractionEnabled = YES;
    } else {
        _textView.userInteractionEnabled = NO;
    }
}
- (void)setKeyType:(UIReturnKeyType)keyType {
    
    _keyType = keyType;
    _textView.returnKeyType = keyType;
}



- (void)setConfigParams:(NSDictionary *)configParams {
    
    titleLabel.text = [configParams objectForKey:@"title"];
    placeholderLabel.text=[configParams objectForKey:@"placeholder"];
    _key = configParams[@"submitKey"];
    
}
- (CGFloat)CellHeight {
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    return size.height+5;
}
#pragma mark - UITextViewDelegate;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (_keyType == UIReturnKeyDefault) return YES;
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length==0) {
        
        placeholderLabel.hidden=NO;
    } else {
        placeholderLabel.hidden=YES;
    }
    if ([self.delegate respondsToSelector:@selector(updatedText:atIndexPath:)]) {
        [self.delegate updatedText:textView.text atIndexPath:_indexPath];
    }
    if ([self.delegate respondsToSelector:@selector(updatedText:submitkey:)]) {
        [self.delegate updatedText:textView.text submitkey:_key];
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    //为了处理textView显示异常
    if ([textView.text length] > 0 && size.height > 36) {
        
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
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
