//
//  BaseTableViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    导航条红色
    UIColor *barColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, kScreen_Width, 64) andColors:@[Color_systemNav_red_top,Color_systemNav_red_bottom]];
    self.navigationController.navigationBar.barTintColor = barColor;
    self.view.backgroundColor = SystemGrayBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UITableView new];
    
}
- (void)setUpNavItemTitle:(NSString *)title {
    
    self.navigationItem.title = title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
