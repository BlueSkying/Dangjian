//
//  PublickSingleTitleListView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PublickSingleTitleListView.h"
#import "SKPlaceholderView.h"
#import "OrganizationFeedbackDetailsViewController.h"
#import "ThoughtReportsListCell.h"
#import "ReportFeedbackModel.h"

@interface PublickSingleTitleListView ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  列表TableView
 */
@property (nonatomic , strong) UITableView *listTableView;
/**
 *  TableView数据源
 */
@property (nonatomic , strong) NSMutableArray *dataArr;

/**
 *  记录最后一次刷新的时候
 */
@property (nonatomic , assign) CFAbsoluteTime lastRefreshTime;

/**
 *  TableView数据源
 */
@property (nonatomic , strong) ReportFeedbackModel *reportFeedbackVo;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;


@end
@implementation PublickSingleTitleListView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpListTableView];
        
    }
    
    return self;
}
- (ReportFeedbackModel *)reportFeedbackVo {
    if (!_reportFeedbackVo) {
        
        _reportFeedbackVo = [ReportFeedbackModel new];
    }
    return _reportFeedbackVo;
}
- (SKPlaceholderView *)placeholderView {
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.listTableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noEditContent_icon";
        _placeholderView.titleText = @"暂无内容";
        _placeholderView.titleLabel.textColor = Color_9;
        
        [self.listTableView addSubview:_placeholderView];
    }
    
    return _placeholderView;
}

#pragma -
#pragma mark - TableView && TableViewDelegate && DataSoure -
- (void) setUpListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self.listTableView setDelegate:self];
    [self.listTableView setDataSource:self];
    // -- 去掉分割线
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // -- 设置背景颜色为透明
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    //创建刷新控件
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    创建上拉加在更多控件
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.listTableView.mj_footer setHidden:YES];
    [self addSubview:self.listTableView];
}

// -- 下拉刷新
- (void)refreshData {
    
    self.reportFeedbackVo.pageNo = 0;
    [self requestListData];
}
//和上拉加载更多
- (void)loadMoreData {
    if (self.reportFeedbackVo.pageNo < self.reportFeedbackVo.totalPage) {
        
        [self requestListData];
        
    } else{
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView.mj_footer setHidden:YES];
    }
}
- (void)requestListData {
    
    __weak typeof(self) weakSelf = self;
    //记录刷新时间
    self.lastRefreshTime = CFAbsoluteTimeGetCurrent();
    
    [self.reportFeedbackVo reportFeedbackType:_pageType mine:_mine success:^(ReportFeedbackModel *result) {
        if (result) {
            weakSelf.reportFeedbackVo = result;
            [weakSelf.listTableView reloadData];
        }
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        if (weakSelf.reportFeedbackVo.pageNo < weakSelf.reportFeedbackVo.totalPage) {
            [self.listTableView.mj_footer setHidden:NO];
        } else {
            [self.listTableView.mj_footer setHidden:YES];
        }
        //占位图
        if (weakSelf.reportFeedbackVo.listArray.count == 0) {
            [self.placeholderView setHidden:NO];
        } else {
            [_placeholderView setHidden:YES];
        }
        
    } failed:^(id error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
    }];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.reportFeedbackVo.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReportFeedbackModel *tmpVo;
    if (self.reportFeedbackVo.listArray.count > indexPath.row) {
        tmpVo = self.reportFeedbackVo.listArray[indexPath.row];
    }
    static NSString *ID = @"LISTCELLID";
    ThoughtReportsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[ThoughtReportsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.thoughtReportsVo = tmpVo;
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

// -- 是否可以自动刷新
- (void) autoRefreshCanBe{
    
    // -- 如果当前时间 - 记录的最后一个刷新的时间 大于10分钟 就可以再次刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 10 * 60) {
        // -- 刷新
        [self.listTableView.mj_header beginRefreshing];
    }
}
- (void)manualRefreshData {
    
    [self.listTableView.mj_header beginRefreshing];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportFeedbackModel *tmpVo;
    if (self.reportFeedbackVo.listArray.count > indexPath.row) {
        tmpVo = self.reportFeedbackVo.listArray[indexPath.row];
    }
    if (_pageType == ReportObjectType) {
        
        ThoughtReportsEditViewController *editView = [[ThoughtReportsEditViewController alloc] init];
        editView.isEdit = NO;
        editView.reportFeedbackVo = tmpVo;
        [[Helper superViewControllerWithView:self].navigationController pushViewController:editView animated:YES];
    } else if (_pageType == FeedbackObjectType) {
        
        OrganizationFeedbackDetailsViewController *detailsView = [[OrganizationFeedbackDetailsViewController alloc] init];
//        editView.isEdit = NO;
//        editView.reportFeedbackVo = tmpVo;
        [[Helper superViewControllerWithView:self].navigationController pushViewController:detailsView animated:YES];
    }
 
    
}

@end
