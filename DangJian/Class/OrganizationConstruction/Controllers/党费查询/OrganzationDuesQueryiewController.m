//
//  OrganzationDuesQueryiewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganzationDuesQueryiewController.h"
#import "SKTextField.h"
#import "DuesVo.h"
#import "DuesRecordViewController.h"

@interface OrganzationDuesQueryiewController ()<UITextFieldDelegate> {
    
    SKTextField *_workNumberTextField;// 查询工号
    UIButton *_queryButton;
}

@property (nonatomic, strong) DuesVo *duesVo;

@end

@implementation OrganzationDuesQueryiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"党费查询";
    
}
- (void)initCustomView {
    

    SKTextField *workNumberTextField = [self textFieldWithFrame:CGRectMake(0, 64 + SKXFrom6(35), kScreen_Width, 45) leftSpace:SKXFrom6(75) placeholder:@"请输入账号" leftTitle:@"账号"];
    [self.view addSubview:workNumberTextField];
    workNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _workNumberTextField = workNumberTextField;
    
    
    UIButton *queryButton = [SKBuildKit buttonTitle:@"查询" backgroundColor:Color_c titleColor:[UIColor whiteColor] font:FONT_16 cornerRadius:ControlsCornerRadius superview:self.view];
    [queryButton addTarget:self action:@selector(clickToQuery:) forControlEvents:UIControlEventTouchUpInside];
    [queryButton setFrame:CGRectMake(15, CGRectGetMaxY(workNumberTextField.frame) + 34, kScreen_Width - 30, 45)];
    queryButton.userInteractionEnabled = NO;
    _queryButton = queryButton;
    
    [MyNotification addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark - getter
- (DuesVo *)duesVo {
    if (!_duesVo) {
        _duesVo = [DuesVo new];
    }
    return _duesVo;
}
#pragma mark -- action 
//查询
- (void)clickToQuery:(UIButton *)sender {
    
    [self.view endEditing:YES];
   
    __weak typeof(self) weakSelf = self;
    [SKHUDManager showLoadingText:@"查询中..."];
    [InterfaceManager duesQueryListAccount:_workNumberTextField.text pageNo:1 mine:NO year:nil success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager hideAlert];
            [weakSelf checkInfoSuccess];
        }
    } failed:^(id error) {
    }];
}
- (void)textFieldChange:(NSNotification *)sender {
    // 数据源赋值
//    UITextField *textField = sender.object;

    if (_workNumberTextField.text.length > 0 ) {
        _queryButton.backgroundColor = Color_system_red;
        _queryButton.userInteractionEnabled = YES;
        
    } else {
        _queryButton.backgroundColor = Color_c;
        _queryButton.userInteractionEnabled = NO;
    }
}
#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str=textField.text;
    if ([textField isEqual:_workNumberTextField]) {
        if (range.location >= 11&&[string length]>0) {
            NSRange dele ;
            dele.location = 0;
            dele.length = 11;
            str = [str substringWithRange:dele];
            _workNumberTextField.text = str; //截取范围类的字符串
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _workNumberTextField) {
        
        [_workNumberTextField resignFirstResponder];
    }
    
    return YES;
}
- (SKTextField *)textFieldWithFrame:(CGRect)frame leftSpace:(CGFloat)leftSpace placeholder:(NSString *)placeholder leftTitle:(NSString *)leftTitle {
    SKTextField *textField = [[SKTextField alloc] initWithFrame:frame leftSpace:leftSpace style:SKTextFieldNormalStyle];
    textField.placeholder = placeholder;
    textField.leftTitle = leftTitle;
    textField.textColor = Color_3;
    textField.delegate = self;
    return textField;
}
- (void)checkInfoSuccess {
    
    DuesRecordViewController *duesRecordView = [[DuesRecordViewController alloc] init];
    duesRecordView.workNumber = _workNumberTextField.text;
    [self.navigationController pushViewController:duesRecordView animated:YES];
}
- (void)dealloc{
    
    [MyNotification removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [MyNotification removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
