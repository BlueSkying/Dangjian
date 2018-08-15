//
//  OrganizationCalendarViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationCalendarViewController.h"
#import "MYCalendarView.h"
#import "CalendarDetailViewController.h"
@interface OrganizationCalendarViewController ()

@property (strong, nonatomic) MYCalendarView *calendar;
@end

@implementation OrganizationCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"党务日历";
}

- (void)initCustomView {
    
    MYCalendarView *calendar = [[MYCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    self.calendar = calendar;
    
    [self.view addSubview:self.calendar];
    
    [calendar getData];
    calendar.pushBlock = ^(dayWorkModel *model) {
        
        CalendarDetailViewController *detailVC = [[CalendarDetailViewController alloc] init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
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
