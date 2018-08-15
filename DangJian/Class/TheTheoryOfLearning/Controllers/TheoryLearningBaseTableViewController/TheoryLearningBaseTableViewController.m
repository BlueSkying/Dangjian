//
//  TheoryLearningBaseTableViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TheoryLearningBaseTableViewController.h"
#import "PublickNewsListCell.h"
#import "BaseWebViewController.h"
#import "SKPlaceholderView.h"

@interface TheoryLearningBaseTableViewController ()

@property (nonatomic, strong) ArticleListBaseModel *articleListVo;

@property (nonatomic, assign) ArticleListRequestType requestType;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;
@end

@implementation TheoryLearningBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomView];
}
#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ArticleListBaseModel *)articleListVo {
    if (!_articleListVo) {
        _articleListVo = [ArticleListBaseModel new];
    }
    
    return _articleListVo;
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
#pragma mark - setter
- (void)setPageType:(TheoryLearningPageType)pageType {
    
    _pageType = pageType;
    switch (pageType) {
        case TheoryLearningHistoryThePartyPageType:
            
            _requestType = ArticleListRequestThePartyHistoryType;
            break;
        case TheoryLearningRulesThePartyPageType:
            _requestType = ArticleListRequestThePartyConstitutionType;

            break;
        case TheoryLearningTheTheoryPushPageType:
            _requestType = ArticleListRequestTheTheoryPushType;

            break;
        case TheoryLearningSeriesOfSpeechPageType:
            _requestType = ArticleListRequestSeriesOfSpeechType;

            break;
        default:
            break;
    }
}

- (void)initCustomView {
    
    self.view.backgroundColor = SystemGrayBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setHidden:YES];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - publick
- (void)refreshData {
    
    self.articleListVo.pageNo = 0;
    [self requestData];
}
- (void)loadMoreData {
   
    if (self.articleListVo.pageNo < self.articleListVo.totalPage) {
        
       [self requestData];
        
    } else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer setHidden:YES];
    }
}
- (void)requestData {
    
    __weak typeof(self) weakSelf = self;
    [self.articleListVo articleListType:_requestType success:^(ArticleListBaseModel *result) {
        if (result) {
            
            weakSelf.articleListVo = result;
            [weakSelf.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (weakSelf.articleListVo.listArray.count < 10) {
            [self.tableView.mj_footer setHidden:YES];
        } else {
            [self.tableView.mj_footer setHidden:NO];
        }
        
        //占位图
        if (weakSelf.articleListVo.listArray.count == 0) {
            [self.placeholderView setHidden:NO];
        } else {
            [_placeholderView setHidden:YES];
        }
        
    } failed:^(id error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.articleListVo.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ArticleListBaseModel *articleListVo;
    if (self.articleListVo.listArray.count > indexPath.row) {
        articleListVo = self.articleListVo.listArray[indexPath.row];
    }
    static NSString *ID = @"PUBLICKID";
    PublickNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.articleVo = articleListVo;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
