//
//  IntegrityBuildViewController.m
//  DangJian
//
//  Created by Sakya on 2017/8/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "IntegrityBuildViewController.h"
#import "PublickNewsListCell.h"
#import "BaseWebViewController.h"

@interface IntegrityBuildViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  TableView数据源
 */
@property (nonatomic , strong) ArticleListBaseModel *articleListVo;


@end

@implementation IntegrityBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpListTableView];
    [self setUpNavItemTitle:@"廉政建设"];
}
- (ArticleListBaseModel *)articleListVo {
    if (!_articleListVo) {
        
        _articleListVo = [ArticleListBaseModel new];
    }
    return _articleListVo;
}
#pragma mark - TableView && TableViewDelegate && DataSoure -
- (void) setUpListTableView{
    
   
    self.tableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64);
    [self.view addSubview:self.tableView];
    self.showRefreshHeader = YES;
    [self beginHeaderRefreshAnimation];

}
/**
 上拉加载
 */
- (void)tableViewDidTriggerFooterRefresh {
   
    [self loadIsHeaderRefresh:NO];
}
//下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    self.articleListVo.pageNo = 0;
    [self loadIsHeaderRefresh:YES ];
}
- (void)loadIsHeaderRefresh:(BOOL)isHeaderRefresh {
    
    __weak typeof(self) weakSelf = self;
    [self.articleListVo articleListType:ArticleListRequestIntegrityBuildType success:^(ArticleListBaseModel *result) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeaderRefresh reload:NO];
        if (result) {
            weakSelf.articleListVo = result;
            if (result.pageNo < result.totalPage) {
                weakSelf.showRefreshFooter = YES;
            } else {
                weakSelf.showRefreshFooter = NO;
            }
            if (weakSelf.articleListVo.listArray.count > 0) {
                weakSelf.showTableBlankView = NO;
            } else {
                weakSelf.showTableBlankView = YES;
            }
            [weakSelf.tableView reloadData];
        }
    } failed:^(id error) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeaderRefresh reload:NO];
    }];
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


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = articleListVo.articleID;
    [self.navigationController pushViewController:webView animated:YES];
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
