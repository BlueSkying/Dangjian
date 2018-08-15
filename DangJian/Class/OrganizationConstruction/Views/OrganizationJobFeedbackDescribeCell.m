//
//  OrganizationJobFeedbackDescribeCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackDescribeCell.h"

//标题高度
static CGFloat const CellTopTitleHeight = 30;
static CGFloat const TextViewDefaultHeight = 50;


@implementation OrganizationJobFeedbackDescribeCell{
    
    UILabel * titleLabel;
    UITextView* _textView;
    UILabel * placeholderLabel;
    NSString *_key;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 30, CellTopTitleHeight)];
    titleLabel.textColor = Color_6;
    titleLabel.font = FONT_16;
    [self.contentView addSubview:titleLabel];
    
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake( 15, CGRectGetMaxY(titleLabel.frame), kScreen_Width - 30, TextViewDefaultHeight)];
    [self.contentView addSubview:_textView];
    _textView.tintColor = Color_system_red;
    _textView.delegate=self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.font=FontScale_14;
    _textView.scrollEnabled=NO;
    _textView.textColor = Color_3;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.keyboardType=UIKeyboardTypeDefault;
    _textView.backgroundColor=[UIColor clearColor];
    
    
    placeholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(_textView.frame) - 5, TextViewDefaultHeight)];
    placeholderLabel.text=@"请输入内容";
    placeholderLabel.numberOfLines = 2;
    placeholderLabel.textColor=Color_c;
    placeholderLabel.font=FontScale_14;
    [_textView addSubview:placeholderLabel];
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
/**
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
*/

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length==0) {
        
        placeholderLabel.hidden=NO;
    } else {
        placeholderLabel.hidden=YES;
    }
    if ([self.delegate respondsToSelector:@selector(feedbackDescribeUpdatedText:atIndexPath:)]) {
        [self.delegate feedbackDescribeUpdatedText:textView.text atIndexPath:_indexPath];
    }
    if ([self.delegate respondsToSelector:@selector(feedbackDescribeUpdatedText:submitkey:)]) {
        [self.delegate feedbackDescribeUpdatedText:textView.text submitkey:_key];
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    //为了处理textView显示异常
    if ([textView.text length] > 0 &&
        size.height > TextViewDefaultHeight) {
        
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height + 5);
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
