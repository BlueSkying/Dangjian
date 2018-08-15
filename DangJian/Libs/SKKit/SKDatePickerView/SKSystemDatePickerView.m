//
//  SKSystemDatePickerView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKSystemDatePickerView.h"

@interface SKSystemDatePickerView ()

@property(nonatomic, strong)UIDatePicker *pickerView;
@property(nonatomic, strong)UIView *backView;

@end

@implementation SKSystemDatePickerView
-(id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height , kScreen_Width, 0)];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *gestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelChoose)];//给view视图添加一个点击手势
        [self addGestureRecognizer:gestrue];
        [self creatPickView];
    }
    return self;
}
-(void) creatPickView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, SKXFrom6(50))];
    [topView setBackgroundColor:Color_9];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2 - SKXFrom6(50), SKXFrom6(5), SKXFrom6(100), SKXFrom6(40))];
    [label setFont:FONT_15];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setFrame:CGRectMake(kScreen_Width - 60, SKXFrom6(5), SKXFrom6(50), SKXFrom6(40))];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clickToFinishSelect) forControlEvents:UIControlEventTouchUpInside];
    [finishButton.titleLabel setFont:FONT_16];
    [topView addSubview:label];
    [topView addSubview:finishButton];
    
    
    // 创建日期选择控件
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, SKXFrom6(50), kScreen_Width, SKXFrom6(150));
    // 设置日期模式
    datePicker.datePickerMode = UIDatePickerModeTime;
    // 设置日期地区
    // zh:中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    // 1990-1-1
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // 监听用户输入
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    _pickerView = datePicker;
    [_backView addSubview:datePicker];

    [_backView addSubview:topView];
    [_backView addSubview:self.pickerView];

}
- (void)setInputDate:(NSString *)inputDate {
    
    _inputDate = inputDate;
    
    NSDate *  date;
    if (self.inputDate != nil) {
        if([self.inputDate length] == 18) {
            NSRange range;
            range.location = 6;
            range.length = 8;
            NSString *dateString = [self.inputDate substringWithRange:range];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            date = [formatter dateFromString:dateString];
        } else {
            
            date=[NSDate dateWithTimeIntervalSince1970:[self.inputDate doubleValue]];
        }
    }
    // 设置一开始日期
    if (date == nil) {
        date=[NSDate date];
    }
    _pickerView.date = date;
    NSTimeInterval nowa = [date timeIntervalSince1970];
    self.outgoingDate = [NSString stringWithFormat:@"%.f",nowa];
}
//日期选择器时间改变
-(void)dateChange:(UIDatePicker *)pickView {
    NSDate *select = [pickView date]; // 获取被选中的时
    NSTimeInterval nowa = [select timeIntervalSince1970];
    self.outgoingDate = [NSString stringWithFormat:@"%.f",nowa];
    
//    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
//    [Helper setObjectNil:self.outgoingStr forKey:self.titleInfo inDic:tmpDict];
//    [Helper setObjectNil:self.titleInfo forKey:@"title" inDic:tmpDict];
//    
//    [Mynotification postNotificationName:NOTIFICATION_FILLINUSERINFO object:tmpDict];
    
}
- (void)clickToFinishSelect {
    
    
}
- (void)cancelChoose {
    [self dissmiss];
}
- (void)show {
    
    [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : self ] ;
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        [_backView setFrame:CGRectMake(0, kScreen_Height - SKXFrom6(200), kScreen_Width, SKXFrom6(200))];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)dissmiss {
    [UIView animateWithDuration:.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
        [_backView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
