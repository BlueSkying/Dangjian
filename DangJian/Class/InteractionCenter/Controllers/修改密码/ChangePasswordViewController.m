//
//  ChangePasswordViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SKTextField.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) NSArray <NSDictionary *>*itemArray;

@property (nonatomic, strong) UIButton *changePwdButton;

@property (nonatomic, strong) SKTextField *oldPwdTextField;

@property (nonatomic, strong) SKTextField *changePwdTextField;

@property (nonatomic, strong) SKTextField *confirmPwdTextField;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"修改密码"];
    
}
- (NSArray <NSDictionary *>*)itemArray {
    if (!_itemArray) {
        _itemArray = @[@{@"title":@"原密码",
                         @"placeholder":@"请输入原密码"},
                       @{@"title":@"新密码",
                         @"placeholder":@"请输入新密码"},
                       @{@"title":@"确认密码",
                         @"placeholder":@"请再次输入密码"},];
    }
    return _itemArray;
}
- (void)initCustomView {
    
    
    CGFloat textFieldY = 0.0;
    for (NSInteger i = 0; i < 3; i ++) {
        if (i == 0) {
            textFieldY = 64 + SKXFrom6(35);
        } else if (i == 1)  {
            
            textFieldY += 55;
        } else if (i == 2) {
     
            textFieldY += 45;
            UIView *lineBackView = [[UIView alloc] initWithFrame:CGRectMake(0, textFieldY, kScreen_Width, 0.5)];
            lineBackView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineBackView];
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.backgroundColor = SystemGraySeparatedLineColor.CGColor;
            [lineLayer setFrame:CGRectMake(15, 0, kScreen_Width - 15, 0.5)];
            [lineBackView.layer addSublayer:lineLayer];
            textFieldY += 0.5;
        }
   
        SKTextField *textFiled = [[SKTextField alloc] initWithFrame:CGRectMake(0, textFieldY, kScreen_Width, 45) leftSpace:100 style:SKTextFieldNormalStyle];
        textFiled.secureTextEntry = YES;
        textFiled.delegate = self;
        textFiled.tag = i;
        textFiled.keyboardType = UIKeyboardTypeASCIICapable;
        textFiled.tintColor = Color_system_red;
        NSDictionary *tmpDict = self.itemArray[i];
        textFiled.placeholder = tmpDict[@"placeholder"];
        textFiled.leftTitle = tmpDict[@"title"];
        [self.view addSubview:textFiled];
        if (i == 0) {
            _oldPwdTextField = textFiled;
        } else if (i == 1) {
            _changePwdTextField = textFiled;
        } else if (i == 2) {
            _confirmPwdTextField = textFiled;
        }
        
    }
    [MyNotification addObserver:self selector:@selector(textFieldChangeText:) name:UITextFieldTextDidChangeNotification object:nil];
    textFieldY += 75;
    UIButton *changeButton = [SKBuildKit buttonTitle:@"确认修改" backgroundColor:Color_c titleColor:[UIColor whiteColor] font:FontScale_17 cornerRadius:ControlsCornerRadius superview:self.view];
    [changeButton setUserInteractionEnabled:NO];
    [changeButton setFrame:CGRectMake(15, textFieldY, kScreen_Width - 30, 45)];
    [changeButton addTarget:self action:@selector(clickToCheckChangePassword) forControlEvents:UIControlEventTouchUpInside];
    _changePwdButton = changeButton;
    [self.view addSubview:changeButton];
}

#pragma mark action修改密码
//修改密码
- (void)clickToCheckChangePassword {
    
    NSString *oldPasswoard = _oldPwdTextField.text;
    if ([self checkPassword:oldPasswoard]) {
        [SKHUDManager showLoading];
        [self changeOldPassword:oldPasswoard];
    }
}
- (BOOL)checkPassword:(NSString *)password {
    
    NSString *newPassword = _changePwdTextField.text;
    NSString *confirmPassword = _confirmPwdTextField.text;
    if ([password length] == 0) {
        [SKHUDManager showBriefAlert:@"旧密码不能为空"];
        return NO;
    }
    if ([newPassword length] == 0) {
        [SKHUDManager showBriefAlert:@"新密码不能为空"];
        return NO;
    }
    if ([confirmPassword length] == 0) {
        [SKHUDManager showBriefAlert:@"确认密码不能为空"];
        return NO;
    }

    if (![newPassword isEqualToString:confirmPassword]) {
        
        [SKHUDManager showBriefAlert:@"两次密码不一致，请重新输入"];
        return NO;
    }
    
    return YES;
}
- (void)changeOldPassword:(NSString *)oldpassword {
    
    NSString *encryptionPasswoard = [Helper md5:oldpassword];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager changePasswordOldPassword:encryptionPasswoard newPassword:_changePwdTextField.text success:^(id result) {
        if ([ThePartyHelper showPrompt:NO returnCode:result]) {
            [SKHUDManager showBriefAlert:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [SKHUDManager showBriefAlert:[result objectForKey:@"msg"]];
        }
    }];
}
#pragma mark - textFiledelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _oldPwdTextField) {
        
        [_oldPwdTextField resignFirstResponder];
        [_changePwdTextField becomeFirstResponder];
    } else if (textField == _changePwdTextField) {
        [_changePwdTextField resignFirstResponder];
        [_confirmPwdTextField becomeFirstResponder];
    } else if (textField == _confirmPwdTextField) {
        [_confirmPwdTextField resignFirstResponder];
    }
    return YES;
}
#pragma mark - notification
- (void)textFieldChangeText:(NSNotificationCenter *)sender {
    
    if ([_changePwdTextField.text length] > 0 &&
        [_oldPwdTextField.text length] > 0 &&
        [_confirmPwdTextField.text length] > 0) {
        
        [_changePwdButton setUserInteractionEnabled:YES];
        [_changePwdButton setBackgroundColor:Color_system_red];
        
    } else {
        [_changePwdButton setUserInteractionEnabled:NO];
        [_changePwdButton setBackgroundColor:Color_c];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
- (void)dealloc {
    
    [MyNotification removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
