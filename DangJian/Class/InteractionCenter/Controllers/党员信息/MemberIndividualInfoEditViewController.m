//
//  MemberIndividualInfoEditViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MemberIndividualInfoEditViewController.h"
#import "SKTextView.h"

@interface MemberIndividualInfoEditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) SKTextView *textView;
@end

@interface MemberIndividualInfoEditViewController ()

@end

@implementation MemberIndividualInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:_memberCustomVo.title];
    [self setNavigationRightBarButtonWithtitle:@"完成" titleColor:[UIColor whiteColor]];
    
}
- (void)initCustomView {
    
    
    _textView = [[SKTextView alloc] initWithFrame:CGRectMake(10,64 + 10, kScreen_Width - 20, 200) placeholder:_memberCustomVo.placeholder cornerRadius:4];

    _textView.tintColor = Color_system_red;
    _textView.text = _memberCustomVo.content;
    [self.view addSubview:_textView];
    
}
#pragma mark -- textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    
    
}
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    NSString *fillInText = self.textView.textView.text;
    if (!fillInText || [Helper deleteSpaceWithString:fillInText].length == 0) {
        [SKHUDManager showBriefAlert:@"请先填写内容再提交"];
        return;
    } else if (fillInText.length > 1000) {
        
        [SKHUDManager showBriefAlert:@"请填写1000字以内的内容"];
        return;
    }
    _memberCustomVo.content = fillInText;
    self.memberInfoEditBlock ? self.memberInfoEditBlock(_memberCustomVo) : nil;
    [self.navigationController popViewControllerAnimated:YES];
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
