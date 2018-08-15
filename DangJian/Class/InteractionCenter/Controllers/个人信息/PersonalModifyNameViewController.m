//
//  PersonalModifyNameViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PersonalModifyNameViewController.h"
#import "SKTextField.h"
#import "InteractionCenterHomeModel.h"

@interface PersonalModifyNameViewController ()

@property (nonatomic, strong) SKTextField *textField;

@end

@implementation PersonalModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    [self setUpNavItemTitle:@"个人信息"];
    [self setNavigationRightBarButtonWithtitle:@"保存" titleColor:[UIColor whiteColor]];
}
- (void)initCustomView {
 
    SKTextField *textField = [[SKTextField alloc] initWithFrame:CGRectMake(0, 64 + 30, kScreen_Width, 45) leftSpace:70 style:SKTextFieldNormalStyle];
    textField.placeholder = @"请输入昵称";
    textField.leftTitle = @"昵称：";
    textField.tintColor = Color_system_red;
    if (_nickName) textField.text = _nickName;
    [self.view addSubview:textField];
    _textField = textField;
}


#pragma mark - action
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    /**
    NSString *changeName = _textField.text;
    NSLog(@"提交");
    if ([changeName length] == 0) {
        [SKHUDManager showBriefAlert:@"请输入昵称"];
        return;
    }
    if ([changeName length] > 10) {
        [SKHUDManager showBriefAlert:@"昵称过长，请重新输入"];
        return;
    }
    if ([changeName isEqualToString:_nickName]) {
       
        [SKHUDManager showBriefAlert:@"与旧昵称一样无需修改"];
        return;
    }
    NSDictionary *dict = @{@"nickname":changeName};
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    [InteractionCenterHomeModel userInformationModifyParams:dict success:^(UserInformationVo *result) {
        if (result) {
            [SKHUDManager showBriefAlert:@"修改成功"];
            [UserOperation shareInstance].user = result;

            weakSelf.modifyNickNameBlock ? weakSelf.modifyNickNameBlock(changeName) : nil;
            //通知i － 用户信息改变
            [MyNotification postNotificationName:NotificationUserInformationChange object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
*/
}

- (void)dealloc {
    

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
