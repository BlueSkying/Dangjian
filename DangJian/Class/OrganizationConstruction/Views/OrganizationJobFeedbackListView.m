//
//  OrganizationJobFeedbackListView.m
//  DangJian
//
//  Created by Sakya on 2017/6/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackListView.h"
#import "SKPlaceholderView.h"
#import "OrganizationFeedbackDetailsViewController.h"
#import "OrganizationJobFeedbackModel.h"
#import "OrganizationJobFeedbackListCell.h"

@interface OrganizationJobFeedbackListView ()<UITableViewDelegate,UITableViewDataSource>
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
@property (nonatomic , strong) OrganizationJobFeedbackModel *jobFeedbackVo;
@property (nonatomic, strong) SKPlaceholderView *placeholderView;
@end


@implementation OrganizationJobFeedbackListView
- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpListTableView];
        
    }
    
    return self;
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
- (OrganizationJobFeedbackModel *)jobFeedbackVo {
    if (!_jobFeedbackVo) {
        _jobFeedbackVo = [OrganizationJobFeedbackModel new];
    }
    return _jobFeedbackVo;
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
    
    self.jobFeedbackVo.pageNo = 0;
    [self requestListData];
}
//和上拉加载更多
- (void)loadMoreData {
    if (self.jobFeedbackVo.pageNo < self.jobFeedbackVo.totalPage) {
        
//        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
    
    [self.jobFeedbackVo jobFeedbackMine:_mine success:^(OrganizationJobFeedbackModel *result) {
        if (result) {
            weakSelf.jobFeedbackVo = result;
            [weakSelf.listTableView reloadData];
        }
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        if (weakSelf.jobFeedbackVo.pageNo < weakSelf.jobFeedbackVo.totalPage) {
            [self.listTableView.mj_footer setHidden:NO];
        } else {
            [self.listTableView.mj_footer setHidden:YES];
        }
        //占位图
        if (weakSelf.jobFeedbackVo.listArray.count == 0) {
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
    
    return self.jobFeedbackVo.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationJobFeedbackModel *tmpVo;
    if (self.jobFeedbackVo.listArray.count > indexPath.row) {
        tmpVo = self.jobFeedbackVo.listArray[indexPath.row];
    }
    static NSString *ID = @"OrganizationJobFeedbackListCell";
    OrganizationJobFeedbackListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrganizationJobFeedbackListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.jobFeedbacListVo = tmpVo;
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
    OrganizationJobFeedbackModel *tmpVo;
    if (self.jobFeedbackVo.listArray.count > indexPath.row) {
        tmpVo = self.jobFeedbackVo.listArray[indexPath.row];
    }
    
    OrganizationFeedbackDetailsViewController *detailsView = [[OrganizationFeedbackDetailsViewController alloc] init];
    detailsView.jobFeedbackVo = tmpVo;
    [[Helper superViewControllerWithView:self].navigationController pushViewController:detailsView animated:YES];
}


@end
