//
//  SKTextView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKTextViewDelegate <NSObject>


-(void)textViewChangeText:(NSString *)text;

@end

@interface SKTextView : UIView<UITextViewDelegate>

-(instancetype) initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder cornerRadius:(CGFloat) cornerRadius;

/**显示的提示语行数 默认为多行*/
@property(nonatomic, assign)BOOL singleRows;

@property(nonatomic, strong)UITextView *textView;

@property(nonatomic, strong)UIFont *font;

@property(nonatomic, copy) NSString *text;

@property(nonatomic ,strong)UILabel *placeHolder;

@property(nonatomic, assign)id<SKTextViewDelegate>delegate;
@end
