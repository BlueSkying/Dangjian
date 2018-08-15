//
//  SKAlterPickerView.m
//  DangJian
//
//  Created by Sakya on 17/5/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKAlterPickerView.h"

@interface SKAlterPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>


/**
 标记选中的row为红色
 */
@property (nonatomic, assign) NSInteger selectRow;



@end

@implementation SKAlterPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [_pickerView selectRow:0 inComponent:0 animated:YES];

}
- (void)setUpInitialValue:(NSString *)initialValue {
    
    for (NSInteger index = 0; index < _dataArray.count; index ++) {
        if ([initialValue isEqualToString:_dataArray[index]]) {
            _selectRow = index;
            break;
        }
    }
    [_pickerView selectRow:_selectRow inComponent:0 animated:YES];

    
}
#pragma mark - - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.dataArray[row];
    
  
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
 
    _selectRow = row;
    [pickerView reloadAllComponents];
    [self dateChange];

}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width ;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        if (_selectRow == row) {
            pickerLabel.textColor = Color_system_red;
        }
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark -- selectDate
- (void)dateChange {
    
    NSString *selectString = [self pickerView:_pickerView titleForRow:_selectRow forComponent:0];
    
    if(_delegate && [_delegate respondsToSelector:@selector(sk_alterPickerViewSelectText:)]) {
        [_delegate sk_alterPickerViewSelectText:selectString];
    }
}
@end
