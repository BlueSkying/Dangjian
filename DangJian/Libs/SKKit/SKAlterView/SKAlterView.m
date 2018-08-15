//
//  SKAlterView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKAlterView.h"
#import "SKAreaPickerView.h"
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

static CGFloat const AlterBorderSpaceX = 20;

@protocol AlterViewNavBarDelegate <NSObject>

- (void)alterViewNavBarButtonClicked:(UIButton *)sender;

@end

@interface AlterTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic, weak) id<AlterViewNavBarDelegate>navBarDelegate;

@end
@implementation AlterTitleView

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
        
        UIButton *leftButton = [SKBuildKit buttonWithImageName:@"navBar_whiteBack_icon" superview:self target:self action:@selector(titleViewTouchDetected:)];
        leftButton.tag = 0;
        leftButton.frame = CGRectMake(0, 0, 50, CGRectGetHeight(frame));
        _leftButton = leftButton;
        
        UIButton *rightButton = [SKBuildKit buttonWithImageName:@"navBar_rigthArrow_white_icon" superview:self target:self action:@selector(titleViewTouchDetected:)];
        rightButton.tag = 1;
        rightButton.frame = CGRectMake(CGRectGetWidth(frame) - 50, 0, 50, CGRectGetHeight(frame));
        _rightButton = rightButton;

    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

#pragma mark - action
- (void)titleViewTouchDetected:(UIButton *)sender {
    
    if (self.navBarDelegate && [self.navBarDelegate respondsToSelector:@selector(alterViewNavBarButtonClicked:)]) {
        [self.navBarDelegate alterViewNavBarButtonClicked:sender];
    }
}

@end

@interface SKAlterView ()<SKPickerViewDelegate,AlterViewNavBarDelegate>

@property (nonatomic, assign) SKPromptStyle promptStyle;

/**
 自带的数据
 */
@property (nonatomic, copy) NSString *input;
/**
 如果是选择的有此内容
 */
@property (nonatomic, strong) NSArray *selectArray;


/**
 是否需要动画
 */
@property (nonatomic, assign) BOOL showAnimation;
/**
 白色背景
 */
@property (nonatomic, strong) UIView *baseBackView;

//对于有动画的保存lastView
@property (nonatomic, strong) UIView *lastBackView;
/**
 当前的view
 */
@property (nonatomic, strong) UIView *currentBackView;

/**
 标题view
 */
@property (nonatomic, strong) AlterTitleView *titleBackView;

/**
 标题
 */
@property (nonatomic, copy) NSString *alterTitle;

/**
 提示语的label
 */
@property (nonatomic, strong) UILabel *placeholderLabel;

/**
 主控件
 */
@property (nonatomic, strong) UITextView *textView;




/**
 地点选择器
 */
@property (nonatomic, strong) SKAreaPickerView *areaPickerView;

/**
 时间选择器
 */
@property (nonatomic, strong) SKDatePickerView *datePickerView;

/**
 自定义picker选择
 */

@property (nonatomic, strong) SKAlterPickerView *alterPickerView;
@end

@implementation SKAlterView


//初始化主界面
-(instancetype)initWithTitle:(NSString *)title
                    type:(SKPromptStyle)type
             withInputString:(NSString *)input
                 selectArray:(NSArray *)selectArray {
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];

        
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
                  type:(SKPromptStyle)type
             animation:(BOOL)animation
       withInputString:(NSString *)input
           selectArray:(NSArray *)selectArray {
    
    self.promptNavBarType = SKPromptNavBarDefaultType;
    _promptStyle = type;
    _alterTitle = title;
    _selectArray = selectArray;
    _showAnimation = animation;
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
    

    
    UIView *backView = _currentBackView ? _currentBackView : [self customBaseBackView];
    //移除遗留视图
    [backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    AlterTitleView *titleView = [self customNavBarAlterView];
    titleView.title = _alterTitle;
    [backView addSubview:titleView];
    _titleBackView = titleView;
    
    if (backView.superview) {
        _lastBackView = backView;
    }
    if (isAdd) {
        [self addSubview:backView];
        _lastBackView = backView;
    }
    
    
    switch (_promptStyle) {
        case SKPromptTextViewType:
            
            
            [backView addSubview:[self customPlaceholderLabel]];
            [backView addSubview:[self customAlterTextView]];
            
            
            break;
        case SKPromptDatePickViewType:
            
            //结束编辑状态  收键盘
            [self endEditing:YES];
            [backView addSubview:[self customDatePickerView]];
            
            break;
        case SKPromptAddressPickViewType:
            
            
            
            break;
        case SKPromptCustomPickerDefaultType:
            
            //结束编辑状态  收键盘
            [self endEditing:YES];
            [backView addSubview:[self customAlterPickerView]];
            
            break;
        case SKPromptNumberPickerType:
            
            break;
        default:
            break;
    }
    
}

#pragma mark - init
- (UIView *)baseBackView {
    if (!_baseBackView) {
        
        _baseBackView = [self customBaseBackView];
    }
    return _baseBackView;
}
- (UIView *)customBaseBackView {
   
    UIView *baseBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SKXFrom6(AlterViewWidth), SKScaleFrom6(AlterViewHeight))];
    baseBackView.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
    baseBackView.backgroundColor = [UIColor whiteColor];
    baseBackView.layer.cornerRadius = 6;
    baseBackView.clipsToBounds = YES;
    return baseBackView;
    
}
- (UILabel *)customPlaceholderLabel {
    
    UILabel *placeholderLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_9 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"请输入内容" font:FontScale_16];
    [placeholderLabel setFrame:CGRectMake(20, SKXFrom6(AlterTitleViewHeight), 200, 40)];
    placeholderLabel.tag = PlaceholderLabelTag;
    return placeholderLabel;
}
- (AlterTitleView *)customNavBarAlterView {
    
    AlterTitleView *titleBackView = [[AlterTitleView alloc] initWithFrame:CGRectMake(0, 0, SKXFrom6(AlterViewWidth), SKXFrom6(AlterTitleViewHeight)) title:_alterTitle];
    titleBackView.navBarDelegate = self;
    return titleBackView;

}
- (UITextView *)customAlterTextView {
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setFrame:CGRectMake(AlterBorderSpaceX, SKXFrom6(50) + 40, CGRectGetWidth(self.baseBackView.frame) - AlterBorderSpaceX * 2, CGRectGetHeight(self.baseBackView.frame) - SKXFrom6(50) - 40)];
    textView.font = FontScale_17;
    textView.tintColor = Color_system_red;
    return textView;
}
- (SKDatePickerView *)customDatePickerView {
   
    SKDatePickerView *datePickerView = [[SKDatePickerView alloc]initDatePackerWithFrame:CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetHeight(self.baseBackView.frame)  - SKXFrom6(AlterTitleViewHeight))];
    [datePickerView dateYear:@"2011" month:@"2"];
    return datePickerView;
}
- (SKAlterPickerView *)customAlterPickerView {
    
    SKAlterPickerView *alterPickerView = [[SKAlterPickerView alloc] initWithFrame:CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetHeight(self.baseBackView.frame)  - SKXFrom6(AlterTitleViewHeight))];
    alterPickerView.dataArray = _selectArray;
    return alterPickerView;
}



#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    
    UILabel *placeholderLabel = [self viewWithTag:PlaceholderLabelTag];
    placeholderLabel.text = placeholder;
}
- (void)setPromptNavBarType:(SKPromptNavBarType)promptNavBarType {
    
    _promptNavBarType = promptNavBarType;
    
//    AlterTitleView *navBarView = [self viewWithTag:AlterTitleViewTag];
    switch (promptNavBarType) {
        case SKPromptNavBarDefaultType:
            
            _titleBackView.leftButton.hidden = NO;
            _titleBackView.rightButton.hidden = NO;

            break;
        case SKPromptNavBarLeftButtonType:
            _titleBackView.leftButton.hidden = NO;
            _titleBackView.rightButton.hidden = YES;
            break;
        case SKPromptNavBarRighrButtonType:
           
            _titleBackView.leftButton.hidden = YES;
            _titleBackView.rightButton.hidden = NO;
            break;
        default:
            break;
    }
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
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
//        if (self.textField) {
//            [self.textField resignFirstResponder];
//        }
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {

        [_lastBackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark - dataChange
//日期选择器时间改变
- (void)dateChange:(UIDatePicker *)pickView {
    NSDate *select = [pickView date]; // 获取被选中的时间
    
    
    NSTimeInterval nowa = [select timeIntervalSince1970];
    
    self.output = [NSString stringWithFormat:@"%.f",nowa];
    
//    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
    //    [Helper setObjectNil:self.output forKey:self.titleInfo inDic:tmpDict];
    //    [MyNotification postNotificationName:NOTIFICATION_FILLINUSERINFO object:tmpDict];
    
}

#pragma mark - - SKPickerViewDelegate
- (void)bl_selectedAreaResultWithProvince:(NSString *)provinceTitle city:(NSString *)cityTitle area:(NSString *)areaTitle{
    NSLog(@"%@,%@,%@",provinceTitle,cityTitle,areaTitle);

}

#pragma mark - action
- (void)clickToCloseView {
    
    [self sk_close];
}

#pragma mark - AlterViewNavBarDelegate
- (void)alterViewNavBarButtonClicked:(UIButton *)sender {
    
    
    
    //对应的过场动画
    if (sender.tag == 0) {
        
        _currentBackView =  [self customBaseBackView];
        [self addSubview:_currentBackView];
        
        [_currentBackView setFrame:CGRectMake(-kScreen_Width, CGRectGetMinY(_currentBackView.frame), CGRectGetWidth(_currentBackView.frame), CGRectGetHeight(_currentBackView.frame))];
        [UIView animateWithDuration:.5 animations:^{
            [_lastBackView setFrame:CGRectMake(kScreen_Width, CGRectGetMinY(_lastBackView.frame), CGRectGetWidth(_lastBackView.frame), CGRectGetHeight(_lastBackView.frame))];
            
            [_currentBackView setFrame:CGRectMake(CGRectGetMinX(_baseBackView.frame) , CGRectGetMinY(_baseBackView.frame), CGRectGetWidth(_currentBackView.frame), CGRectGetHeight(_currentBackView.frame))];
            _lastBackView = nil;
        }];
        
    } else {
        _currentBackView =  [self customBaseBackView];
        [self addSubview:_currentBackView];
        [_currentBackView setFrame:CGRectMake(kScreen_Width, CGRectGetMinY(_currentBackView.frame), CGRectGetWidth(_currentBackView.frame), CGRectGetHeight(_currentBackView.frame))];
        [UIView animateWithDuration:.5 animations:^{
            [_lastBackView setFrame:CGRectMake(-kScreen_Width, CGRectGetMinY(_lastBackView.frame), CGRectGetWidth(_lastBackView.frame), CGRectGetHeight(_lastBackView.frame))];
            [_currentBackView setFrame:CGRectMake(CGRectGetMinX(_baseBackView.frame), CGRectGetMinY(_baseBackView.frame), CGRectGetWidth(_currentBackView.frame), CGRectGetHeight(_currentBackView.frame))];
            _lastBackView = nil;
        }];
    }
    
    
    //传出数据
    if (_delegate && [_delegate respondsToSelector:@selector(sk_alterNavBarClicked:indexPath:)]) {
        [_delegate sk_alterNavBarClicked:sender indexPath:_indexPath];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sk_alterViewPutputKey:content:indexPath:)]) {
        [_delegate sk_alterViewPutputKey:nil content:_output indexPath:_indexPath];
    }
}


//datePcikView选择器
/**
 - (UIDatePicker *)datePicker {
 if (!_datePicker) {
 // 创建日期选择控件
 UIDatePicker *datePicker = [[UIDatePicker alloc] init];
 datePicker.frame = CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetWidth(self.baseBackView.frame) - SKXFrom6(AlterTitleViewHeight));
 // 设置日期模式
 datePicker.datePickerMode = UIDatePickerModeDate;
 // 设置日期地区
 // zh:中国
 datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
 // 1990-1-1
 NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
 fmt.dateFormat = @"yyyy-MM-dd";
 NSDate *  date;
 if (self.input != nil) {
 if([self.input length] == 18){
 NSRange range;
 range.location = 6;
 range.length = 8;
 NSString *dateString = [self.input substringWithRange:range];
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 formatter.dateFormat = @"yyyyMMdd";
 date = [formatter dateFromString:dateString];
 } else  {
 
 date=[NSDate dateWithTimeIntervalSince1970:[self.input doubleValue]];
 }
 }
 // 设置一开始日期
 if (date == nil) date=[NSDate date];
 datePicker.date = date;
 NSTimeInterval nowa = [date timeIntervalSince1970];
 self.output = [NSString stringWithFormat:@"%.f",nowa];
 // 监听用户输入
 [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
 _datePicker = datePicker;
 }
 return _datePicker;
 }
 */
/**
 -(SKAreaPickerView *)areaPickerView {
 if (!_areaPickerView) {
 
 _areaPickerView = [[SKAreaPickerView alloc] initWithFrame:CGRectMake(0, SKXFrom6(AlterTitleViewHeight), CGRectGetWidth(self.baseBackView.frame), CGRectGetHeight(self.baseBackView.frame) - SKXFrom6(AlterTitleViewHeight))];
 _areaPickerView.titleFont = FONT_17;
 _areaPickerView.pickViewDelegate = self;
 }
 return _areaPickerView;
 }
 */
//键盘事件
-(void)keyBoardWillShow:(NSNotification *)notification
{
    
    CGRect keyboardF = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat keyHeight = (HEIGHT(self)-Y(self.baseBackView)-HEIGHT(self.baseBackView))-keyboardF.size.height;
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        [UIView animateWithDuration:duration animations:^{
            
            self.frame =CGRectMake(0, keyHeight, WIDTH(self), HEIGHT(self));
            
        }];
    }
    
}
-(void)keyBoardDidHide:(NSNotification *)notification {
    self.frame = CGRectMake(0, 0, WIDTH(self), HEIGHT(self));
}

-(void)dealloc {
    
    [MyNotification removeObserver:self];
}
@end
