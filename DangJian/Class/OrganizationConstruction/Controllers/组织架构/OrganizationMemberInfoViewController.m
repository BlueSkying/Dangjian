//
//  OrganizationMemberInfoViewController.m
//  DangJian
//
//  Created by Sakya on 2017/6/13.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationMemberInfoViewController.h"
#import "OrganizationMemberStatisticalView.h"
#import "BaseWebViewController.h"
#import "SKPlaceholderView.h"


@interface OrganizationMemberInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//headerview
@property (nonatomic, strong) OrganizationMemberStatisticalView *headerView;

@property (nonatomic, strong) OrganizationalStructureVo *memberVo;
@end

@implementation OrganizationMemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self getData];
    
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = _organizationInfoVo.name ? _organizationInfoVo.name : @"组织架构";
    if (_organizationInfoVo.name) {
        
        self.navigationItem.title = _organizationInfoVo.name.length > 7 ? [NSString stringWithFormat:@"%@...",[_organizationInfoVo.name substringToIndex:7]] : _organizationInfoVo.name;
    } else {
        self.navigationItem.title = @"组织架构";
    }
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    
    switch (_organizationInfoVo.locationHierarchy) {
        case OrganizationLocationHierarchyGroup:
            _headerView = [[OrganizationMemberStatisticalView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 170) headerType:OrganizationStatisticalNormalHeaderType];

            break;
        default:
            _headerView = [[OrganizationMemberStatisticalView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 220) headerType:OrganizationStatisticalDateHeaderType];
            break;
    }
    _tableView.tableHeaderView = _headerView;
    
    //刷新 加载
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableHeaderRefreshData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableFooterRefreshData)];
    _tableView.mj_footer.hidden = YES;
    
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    //党员统计
    [self.memberVo organizationMemberCountOrgId:_organizationInfoVo.orgId Success:^(OrganizationalMemberVo *result) {
        
        result.changeDate = weakSelf.organizationInfoVo.changeDate;
        weakSelf.headerView.memberVo = result;
    } failed:^(id error) {
        
    }];
    //成员列表
    [self loadDataIsHeader:YES];
}
- (OrganizationalStructureVo *)memberVo {
    if (!_memberVo) {
        _memberVo = [OrganizationalStructureVo new];
    }
    return _memberVo;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.memberVo.totalArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"OrganizationMemberInfoCell";
    OrganizationalMemberVo *memberVo;
    if (self.memberVo.totalArray.count > indexPath.row) {
        memberVo = self.memberVo.totalArray[indexPath.row];
    }
    OrganizationMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrganizationMemberInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.memberVo = memberVo;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SKScaleFrom6(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
 
    //    查询党员信息
    OrganizationalMemberVo *memberVo;
    if (self.memberVo.totalArray.count > indexPath.row) {
        memberVo = self.memberVo.totalArray[indexPath.row];
    }
//用户信息权限管理是否能够查看
    if (![self checkReadPermissionsAccount:memberVo.account]) {
        [SKHUDManager showBriefAlert:@"暂无查看权限"];
        return;
    }

    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = [NSString stringWithFormat:@"%@%@%@",InterfaceIPAddress,URLPARTYMENBERINFO,memberVo.userId];
    [self.navigationController pushViewController:webView animated:YES];
    
}

- (BOOL)checkReadPermissionsAccount:(NSString *)account {
    

    UserInformationVo *user = [UserOperation shareInstance].user;
    //如果是自己有最优先级
    if ([account isEqualToString:user.account])  return YES;
    //判断组织级别是否为空
    if (!user.orgLevel ||
        !_organizationInfoVo.orgLevel) {
        return NO;
    }
    
    if ([user.orgLevel integerValue] == [_organizationInfoVo.orgLevel integerValue]) {
        
        if (!user.leader) return NO;
        if (![user.orgId isEqualToString:_organizationInfoVo.orgId]) {
            return NO;
        }
    } else if ([user.orgLevel integerValue] > [_organizationInfoVo.orgLevel integerValue]) {
        return NO;
    }
    return YES;
}

- (void)tableHeaderRefreshData {
    
    [self loadDataIsHeader:YES];
}
- (void)tableFooterRefreshData {
    [self loadDataIsHeader:NO];
    
}
- (void)loadDataIsHeader:(BOOL)isHeader {
    
    __weak typeof(self) weakSelf = self;
    //    党员信息
    [self.memberVo organizationUserLisyIsHeader:isHeader orgId:_organizationInfoVo.orgId Success:^(OrganizationalStructureVo *result) {
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (result) {
            self.memberVo = result;
            [self.tableView reloadData];
        }
        if (weakSelf.memberVo.totalPage > weakSelf.memberVo.pageNo) {
            [weakSelf.tableView.mj_footer setHidden:NO];
        } else {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }

    } failed:^(id error) {
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
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
