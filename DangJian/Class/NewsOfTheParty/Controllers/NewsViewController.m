//
//  NewsViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "NewsViewController.h"
#import "SKScrollViewCell.h"
#import "NewsCustomButtonCell.h"
#import "SKTableViewHeaderFooterView.h"
#import "SubjectOptionCell.h"
#import "NewsSingleImageOptionCell.h"
#import "NewsHomeModel.h"
#import "MeetingClassViewController.h"
#import "InteractionCenterHomeModel.h"
#import "BaseWebViewController.h"
#import "MainTabBarController.h"
#import "HeartTalkListViewController.h"
#import "UserContactModel.h"

@interface NewsViewController ()<SKScrollViewCellDelegate,UITableViewDelegate,UITableViewDataSource,NewsCustomButtonCellDelegate,SubjectOptionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**
 创建首页固定数据
 */
@property (nonatomic, strong) NewsHomeModel *homeModel;

@property (nonatomic, strong) HeartTalkListViewController *talkListView;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initData];
    [self initCustomView];
    [self loadCacheData];
}
- (void)initCustomView {
    
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64 , kScreen_Width, kScreen_Height - 64 - 48) delegateAgent:self superview:self.view];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"指尖上的党建";
}
- (void)initData {
    
    [self refreshData];
 
}
#pragma mark - refresh

- (void)refreshData {
    
    __weak typeof(self) weakSelf = self;
    [NewsHomeModel homePageThePartyBuildNewsSuccess:^(NewsHomeModel *result) {
        if (result) {
            weakSelf.homeModel = result;
            [weakSelf.tableView reloadData];
        }
        [_tableView.mj_header endRefreshing];
    } failed:^(id error) {
        [_tableView.mj_header endRefreshing];
    }];
}
- (void)loadCacheData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UserContactModel contactListVersionShowPrompt:NO success:^(NSArray<UserContactModel *> *result) {
            
        } failed:^(id error) {
        }];
    });
}
#pragma mark - init
- (NewsHomeModel *)homeModel {
    if (!_homeModel) {
        _homeModel = [NewsHomeModel new];
    }
    return _homeModel;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) return 2;
    return 0;
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

    }  else {
        
        if (indexPath.row == 0) {
            static NSString *cellID = @"SUBJECTID";
            SubjectOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[SubjectOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate = self;
            cell.subjectArray = self.homeModel.subjectArray;
            return cell;
        }
        static NSString *cellID = @"SINGLEID";
        NewsSingleImageOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[NewsSingleImageOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        return cell;
    
    }
}
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row ==1) {
        
        MeetingClassViewController *meetingClassView = [[MeetingClassViewController alloc] init];
        [self.navigationController pushViewController:meetingClassView animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) return SKXFrom6(158);
        if (indexPath.row == 1) return SKXFrom6(80);
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) return (kScreen_Width - 4 *10)/3 + SKScaleFrom6(10);
        if (indexPath.row == 1) return SKXFrom6(143);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1)return SKXFrom6(45);
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SKTableViewHeaderFooterView *headerView = [SKTableViewHeaderFooterView headerViewWithTableView:tableView];
    headerView.viewType = SKTableViewHeaderFooterViewArticleGreyType;
    headerView.tag = section;
    headerView.headerTitle = @"热门专题";
    headerView.isShowMore = NO;
    return headerView;
}

#pragma mark -SKScrollViewCellDelegate 
- (void)sk_scrollViewDidSelectItemAtIndex:(NSInteger)index {
    
    DDLogInfo(@"%ld",(long)index);
    NSString *targetId;
    if (self.homeModel.targetsArray.count > index) {
        targetId = self.homeModel.targetsArray[index];
    }
    if ([targetId isEqualToString:@"#"]) return;
    BaseWebViewController *webView = [[BaseWebViewController alloc] init];
    webView.urlID = targetId;
    [self.navigationController pushViewController:webView animated:YES];
 
}
#pragma mark - NewsCustomButtonCellDelegate
- (void)clickToSelectItem:(UIButton *)sender {
    
    NSDictionary *dict = self.homeModel.itemArray[sender.tag];
    NSString *className = [dict objectForKey:@"className"];
    if ([className isEqualToString:@"TheoryLearningViewController"]) {
        ((MainTabBarController *)self.tabBarController).selectTabIndex = 2;
        return;
    }
    if ([className isEqualToString:@"OrganizationViewController"]) {
        
        ((MainTabBarController *)self.tabBarController).selectTabIndex = 3;
        return;
    }
    if ([className isEqualToString:@"HeartTalkListViewController"]) {
        return;
    }
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - SubjectOptionCellDelegate
- (void)subjectCellTapGestureDetectedIndex:(NSInteger)index {
    
    NSDictionary *dict = self.homeModel.subjectArray[index];
    NSString *className = [dict objectForKey:@"className"];
    Class class = NSClassFromString(className);
    
    //--暂时不需要交心谈心
    /**
    if ([className isEqualToString:@"HeartTalkListViewController"]) {
        if ([ChatHelper shareHelper].conversationListVC) {
            
            [self.navigationController pushViewController:[ChatHelper shareHelper].conversationListVC animated:YES];
        } else {
            _talkListView = [[HeartTalkListViewController alloc] init];
            [ChatHelper shareHelper].conversationListVC = _talkListView;
            [self.navigationController pushViewController:_talkListView animated:YES];
        }
        return;
    }
    */
    if (class) {
        UIViewController *viewController = class.new;
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
