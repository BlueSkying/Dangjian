//
//  FeedbackViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SKTextView.h"

@interface FeedbackViewController ()

@property (nonatomic, copy) NSString *feedbackText;

@property (nonatomic, strong) SKTextView *textView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"意见反馈"];
    [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];
}

- (void)initCustomView {
    
    SKTextView *textView = [[SKTextView alloc] initWithFrame:CGRectMake(10,64 + SKXFrom6(20),kScreen_Width - 20, SKXFrom6(130)) placeholder:@"请输入您的宝贵意见...(255字以内)" cornerRadius:ControlsCornerRadius];
    [self.view addSubview:textView];
    _textView = textView;
}

#pragma mark - action
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    
    NSString *feedbackText = _textView.text;
    if ([feedbackText length] == 0) {
        [SKHUDManager showBriefAlert:@"意见反馈不能为空"];
        return;
    }
    if ([feedbackText length] > 255) {
        [SKHUDManager showBriefAlert:@"请输入255字以内"];
        return;
    }
    [SKHUDManager showLoading];
    [InterfaceManager adviceFeedbackSubmitContent:feedbackText success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
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
