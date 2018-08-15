//
//  LearningOnlineViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "LearningOnlineViewController.h"
#import "PublickNewsListCell.h"
#import "SKPlaceholderView.h"
#import "BaseWebViewController.h"

@interface LearningOnlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

/**
 *  TableView数据源
 */
@property (nonatomic , strong) ArticleListBaseModel *articleListVo;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;

@end

@implementation LearningOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"在线学习";
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    //创建刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    创建上拉加在更多控件
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setHidden:YES];
    [_tableView.mj_header beginRefreshing];
}

- (SKPlaceholderView *)placeholderView {
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.tableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noContent_icon";
        _placeholderView.titleText = @"暂无内容";
        _placeholderView.titleLabel.textColor = Color_9;
        [self.tableView addSubview:_placeholderView];
    }
    return _placeholderView;
}
- (ArticleListBaseModel *)articleListVo {
    if (!_articleListVo) {
        _articleListVo = [ArticleListBaseModel new];
    }
    return _articleListVo;
}
// -- 下拉刷新
- (void)refreshData {
    
    self.articleListVo.pageNo = 0;
    [self requestListData];
}
//和上拉加载更多
- (void)loadMoreData {
    
    if (self.articleListVo.pageNo < self.articleListVo.totalPage) {
        
        [self requestListData];
        
    } else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer setHidden:YES];
    }
}
- (void)requestListData {
    
    __weak typeof(self) weakSelf = self;
    [self.articleListVo articleListType:ArticleListRequestLearningOnlineType success:^(ArticleListBaseModel *result) {
        if (result) {
            
            weakSelf.articleListVo = result;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.articleListVo.listArray.count < 10) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        } else {
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        //占位图
        if (weakSelf.articleListVo.listArray.count == 0) {
            [weakSelf.placeholderView setHidden:NO];
        } else {
            [_placeholderView setHidden:YES];
        }
    } failed:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.articleListVo.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    static NSString *ID = @"NEWSID";
    PublickNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.articleVo = articleListVo;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = articleListVo.articleID;
    [self.navigationController pushViewController:webView animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return SKXFrom6(CellNewsListHeight);
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
