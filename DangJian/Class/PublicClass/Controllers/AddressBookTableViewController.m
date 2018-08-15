//
//  AddressBookTableViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AddressBookTableViewController.h"
#import "AddressSectionHeaderView.h"
#import "AddressBookContactInfoCell.h"
#import "UserContactModel.h"
#import "ChatViewController.h"
#import "UserFmdbManager.h"

#define headViewHight 110
#define GVsetionHeader_height 50

@interface AddressBookTableViewController ()<AddressSectionHeaderViewDelegate>

//保存是否打开的数组
@property (nonatomic, strong) NSMutableArray *openDataArray;
//保存打开section的标签
@property (nonatomic, copy) NSString *openStr;

@property (nonatomic, strong) NSArray <UserContactModel *>*contactArray;

@end

@implementation AddressBookTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustionView];
    [self initData];
}
- (void)setUpNavigationBar {
    [self setUpNavItemTitle:@"通讯录"];
    
    
}
- (void)initCustionView {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListData)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    
}
- (void)initData {
    
    __weak typeof(self) weakSelf = self;
    [UserContactModel contactListVersionShowPrompt:YES success:^(NSArray<UserContactModel *> *result) {
        if (result.count > 0) {
            
            weakSelf.contactArray = result;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    
}
- (NSArray <UserContactModel *>*)contactArray {
    if (!_contactArray) {
        
        _contactArray = [UserFmdbManager searchAddressBookUserAccount:[UserOperation shareInstance].account].list;
    }
    return _contactArray;
}
#pragma mark --lazy load
- (NSMutableArray *)openDataArray {
    
    if (_openDataArray == nil) {
        
        _openDataArray = @[].mutableCopy;
    }
    return _openDataArray;
}

- (void)reloadListData {
    [self initData];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    AddressSectionHeaderView *headerView;
    if ([self.openDataArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        
        headerView = [AddressSectionHeaderView headerViewWithTableView:tableView];
        headerView.sectionState = YUFoldingSectionStateShow;
        
    } else {
        
        headerView = [AddressSectionHeaderView headerViewWithTableView:tableView];
        headerView.sectionState = YUFoldingSectionStateFlod;
        
    }
    UserContactModel *user ;
    if (self.contactArray.count > section) {
        user = self.contactArray[section];
    }
    headerView.groupCount = user.user.count > 0 ? [NSString stringWithFormat:@"%ld",(long)user.user.count] : @"0";
    headerView.titleName = user.name;
    headerView.delegate = self;
    headerView.section = section;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return GVsetionHeader_height;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // 增加一个空格的距离
    return self.contactArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.openDataArray containsObject:[NSString stringWithFormat:@"%zd",section]]) {
        return ((UserContactModel *)self.contactArray[section]).user.count;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserContactModel *user ;
    if (((UserContactModel *)self.contactArray[indexPath.section]).user.count > indexPath.row) {
        user = ((UserContactModel *)self.contactArray[indexPath.section]).user[indexPath.row];
    }
    static NSString *ID = @"CellID";
    AddressBookContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[AddressBookContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.user = user;
    return cell;
    
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserContactModel *user ;
    if (((UserContactModel *)self.contactArray[indexPath.section]).user.count > indexPath.row) {
        user = ((UserContactModel *)self.contactArray[indexPath.section]).user[indexPath.row];
    }
    if ([user.account isEqualToString:[UserOperation shareInstance].account]) {
        [SKHUDManager showBriefAlert:@"不能同自己聊天"];
        return;
    }
    UIViewController *chatController = nil;
    chatController = [[ChatViewController alloc] initWithConversationChatter:user.account conversationType:EMConversationTypeChat];
    chatController.title = user.nickname ? user.nickname : user.account;
    [self.navigationController pushViewController:chatController animated:YES];
    
}
#pragma mark --sectiondelegate
-(void)sectionViewSelectViewSection:(NSInteger)section{
    
    _openStr = [NSString stringWithFormat:@"%ld", (long)section];
    
    if ([self.openDataArray containsObject:_openStr]) {
        
        [self.openDataArray removeObject:_openStr];
    } else {
        
        [self.openDataArray addObject:_openStr];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
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
