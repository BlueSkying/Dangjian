//
//  MeetingClassViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MeetingClassViewController.h"
#import "MeetingClassCustomButton.h"
#import "MeetingClassHomeModel.h"
#import "MeetingClassBaseViewController.h"


@interface MeetingClassViewController ()


@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) MeetingClassHomeModel *homeModel;

@end

@implementation MeetingClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (MeetingClassHomeModel *)homeModel {
    if (!_homeModel) {
        _homeModel = [MeetingClassHomeModel new];
    }
    return _homeModel;
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"三会一课";
}
- (void)initCustomView {
    
    //Button之间的间距
    CGFloat butttonSpacing = 10;
//    与屏幕的间距
    CGFloat screenSpacing = 15;
    //button的size
    CGFloat buttonWidth = (kScreen_Width - screenSpacing * 2 - butttonSpacing)/2;
    for (NSInteger indexV = 0; indexV < 2; indexV ++) {
        
        for (NSInteger indexH = 0; indexH < 2; indexH ++) {

            NSDictionary *tmpDict = self.homeModel.itemArray[indexV * 2 + indexH];
            MeetingClassCustomButton *customButton = [MeetingClassCustomButton buttonWithType:UIButtonTypeCustom];
            customButton.tag = indexV * 2 + indexH;
            [customButton setFrame:CGRectMake(screenSpacing + indexH * buttonWidth + indexH *butttonSpacing,64 + screenSpacing + indexV * buttonWidth + indexV *butttonSpacing, buttonWidth, buttonWidth)];
            [customButton setTitle:[tmpDict objectForKey:@"title"] forState:UIControlStateNormal];
            [customButton setImage:[UIImage imageNamed:[tmpDict objectForKey:@"imageName"]] forState:UIControlStateNormal];
            customButton.backgroundColor = [UIColor whiteColor];
            [customButton addTarget:self action:@selector(clickToSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:customButton];
        }
        
    }
    
}

#pragma mark - action
- (void)clickToSelectEvent:(UIButton *)sender {
    
    MeetingClassBaseViewController *meetingClassView = [[MeetingClassBaseViewController alloc] init];
    meetingClassView.pageType = sender.tag;
    [self.navigationController pushViewController:meetingClassView animated:YES];
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
