//
//  OrganizationJobSpecificationViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobSpecificationViewController.h"
#import "PublickSingleTitleCell.h"
#import "BaseWebViewController.h"
#import "ArticleListBaseModel.h"
#import "SKPlaceholderView.h"

@interface OrganizationJobSpecificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong) ArticleListBaseModel *specificationVo;
@property (nonatomic, strong) SKPlaceholderView *placeholderView;
@end

@implementation OrganizationJobSpecificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];

}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"工作规范";
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    //创建刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    创建上拉加在更多控件
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    [_tableView.mj_footer setHidden:YES];
    [_tableView.mj_header beginRefreshing];
}
- (ArticleListBaseModel *)specificationVo {
    if (!_specificationVo) {
        _specificationVo = [ArticleListBaseModel new];
    }
    return _specificationVo;
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
// -- 下拉刷新
- (void)refreshData {
    
    self.specificationVo.pageNo = 0;
    [self requestListData];
}
//和上拉加载更多
- (void)loadMoreData {
 
    if (self.specificationVo.pageNo < self.specificationVo.totalPage) {
        
        [self requestListData];
        
    } else{
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer setHidden:YES];
    }
}
- (void)requestListData {
    
    __weak typeof(self) weakSelf = self;

    [self.specificationVo articleListType:ArticleListRequestJobSpecificationType success:^(ArticleListBaseModel *result) {
        if (result) {
            
            weakSelf.specificationVo = result;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.specificationVo.totalPage > weakSelf.specificationVo.pageNo) {
            [weakSelf.tableView.mj_footer setHidden:NO];
        } else {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        //占位图
        if (weakSelf.specificationVo.listArray.count == 0) {
            [weakSelf.placeholderView setHidden:NO];
        } else {
            [_placeholderView setHidden:YES];
        }
    } failed:^(id error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.specificationVo.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ArticleListBaseModel *articleListVo;
    if (self.specificationVo.listArray.count > indexPath.row) {
        articleListVo = self.specificationVo.listArray[indexPath.row];
    }
    static NSString *ID = @"SingleTitleID";
    PublickSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickSingleTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.title = articleListVo.title;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleListBaseModel *articleListVo;
    if (self.specificationVo.listArray.count > indexPath.row) {
        articleListVo = self.specificationVo.listArray[indexPath.row];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = articleListVo.articleID;
    [self.navigationController pushViewController:webView animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
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
