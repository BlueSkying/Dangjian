//
//  SKPopupView.m
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKPopupView.h"
#import "SKDatePickerView.h"
#import "SKAlterPickerView.h"


#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

//定义的一些控件的tag
#define PlaceholderLabelTag 1001
#define TextViewTag 1002
#define AlterTitleViewTag 1003




//定义弹框大小
static CGFloat const AlterViewHeight = 250.0;

static CGFloat const AlterViewWidth = 270.0;

static CGFloat const AlterTitleViewHeight = 50;

@protocol SKPopupNavBarViewDelegate <NSObject>

- (void)alterViewNavBarButtonClicked:(UIButton *)sender;

@end

@interface SKPopupNavBarView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic, weak) id<SKPopupNavBarViewDelegate>navBarDelegate;

@end
@implementation SKPopupNavBarView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        
        UIColor *backColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) andColors:@[Color_systemNav_red_top,Color_systemNav_red_bottom]];
        self.backgroundColor = backColor;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(frame))];
        titleLabel.center =  CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = FontScale_17;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIButton *rightButton = [SKBuildKit buttonTitle:@"确定" backgroundColor:nil titleColor:[UIColor whiteColor] font:FONT_17 cornerRadius:0 superview:self];
        rightButton.tag = 1;
        rightButton.frame = CGRectMake(CGRectGetWidth(frame) - 70, 0, 50, CGRectGetHeight(frame));
        [rightButton addTarget:self action:@selector(pickerNavBarTouchDetected:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = rightButton;
        
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = title;
}

#pragma mark - action
- (void)pickerNavBarTouchDetected:(UIButton *)sender {
    
    if (self.navBarDelegate && [self.navBarDelegate respondsToSelector:@selector(alterViewNavBarButtonClicked:)]) {
        [self.navBarDelegate alterViewNavBarButtonClicked:sender];
    }
}

@end


@interface SKPopupView ()<SKPopupNavBarViewDelegate,SKAlterPickerViewDelegate,SKDatePickerViewDelegate>

/**
 标题
 */
@property (nonatomic, copy) NSString *alterTitle;

@property (nonatomic, assign) SKPopupViewStyle promptStyle;
/**
 白色背景
 */
@property (nonatomic, strong) UIView *baseBackView;

@property (nonatomic, strong) SKPopupNavBarView *popupNavBarView;

/**
 如果是选择的有此内容
 */
@property (nonatomic, strong) NSArray *selectArray;

/**
 时间选择器
 */
@property (nonatomic, strong) SKDatePickerView *datePickerView;

/**
 自定义picker选择
 */
@property (nonatomic, strong) SKAlterPickerView *alterPickerView;

/**
 全局输出值保存
 */
@property (nonatomic, copy) NSString *output;

/**
 输入的值
 */
@property (nonatomic, copy) NSString *input;

@end

@implementation SKPopupView


//初始化主界面
-(instancetype)initWithTitle:(NSString *)title
                        type:(SKPopupViewStyle)type
             withInputString:(NSString *)input
                 selectArray:(NSArray *)selectArray {
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        _input = input;
        _alterTitle = title;
        _promptStyle = type;
        if (!selectArray) _selectArray = selectArray;
        [self initCustomViewIsAddSupperView:NO];
        [self initCloseButton];
        
    }
    return self;
}

//初始化弹窗风格信息
- (void)initAlertTitle:(NSString *)title
                  type:(SKPopupViewStyle)type
             animation:(BOOL)animation
       withInputString:(NSString *)input
           selectArray:(NSArray *)selectArray {
    
    _promptStyle = type;
    _alterTitle = title;
    _input = input;
    _selectArray = selectArray;
    [self initCustomViewIsAddSupperView:YES];
    
}
- (void)initCloseButton {
    //创建关闭按钮
    UIButton *closeButton = [SKBuildKit buttonWithImageName:@"alertView_close_button" superview:self target:self action:@selector(clickToCloseView)];
    [closeButton setFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - SKXFrom6(80)/2, CGRectGetHeight(self.frame) - 120, SKXFrom6(80), SKXFrom6(80))];
}
/**
 初始化页面
 */
- (void)initCustomViewIsAddSupperView:(BOOL)isAdd {
    
    
    
    UIView *backView = self.baseBackView;
    //移除遗留视图
    [backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    SKPopupNavBarView *titleView = self.popupNavBarView;
    titleView.title = _alterTitle;
    [backView addSubview:titleView];
    if (isAdd) [self addSubview:backView];
    
    if (_promptStyle == SKPopupViewDatePickViewType) {
        
        
        SKDatePickerView *datePickerView = [self customDatePickerView];
        NSString *currentYear;
        NSString *currentMonth;
        //拆分年月成数组
        NSArray *dateArray;
        if (_input && [_input containsString:@"-"]) {
            _output = _input;
            
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
            _output = currentDateStr;
            
        }
        dateArray = [_output componentsSeparatedByString:@"-"];
        if (dateArray.count == 2) {//年 月
            
            currentYear = [dateArray firstObject];
            currentMonth = dateArray[1];
        }
        //设置初始值
        [datePickerView dateYear:currentYear month:currentMonth];
        [backView addSubview:datePickerView];
        
    } else if (_promptStyle == SKPopupViewPickerDefaultType) {
        
        
        SKAlterPickerView *alterPickerView = [self customAlterPickerView];
        //设置可变值
        alterPickerView.dataArray = _selectArray;

        
        //设置初始值
        [alterPickerView setUpInitialValue:_input];
        _output = (_input && _input.length > 0) ? _input : [_selectArray firstObject];

        //结束编辑状态  收键盘
        [backView addSubview:alterPickerView];
    }

}

#pragma mark - init
- (UIView *)baseBackView {
    if (!_baseBackView) {
        
        UIView *baseBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SKXFrom6(AlterViewWidth), SKScaleFrom6(AlterViewHeight))];
        baseBackView.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
        baseBackView.backgroundColor = [UIColor whiteColor];
        baseBackView.layer.cornerRadius = 6;
        baseBackView.clipsToBounds = YES;
        _baseBackView = baseBackView;
    }
    return _baseBackView;
}
- (SKPopupNavBarView *)popupNavBarView {
    
    if (!_popupNavBarView) {
        
        _popupNavBarView = [[SKPopupNavBarView alloc] initWithFrame:CGRectMake(0, 0, SKXFrom6(AlterViewWidth), SKXFrom6(AlterTitleViewHeight)) title:_alterTitle];
        _popupNavBarView.navBarDelegate = self;
    }
    return _popupNavBarView;
}


- (SKAlterPickerView *)customAlterPickerView {
    
    SKAlterPickerView *alterPickerView = [[SKAlterPickerView alloc] initWithFrame:CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetHeight(self.baseBackView.frame)  - SKXFrom6(AlterTitleViewHeight))];
    alterPickerView.delegate = self;
    return alterPickerView;
}
- (SKDatePickerView *)customDatePickerView {
    
    SKDatePickerView *datePickerView = [[SKDatePickerView alloc]initDatePackerWithFrame:CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetHeight(self.baseBackView.frame)  - SKXFrom6(AlterTitleViewHeight))];
    datePickerView.delegate = self;
    return datePickerView;
}

#pragma mark -- view delegate
//时间选择器
- (void)sk_datePickerViewSelectDate:(NSString *)output {
    
    _output = output;
}

//通用选择器
- (void)sk_alterPickerViewSelectText:(NSString *)text {
    
    _output = text;
}


#pragma mark -- action
- (void)alterViewNavBarButtonClicked:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sk_alterViewPutputKey:content:indexPath:)]) {
        [_delegate sk_alterViewPutputKey:_key content:_output indexPath:_indexPath];
    }
    [self sk_close];
}
- (void)clickToCloseView {
    
    [self sk_close];
}
#pragma mark - show close methom
- (void)sk_show {
    
    
    [[[ UIApplication  sharedApplication] keyWindow] addSubview:self] ;
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        _baseBackView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)sk_close {
    
    [UIView animateWithDuration:.2 animations:^{
     
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        

        [self removeFromSuperview];
    }];
}
@end
