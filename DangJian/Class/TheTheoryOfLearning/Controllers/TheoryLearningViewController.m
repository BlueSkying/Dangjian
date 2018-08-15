//
//  TheoryLearningViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TheoryLearningViewController.h"
#import "SKScrollViewCell.h"
#import "NewsCustomButtonCell.h"
#import "SKTableViewHeaderFooterView.h"
#import "TheoryLearningHomeModel.h"
#import "PublickNewsListCell.h"
#import "TheoryReviewCell.h"
#import "TheoryLearningBaseTableViewController.h"
#import "LearningOnlineViewController.h"
#import "BaseWebViewController.h"

@interface TheoryLearningViewController ()<SKScrollViewCellDelegate,UITableViewDelegate,UITableViewDataSource,NewsCustomButtonCellDelegate,SKTableViewHeaderFooterViewDelegate,TheoryReviewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 创建首页固定数据
 */
@property (nonatomic, strong) TheoryLearningHomeModel *homeModel;

@end

@implementation TheoryLearningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self requestHomeData];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"理论学习";
}
- (void)initCustomView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , kScreen_Width, kScreen_Height - 64 - 48) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestHomeData)];
    
}
- (TheoryLearningHomeModel *)homeModel{
    if (!_homeModel) {
        _homeModel = [TheoryLearningHomeModel new];
    }
    return _homeModel;
}
- (void)requestHomeData {
    
    
    __weak typeof(self) weakSelf = self;
    [TheoryLearningHomeModel homePageTheoryLearningSuccess:^(TheoryLearningHomeModel *result) {
        if (result) {
            weakSelf.homeModel = result;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 2;
    if (section == 1) return 1;
    return self.homeModel.zxxx.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            static NSString *cellID = @"BANNERID";
            SKScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[SKScrollViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.height = SKXFrom6(158);
            cell.urlArr = self.homeModel.imageArray;
            cell.delegate = self;
            return cell;
        } else {
            
            static NSString *cellID = @"BUTTONID";
            NewsCustomButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[NewsCustomButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.customArray = self.homeModel.itemArray;
            cell.delegate = self;
            return cell;
        }
        
    }  else if (indexPath.section == 1 && indexPath.row == 0) {
       
        static NSString *ID = @"REViEWID";
        TheoryReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[TheoryReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.delegate = self;
        return cell;
    }
    
    ArticleListBaseModel *articleVo;
    if (self.homeModel.zxxx.count > indexPath.row) {
        articleVo = self.homeModel.zxxx[indexPath.row];
    }
    static NSString *ID = @"NEWSID";
    PublickNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.articleVo = articleVo;
    return cell;
    
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) return SKXFrom6(158);
        if (indexPath.row == 1) return SKXFrom6(80);
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) return SKXFrom6(80);
    }
    return SKXFrom6(CellNewsListHeight);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1 || section == 2)return SKXFrom6(45);
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   SKTableViewHeaderFooterView *headerView = [SKTableViewHeaderFooterView headerViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.tag = section;
    headerView.viewType = SKTableViewHeaderFooterViewArticleGreyType;
    if (section == 1) {
        headerView.headerTitle = @"在线测评";
        headerView.isShowMore = NO;
        headerView.showLine = YES;
    } else if(section == 2){
        headerView.headerTitle = @"在线学习";
        headerView.isShowMore = YES;
    }
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return;
    }
    ArticleListBaseModel *articleVo;
    if (self.homeModel.zxxx.count > indexPath.row) {
        articleVo = self.homeModel.zxxx[indexPath.row];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = articleVo.articleID;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark -SKScrollViewCellDelegate
- (void)sk_scrollViewDidSelectItemAtIndex:(NSInteger)index {
    
    DDLogInfo(@"%ld",(long)index);
    NSString *targetId;
    if (self.homeModel.targetsArray.count > index) {
        targetId = self.homeModel.targetsArray[index];
    }
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = targetId;
    [self.navigationController pushViewController:webView animated:YES];
    
}
#pragma mark - SKTableViewHeaderFooterViewDelegate
- (void)headViewTapGestureDetected:(SKTableViewHeaderFooterView *)sender {
    //在线学习更多
    if (sender.tag == 2) {
        
        LearningOnlineViewController *viewController = [[LearningOnlineViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - TheoryReviewCellDelegate
//在线测评
- (void)theoryReviewCellItemSelectIndex:(NSInteger)index {
    
    DDLogInfo(@"%ld",(long)index);
    NSDictionary *dict = self.homeModel.reviewArray[index];
    NSString *className = [dict objectForKey:@"className"];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}
#pragma mark - NewsCustomButtonCellDelegate
- (void)clickToSelectItem:(UIButton *)sender {
    
    NSDictionary *dict = self.homeModel.itemArray[sender.tag];
    NSString *className = [dict objectForKey:@"className"];
    Class class = NSClassFromString(className);

    if ([className isEqualToString:@"ThePartyChapterRuleViewController"]) {
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    if (class) {
        TheoryLearningBaseTableViewController *viewController = class.new;
        viewController.pageType = sender.tag;
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
