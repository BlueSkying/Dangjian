//
//  SKDatePickerView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKDatePickerView.h"
#import "AppDelegate.h"

//设置的最低年份
static NSInteger const MidYear = 1900;

@interface SKDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    //当前月份
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    //第一行选中的
    NSInteger _firstIndex;
    //第二行选中的
    NSInteger _secondIndex;
    UIPickerView *_pickerView;
    
}



@end
@implementation SKDatePickerView

#pragma mark - initDatePickerView
- (instancetype)initDatePackerWithFrame:(CGRect)frame
                               {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewInterface];
   
        
    }
   
    return self;
}

#pragma mark - ConfigurationUI
- (void)setViewInterface {
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    
    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = MidYear; i <= currentYear ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)i];
        [yearArray addObject:yearStr];
    }

    
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%02ld",(long)i];
        [monthArray addObject:monthStr];
    }
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.frame))];
    [self addSubview:contentView];

    
    //添加白色view
//    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    [contentView addSubview:whiteView];
    //添加确定和取消按钮
//    for (int i = 0; i < 2; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
//        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
//        if (i == 0) {
//            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
//        } else {
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//        [whiteView addSubview:button];
//        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 10 + i;
//    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.frame))];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    //设置pickerView默认选中当前时间
    [pickerView selectRow:[selectedYear integerValue] - MidYear inComponent:0 animated:YES];
    [pickerView selectRow:[selectecMonth integerValue] - 1 inComponent:1 animated:YES];
    [self addSubview:pickerView];
    _pickerView = pickerView;
}
//选中时显示的时间
- (void)dateYear:(NSString *)year
           month:(NSString *)month {
    
    //获取默认年份和月份的row
    for (NSInteger j=0; j<yearArray.count; j++) {
        if( [year isEqual: yearArray[j]]){
            _firstIndex=j;
            selectedYear = year;
        }
    }
    if ([year isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentYear]]) {
        [monthArray removeAllObjects];
        for (NSInteger i = 1 ; i <= currentMonth; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02ld",(long)i];
            [monthArray addObject:monthStr];
        }
    }
    for (NSInteger m=0; m<monthArray.count; m++) {
        if( [month isEqualToString: monthArray[m]]){
            _secondIndex=m;
            selectecMonth = month;
        }
    }
    [_pickerView selectRow:_firstIndex inComponent:0 animated:YES];
    [_pickerView selectRow:_secondIndex inComponent:1 animated:YES];
}
#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
            restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
        } else {
            restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
        }
        backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray.count;
    }
    else {
        return monthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (yearArray.count > row) {
            return yearArray[row];
        }
        return nil;
    } else {
        if (monthArray.count > row) {
            return monthArray[row];
        }
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedYear = yearArray[row];
        if (row == yearArray.count - 1) {//至今的情况下,月份清空
            [monthArray removeAllObjects];
            NSString *monthStr;
            for (NSInteger i = 1 ; i <= currentMonth; i++) {
                
                monthStr = [NSString stringWithFormat:@"%02ld",(long)i];
                [monthArray addObject:monthStr];
            }
            if (_secondIndex > currentMonth) {
                _secondIndex = currentMonth - 1;
            }
            selectecMonth = monthStr;
        } else {//非至今的情况下,显示月份
            monthArray = [[NSMutableArray alloc]init];
            for (NSInteger i = 1 ; i <= 12; i++) {
                NSString *monthStr = [NSString stringWithFormat:@"%02ld",(long)i];
                [monthArray addObject:monthStr];
            }
            selectecMonth = [NSString stringWithFormat:@"%02ld",(long)currentMonth];
        }
        _firstIndex = row;
        [pickerView reloadComponent:0];
        [pickerView reloadComponent:1];

    } else {
        if (monthArray.count > row) {
            selectecMonth = monthArray[row];
        }
        _secondIndex = row;
        [pickerView reloadComponent:1];
    }
    [self dateChange];
}
//宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return CGRectGetWidth(self.frame)/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor lightGrayColor];
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.tag=row;
        [pickerLabel setFont:[UIFont systemFontOfSize:24]];
        if (component==0&&_firstIndex==row) {
            
            pickerLabel.textColor=[UIColor redColor];
        }else if (component==1&&_secondIndex==row){
            
            pickerLabel.textColor=[UIColor redColor];
        }
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark -- selectDate 
- (void)dateChange {
    
    if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
        restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
    } else {
        restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(sk_datePickerViewSelectDate:)]) {
        [_delegate sk_datePickerViewSelectDate:restr];
    }
}


@end
