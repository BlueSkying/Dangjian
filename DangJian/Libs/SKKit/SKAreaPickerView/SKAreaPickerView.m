//
//  SKAreaPickerView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKAreaPickerView.h"

@interface SKAreaPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
/** 地址数据 */
@property (nonatomic, strong) NSArray *areaArray;
/** pickView */
@property (nonatomic, strong) UIPickerView *pickView;
/** 顶部视图 */
@property (nonatomic, strong) UIView *topView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelButton;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *sureButton;
@end

static const CGFloat topViewHeight = 30;
static const CGFloat buttonWidth = 60;
static const CGFloat animationDuration = 0.3;


typedef enum : NSUInteger {
    BLComponentTypeProvince = 0, // 省
    BLComponentTypeCity,         // 市
    BLComponentTypeArea,         // 区
} BLComponentType;

@implementation SKAreaPickerView {
    NSInteger _provinceSelectedRow;
    NSInteger _citySelectedRow;
    NSInteger _areaSelectedRow;
    
    NSString *_selectedProvinceTitle;
    NSString *_selectedCityTitle;
    NSString *_selectedAreaTitle;
    
    CGRect _pickViewFrame;
}

#pragma mark - - load
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bl_initData:frame];
        [self bl_initSubviews];
    }
    return self;
}

/** 初始化子视图 */
- (void)bl_initSubviews{
    
//    [self addSubview:self.topView];
    [self addSubview:self.pickView];
//    [self.topView addSubview:self.cancelButton];
//    [self.topView addSubview:self.sureButton];
}

/** 初始化数据 */
- (void)bl_initData:(CGRect)frame{
    _pickViewFrame = frame;
    
    _provinceSelectedRow = 0;
    _citySelectedRow = 0;
    _areaSelectedRow = 0;
    
    NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"AreaArray" ofType:@"plist"];
    _areaArray = [[NSArray alloc] initWithContentsOfFile:plistStr];
}

#pragma mark - - get
- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    }
    return _pickView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), topViewHeight)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, buttonWidth, topViewHeight);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(self.frame.size.width - buttonWidth, 0, buttonWidth, topViewHeight);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

#pragma mark - - set
- (void)setPickViewBackgroundColor:(UIColor *)pickViewBackgroundColor{
    self.pickView.backgroundColor = pickViewBackgroundColor;
}

- (void)setTopViewBackgroundColor:(UIColor *)topViewBackgroundColor{
    self.topView.backgroundColor = topViewBackgroundColor;
}

- (void)setCancelButtonColor:(UIColor *)cancelButtonColor{
    [self.cancelButton setTitleColor:cancelButtonColor forState:UIControlStateNormal];
}

- (void)setSureButtonColor:(UIColor *)sureButtonColor{
    [self.sureButton setTitleColor:sureButtonColor forState:UIControlStateNormal];
}

#pragma mark - show,dismiss

- (void)sk_show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect tempRect = _topView.frame;
        tempRect.origin.y = CGRectGetWidth(self.frame) - topViewHeight - _pickViewFrame.size.height;
        _topView.frame = tempRect;
        tempRect = _pickViewFrame;
        tempRect.origin.y = CGRectGetMaxY(_topView.frame);
        _pickView.frame = tempRect;
    }];
}

- (void)bl_dismiss{
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect tempRect = _topView.frame;
        tempRect.origin.y = CGRectGetWidth(self.frame);
        _topView.frame = tempRect;
        tempRect = _pickViewFrame;
        tempRect.origin.y = CGRectGetMaxY(_topView.frame);
        _pickView.frame = tempRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

#pragma mark - - Button Action
- (void)cancelButtonClicked:(UIButton *)sender{
    
    if (self.pickViewDelegate &&
        [self.pickViewDelegate respondsToSelector:@selector(sk_cancelButtonClicked)]) {
        [self.pickViewDelegate sk_cancelButtonClicked];
    }
    [self bl_dismiss];
}

- (void)sureButtonClicked:(UIButton *)sender{
    
    _selectedProvinceTitle = [self pickerView:_pickView titleForRow:_provinceSelectedRow forComponent:0];
    _selectedCityTitle = [self pickerView:_pickView titleForRow:_citySelectedRow forComponent:1];
    _selectedAreaTitle = [self pickerView:_pickView titleForRow:_areaSelectedRow forComponent:2];
    
    if (self.pickViewDelegate &&
        [self.pickViewDelegate respondsToSelector:@selector(sk_selectedAreaResultWithProvince:city:area:)]) {
        [self.pickViewDelegate sk_selectedAreaResultWithProvince:_selectedProvinceTitle
                                                            city:_selectedCityTitle
                                                            area:_selectedAreaTitle];
    }
    [self bl_dismiss];
}

#pragma mark - - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case BLComponentTypeProvince:
            return _areaArray.count;
            break;
        case BLComponentTypeCity:
            return [[[_areaArray objectAtIndex:_provinceSelectedRow] objectForKey:@"citylist" ] count];
            break;
        case BLComponentTypeArea:
            return [[[[[_areaArray objectAtIndex:_provinceSelectedRow] objectForKey:@"citylist" ] objectAtIndex:_citySelectedRow] objectForKey:@"arealist" ] count];
            break;
        default:
            return _areaArray.count;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *provinceDic = [_areaArray objectAtIndex:_provinceSelectedRow];
    NSArray *cityArr = [provinceDic objectForKey:@"citylist"];
    
    switch (component) {
        case BLComponentTypeProvince:
            return [_areaArray[row] objectForKey:@"provinceName"];
            break;
        case BLComponentTypeCity:{
            NSDictionary *cityDic = [cityArr objectAtIndex:row];
            return [cityDic objectForKey:@"cityName"];
            break;
        }
        case BLComponentTypeArea:{
            NSDictionary *areaDic = [cityArr objectAtIndex:_citySelectedRow];
            NSArray *areaArr = [areaDic objectForKey:@"arealist"];
            return [areaArr[row] objectForKey:@"areaName"];
            break;
        }
        default:
            return [_areaArray[row] objectForKey:@"provinceName"];
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case BLComponentTypeProvince:{
            _provinceSelectedRow = row;
            _citySelectedRow = 0;
            _areaSelectedRow = 0;
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            break;
        }
        case BLComponentTypeCity:{
            _citySelectedRow = row;
            _areaSelectedRow = 0;
            [pickerView selectRow:0 inComponent:2 animated:NO];
            break;
        }
        case BLComponentTypeArea:
            _areaSelectedRow = row;
            break;
        default:
            _provinceSelectedRow = row;
            break;
    }
    [pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        if (component == 0  && _provinceSelectedRow == row) {
            pickerLabel.textColor = Color_system_red;

        }
        if (component == 1  && _citySelectedRow == row) {
            pickerLabel.textColor = Color_system_red;

        }
        if (component == 2  && _areaSelectedRow == row) {
            pickerLabel.textColor = Color_system_red;

        }
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:_titleFont ? _titleFont : [UIFont systemFontOfSize:17]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


@end
