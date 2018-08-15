//
//  ToDoListViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ToDoListViewController.h"
#import "PublickSingleTitleCell.h"
#import "ToDoListModel.h"
#import "BaseWebViewController.h"
#import "OnlineTestListViewController.h"
#import "OrganizationOnlinePaymentViewController.h"
#import "WorkFeedbackEditViewController.h"
#import "ThoughtReportsEditViewController.h"
#import "InteractionReviewOrVoteTableViewController.h"
#import "OrganzationPersonalDuesViewController.h"

@interface ToDoListViewController ()

@property (nonatomic, strong) ToDoListModel *toDoVo;

@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"待办事项"];

}
- (void)initCustomView {
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    self.showRefreshHeader = YES;

}
#pragma mark -- getter
- (ToDoListModel *)toDoVo {
    if (!_toDoVo) {
        _toDoVo = [ToDoListModel new];
    }
    return _toDoVo;
}
#pragma mark -- tableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.toDoVo.totalArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoListModel *toDoVo;
    if (self.toDoVo.totalArray.count > indexPath.row) {
        toDoVo = self.toDoVo.totalArray[indexPath.row];
    }
    static NSString *ID = @"ID";
    PublickSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickSingleTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.title = toDoVo.subject;
    cell.content = [NSString stringWithFormat:@"%@",toDoVo.doDate];
    return cell;
    
}

#pragma mark -- tableDatadelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CellSingleTextHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToDoListModel *toDoVo;
    if (self.toDoVo.totalArray.count > indexPath.row) {
        toDoVo = self.toDoVo.totalArray[indexPath.row];
    }
    //根据类型判断跳转的页面 添加ID数据
    if (toDoVo.pageType == ToDoTypeNews) {
        
        BaseWebViewController *webView = [[BaseWebViewController alloc] init];
        webView.urlID = [NSString stringWithFormat:@"%@",toDoVo.missionId];
        [self.navigationController pushViewController:webView animated:YES];
    } else if (toDoVo.pageType == ToDoTypeOnlineExam) {
        
        OnlineTestListViewController *onlineExamView = [[OnlineTestListViewController alloc] init];
        onlineExamView.missionId = toDoVo.missionId;
        [self.navigationController pushViewController:onlineExamView animated:YES];

    } else if (toDoVo.pageType == ToDoTypeOnlinePayCost) {
      
        OrganzationPersonalDuesViewController *onlinePayView = [[OrganzationPersonalDuesViewController alloc] init];
        onlinePayView.backlogId = toDoVo.toDoId;
        onlinePayView.payCostDate = toDoVo.year;
        onlinePayView.isPayCost = YES;
        [self.navigationController pushViewController:onlinePayView animated:YES];
        
    } else if (toDoVo.pageType == ToDoTypeJobFeedBack) {
      
        WorkFeedbackEditViewController *jobFeedBackView = [[WorkFeedbackEditViewController alloc] init];
        jobFeedBackView.isEdit = YES;
        jobFeedBackView.backlogId = toDoVo.toDoId;
        [self.navigationController pushViewController:jobFeedBackView animated:YES];
    } else if (toDoVo.pageType == ToDoTypeOnlineThoughtReports) {
        
        ThoughtReportsEditViewController *reportsEditView = [[ThoughtReportsEditViewController alloc] init];
        reportsEditView.isEdit = YES;
        reportsEditView.backlogId = toDoVo.toDoId;
        [self.navigationController pushViewController:reportsEditView animated:YES];
    } else if (toDoVo.pageType == ToDoTypeDemocraticAppraisal) {

        InteractionReviewOrVoteTableViewController *democraticAppraisalView = [[InteractionReviewOrVoteTableViewController alloc] init];
        democraticAppraisalView.pageType = MeDemocraticReViewPageType;
        democraticAppraisalView.missionId = toDoVo.missionId;
        [self.navigationController pushViewController:democraticAppraisalView animated:YES];
        
    } else if (toDoVo.pageType == ToDoTypeOnlineVote) {
        
        InteractionReviewOrVoteTableViewController *onlineVoteView = [[InteractionReviewOrVoteTableViewController alloc] init];
        onlineVoteView.pageType = MeOnlineVotePageType;
        onlineVoteView.missionId = toDoVo.missionId;
        [self.navigationController pushViewController:onlineVoteView animated:YES];
        
    }
}

//刷新加载
- (void)tableViewDidTriggerFooterRefresh {
    
    [self loadDataIsHeader:NO];

}
- (void)tableViewDidTriggerHeaderRefresh {
    [self loadDataIsHeader:YES];
}
- (void)loadDataIsHeader:(BOOL)isHeader {
    
    __weak typeof(self) weakSelf = self;
    
    [self.toDoVo toDoListIsHeader:isHeader success:^(ToDoListModel *result) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeader reload:NO];
        if (result) {
            
            weakSelf.toDoVo = result;
            if (result.pageNo < result.totalPage) {
                weakSelf.showRefreshFooter = YES;
            } else {
                weakSelf.showRefreshFooter = NO;
            }
            [weakSelf showTableBlankViewDependDataCount:weakSelf.toDoVo.totalArray.count];
            [weakSelf.tableView reloadData];
        }
    } failed:^(id error) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeader reload:NO];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self beginHeaderRefreshAnimation];
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
