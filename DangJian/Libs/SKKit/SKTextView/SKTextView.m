//
//  SKTextView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKTextView.h"
#import "NSString+Util.h"

@interface SKTextView () {
    NSString *_placeholder;
}

@end

@implementation SKTextView
-(instancetype) initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder cornerRadius:(CGFloat) cornerRadius {
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _placeholder = placeholder;
        [self initUI];
        self.layer.cornerRadius = cornerRadius;
        
    }
    return self;
    
}
-(void)initUI {
    
    UITextView *textFiled = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, self.bounds.size.height - 10)];
    textFiled.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [textFiled setDelegate:self];
    [textFiled setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:textFiled];
    
    
    self.textView = textFiled;
    CGFloat labelHeiht = [_placeholder heightWithFont:[UIFont systemFontOfSize:17] constrainedToWidth:CGRectGetWidth(self.frame) - 20];
    UILabel *holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, SKXFrom6(6), CGRectGetWidth(textFiled.frame) - 5, labelHeiht)];
    [holderLabel setNumberOfLines:0];
    [holderLabel setText:_placeholder];
    [holderLabel setFont:[UIFont systemFontOfSize:17]];
    [holderLabel setTextColor:HexRGB(0xcccccc)];
    self.placeHolder = holderLabel;
    [self.textView addSubview:holderLabel];
    
}

#pragma mark -- setter
-(void)setSingleRows:(BOOL)singleRows
{
    _singleRows = singleRows;
    if (singleRows) {
        [self.placeHolder setCenter:CGPointMake(CGRectGetWidth(self.textView.frame)/2, CGRectGetHeight(self.textView.frame)/2)];
    }
}
- (void)setFont:(UIFont *)font {
   
    self.textView.font = font;
}

- (void)setText:(NSString *)text {
    
    self.textView.text = text;
    if (text.length > 0) {
        self.placeHolder.text = @"";
    }
    
}

//监听textView改变
#pragma mark <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        self.placeHolder.text = _placeholder;
    } else {
        
        self.placeHolder.text = @"";
    }
    _text = self.textView.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewChangeText:)]) {
        [self.delegate textViewChangeText:textView.text];
    }
}

-(void)layoutSubviews{
    
}

@end
