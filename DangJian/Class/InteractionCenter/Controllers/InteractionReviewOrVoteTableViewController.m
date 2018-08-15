//
//  InteractionReviewOrVoteTableViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionReviewOrVoteTableViewController.h"
#import "PublickSingleTitleCell.h"
#import "DemocraticAppraisalViewController.h"
#import "OnlineVotingViewController.h"
#import "DemocraticAppraisalVo.h"
#import "SKPlaceholderView.h"

@interface InteractionReviewOrVoteTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 占位图
 */
@property (nonatomic, strong) SKPlaceholderView *placeholderView;
@end

@implementation InteractionReviewOrVoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpCustomView];
}

- (void)setUpCustomView {
    

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];

    switch (_pageType) {
        case MeDemocraticReViewPageType:
        
            [self setUpNavItemTitle:@"民主评议"];
            break;
        case MeOnlineVotePageType:
            
            [self setUpNavItemTitle:@"在线投票"];
            break;
        default:
            break;
    }
}
- (SKPlaceholderView *)placeholderView {
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.tableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_operation_icon";
        _placeholderView.titleText = @"暂无内容";
        _placeholderView.titleLabel.textColor = Color_9;
        [self.tableView addSubview:_placeholderView];
    }
    
    return _placeholderView;
}

- (void)refreshData {
    
    __weak typeof(self) weakSelf = self;
    if (_pageType == MeDemocraticReViewPageType) {
        
    
        [InterfaceManager democraticAppraisalListMissionId:_missionId success:^(id result) {
            
            if ([ThePartyHelper showPrompt:YES returnCode:result]) {
                NSArray *dataArray = [DemocraticAppraisalVo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
                weakSelf.dataArray = dataArray.mutableCopy;
                [weakSelf.tableView reloadData];
            }
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.placeholderView setHidden:YES];
            } else {
                [weakSelf.placeholderView setHidden:NO];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            
        } failed:^(id error) {
            
            [weakSelf.tableView.mj_header endRefreshing];
            
        }];
        
    } else {
        [InterfaceManager onlineVoteListMissionId:_missionId success:^(id result) {
            
            if ([ThePartyHelper showPrompt:YES returnCode:result]) {
                NSArray *dataArray = [DemocraticAppraisalVo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
                weakSelf.dataArray = dataArray.mutableCopy;
                [weakSelf.tableView reloadData];
            }
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.placeholderView setHidden:YES];
            } else {
                [weakSelf.placeholderView setHidden:NO];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            
        } failed:^(id error) {
            
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - tableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemocraticAppraisalVo *appraisalVo;
    if (self.dataArray.count > indexPath.row) {
        appraisalVo = self.dataArray[indexPath.row];
    }
    static NSString *ID = @"SINGLEID";
    PublickSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickSingleTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.title = appraisalVo.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CellSingleTextHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemocraticAppraisalVo *appraisalVo;
    if (self.dataArray.count > indexPath.row) {
        appraisalVo = self.dataArray[indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (_pageType == MeDemocraticReViewPageType) {
        
        DemocraticAppraisalViewController *appraisalView = [[DemocraticAppraisalViewController alloc] init];

        appraisalView.appraisalVo = appraisalVo;
        appraisalView.appraisalSuccessBlock = ^(){
          
            [weakSelf refreshData];
        };
        [self.navigationController pushViewController:appraisalView animated:YES];
    } else if (_pageType == MeOnlineVotePageType) {
        
        OnlineVotingViewController *onlineView = [[OnlineVotingViewController alloc] init];
        onlineView.appraisalVo = appraisalVo;
        onlineView.onlineVotingSuccessBlock = ^(){
            
            [weakSelf refreshData];
        };
        [self.navigationController pushViewController:onlineView animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
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
