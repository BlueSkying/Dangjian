//
//  SKListView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKListView.h"
#import "PublickNewsListCell.h"
#import "BaseWebViewController.h"
#import "SKPlaceholderView.h"


@interface SKListView ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  列表TableView
 */
@property (nonatomic , strong) UITableView *listTableView;
/**
 *  TableView数据源
 */
@property (nonatomic , strong) ArticleListBaseModel *articleListVo;

/**
 *  记录最后一次刷新的时候
 */
@property (nonatomic , assign) CFAbsoluteTime lastRefreshTime;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;



@end
@implementation SKListView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        [self setUpListTableView];
    }
    
    return self;
}


- (void) setUpDataArr{
    

    
}
- (ArticleListBaseModel *)articleListVo {
    if (!_articleListVo) {
        
        _articleListVo = [ArticleListBaseModel new];
    }
    return _articleListVo;
}
- (SKPlaceholderView *)placeholderView {
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.listTableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noContent_icon";
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
    
    self.articleListVo.pageNo = 0;
    [self requestListData];
}
//和上拉加载更多
- (void)loadMoreData {
    if (self.articleListVo.pageNo < self.articleListVo.totalPage) {
        
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
    [self.articleListVo articleListType:_articleType success:^(ArticleListBaseModel *result) {
        if (result) {
            
            weakSelf.articleListVo = result;
            [weakSelf.listTableView reloadData];
        }
        [weakSelf.listTableView.mj_header endRefreshing];
        [weakSelf.listTableView.mj_footer endRefreshing];
        if (weakSelf.articleListVo.listArray.count < 10) {
            [weakSelf.listTableView.mj_footer setHidden:YES];
        } else {
            [weakSelf.listTableView.mj_footer setHidden:NO];
        }
        //占位图
        if (weakSelf.articleListVo.listArray.count == 0) {
            [weakSelf.placeholderView setHidden:NO];
        } else {
            [_placeholderView setHidden:YES];
        }
    } failed:^(id error) {
        [weakSelf.listTableView.mj_header endRefreshing];
        [weakSelf.listTableView.mj_footer endRefreshing];
    }];
    
    /**
     暂时不需要此方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewRequestDataSender:Params:success:)]) {
     
        [self.delegate listViewRequestDataSender:self Params:params success:^(NSDictionary *dict) {
            // -- 记录时间
            self.lastRefreshTime = CFAbsoluteTimeGetCurrent();
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_footer setHidden:YES];
            
        }];
    }
     */
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.articleListVo.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    static NSString *ID = @"LISTCELLID";
    PublickNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.articleVo = articleListVo;
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       return SKXFrom6(CellNewsListHeight);
}

// -- 是否可以自动刷新
- (void) autoRefreshCanBe{
    
    // -- 如果当前时间 - 记录的最后一个刷新的时间 大于10分钟 就可以再次刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 10 * 60) {
        // -- 刷新
        [self.listTableView.mj_header beginRefreshing];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = articleListVo.articleID;
    [[Helper superViewControllerWithView:self].navigationController pushViewController:webView animated:YES];
    

}


@end
