//
//  OrganizationViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationConstructionHomeModel.h"
#import "NewsCustomButtonCell.h"
#import "SKTableViewHeaderFooterView.h"
#import "OrganzationPersonalDuesViewController.h"

@interface OrganizationViewController ()<NewsCustomButtonCellDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) OrganizationConstructionHomeModel *homeModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];

}
- (void)initCustomView {
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , kScreen_Width, kScreen_Height - 64 - 48) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
}
- (void)setUpNavigationBar { }
- (OrganizationConstructionHomeModel *)homeModel {
    if (!_homeModel) {
        _homeModel = [OrganizationConstructionHomeModel new];
    }
    return _homeModel;
}
#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) return 1;
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"BUTTONID";
    NewsCustomButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[NewsCustomButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.customArray = self.homeModel.itemArray[indexPath.section];
    cell.section = indexPath.section;
    cell.delegate = self;
    return cell;
    
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return SKXFrom6(80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    if (section == 1)  return SKXFrom6(10);
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    /**
    SKTableViewHeaderFooterView *headerView = [SKTableViewHeaderFooterView headerViewWithTableView:tableView];
    headerView.tag = section;
    if (section == 0) {
        headerView.headerTitle = @"党务工作";
    } else if (section == 1) {
        headerView.viewType = SKTableViewHeaderFooterViewArticleGreyType;
        headerView.headerTitle = @"组织管理";
    }
    */
    
    return ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = SystemGrayBackgroundColor;
        headerView;
    });
}

#pragma mark -NewsCustomButtonCellDelegate 
- (void)customButtonToSelectIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *configParams = self.homeModel.itemArray[indexPath.section][indexPath.row];
    NSString *className = [configParams objectForKey:@"className"];
    if ([className isEqualToString:@"OrganzationPersonalDuesViewController"]) {
        OrganzationPersonalDuesViewController *queryView = [[OrganzationPersonalDuesViewController alloc] init];
        queryView.isPayCost = YES;
        [self.navigationController pushViewController:queryView animated:YES];
        return;
    } else if ([className isEqualToString:@"OrganzationDuesQueryiewController"]) {
        
        DuesRecordViewController *duesRecordView = [[DuesRecordViewController alloc] init];
        duesRecordView.isPayCost = NO;
        duesRecordView.workNumber = [UserOperation shareInstance].user.account;
        [self.navigationController pushViewController:duesRecordView animated:YES];
        return;
    }
    Class class = NSClassFromString(className);
    if (class) {
        
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
