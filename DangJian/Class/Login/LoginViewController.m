//
//  LoginViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "SKTextField.h"
#import "LoginModel.h"
#import "SKPromptView.h"


//设置控件的宽度
#define ControlsWidth SKXFrom6(250)

@interface LoginViewController ()<UITextFieldDelegate>
/**
 帐户
 */
@property (nonatomic, strong) SKTextField *accountTextField;
/**
 密码
 */
@property (nonatomic, strong) SKTextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initCustomView];
    [self addNotification];

}

- (void)initCustomView {
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backImageView.image = [UIImage imageNamed:@"login_backImage_icon"];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SKXFrom6(72), kScreen_Width, SKXFrom6(82))];
    logoImageView.image = [UIImage imageNamed:@"login_logo_icon"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backImageView addSubview:logoImageView];
    
    UILabel *titleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"指尖上的党建" font:FontScale_17];
    [titleLabel setFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 10, kScreen_Width, 30)];
    [backImageView addSubview:titleLabel];
    
    SKTextField *accountTextFiled = [[SKTextField alloc] initWithFrame:CGRectMake((kScreen_Width - ControlsWidth)/2, CGRectGetMaxY(titleLabel.frame) + SKXFrom6(52), ControlsWidth, SKXFrom6(45)) leftSpace:60 style:SKTextFieldImageStyle];
    accountTextFiled.imageName = @"login_account_icon";
    accountTextFiled.placeholder = @"请输入帐号";
    accountTextFiled.delegate = self;
    accountTextFiled.returnKeyType = UIReturnKeyNext;
    accountTextFiled.tintColor = Color_system_red;
    [backImageView addSubview:accountTextFiled];
    _accountTextField = accountTextFiled;
    
    SKTextField *passwordTextFiled = [[SKTextField alloc] initWithFrame:CGRectMake((kScreen_Width - ControlsWidth)/2, CGRectGetMaxY(accountTextFiled.frame) + SKXFrom6(20), ControlsWidth, SKXFrom6(45)) leftSpace:60 style:SKTextFieldImageStyle];
    passwordTextFiled.imageName = @"login_password_icon";
    passwordTextFiled.placeholder = @"请输入密码";
    passwordTextFiled.delegate = self;
    passwordTextFiled.secureTextEntry = YES;
    passwordTextFiled.tintColor = Color_system_red;
    passwordTextFiled.returnKeyType = UIReturnKeyDone;
    [backImageView addSubview:passwordTextFiled];
    _passwordTextField = passwordTextFiled;
    
    UIButton *loginButton = [SKBuildKit buttonTitle:@"登录" backgroundColor:Color_c titleColor:[UIColor whiteColor] font:FontScale_16 cornerRadius:ControlsCornerRadius superview:backImageView];
    loginButton.userInteractionEnabled = NO;
    [loginButton setFrame:CGRectMake((kScreen_Width - ControlsWidth)/2, CGRectGetMaxY(passwordTextFiled.frame) + SKXFrom6(25), ControlsWidth, SKXFrom6(45))];
    [loginButton addTarget:self action:@selector(clickToCheckLogin) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 1001;
    [backImageView addSubview:loginButton];
}
- (void)addNotification {
    

    [MyNotification addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark - login
- (void)clickToCheckLogin {
    
    [self doLogin];
}

- (void)doLogin {
    
    
    NSString *account = _accountTextField.text;
    NSString *password = _passwordTextField.text;
//    加密后获取密码
    NSString *encryptionPassword = [Helper md5:password];
    
    [SKHUDManager showLoadingText:@"登录中..."];
    __weak typeof(self) weakSelf = self;
    
    //app 登录
    [LoginModel loginAccount:account password:encryptionPassword success:^(UserInformationVo *result) {
        if (result) {

            [UserOperation shareInstance].account = account;
            [UserOperation shareInstance].password = encryptionPassword;
            [UserOperation shareInstance].token_user = result .token;
            [UserOperation shareInstance].user = result;
            
            //            登录成功后环信登录
            //            环信的账号密码工号加密码加密
            [weakSelf loginWithUsername:result.account password:encryptionPassword];
        }
    }];
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
   
    
    //异步登陆账号
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationloginStateChange object:@YES];
                
            } else {
                switch (error.code)
                {
                    case EMErrorUserNotFound:
                        
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"error.usernotExist", @"User not exist!")];
                        break;
                    case EMErrorNetworkUnavailable:
                        
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"error.connectNetworkFail", @"No network connection!")];
                        break;
                    case EMErrorServerNotReachable:
                        
                        
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"error.connectServerFail", @"Connect to the server failed!")];
                        break;
                    case EMErrorUserAuthenticationFailed:
                        
                        [SKHUDManager showBriefAlert:error.errorDescription];
                        break;
                    case EMErrorServerTimeout:
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!")];
                        break;
                    case EMErrorServerServingForbidden:
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"servingIsBanned", @"Serving is banned")];
                        break;
                    default:
                        [SKHUDManager showBriefAlert:NSEaseLocalizedString(@"login.fail", @"Login failure")];
                        break;
                }
            }
        });
    });
    
}


#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str=textField.text;
    if ([textField isEqual:_accountTextField]) {
        if (range.location >= 11&&[string length]>0) {
            NSRange dele ;
            dele.location = 0;
            dele.length = 11;
            str = [str substringWithRange:dele];
            _accountTextField.text = str; //截取范围类的字符串
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _accountTextField) {
        
        [_accountTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
//        [self doLogin];
    }
    return YES;
}

#pragma mark -- NSNotification
- (void)textFieldChange:(NSNotification *)sender {
    
    if (_accountTextField.text.length >0 &&
        _passwordTextField.text.length > 0) {
        
        ((UIButton *)[self.view viewWithTag:1001]).backgroundColor = Color_system_red;
        [(UIButton *)[self.view viewWithTag:1001] setUserInteractionEnabled:YES];

    } else {
     
        ((UIButton *)[self.view viewWithTag:1001]).backgroundColor = Color_c;
        [(UIButton *)[self.view viewWithTag:1001] setUserInteractionEnabled:NO];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)dealloc {
    
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
