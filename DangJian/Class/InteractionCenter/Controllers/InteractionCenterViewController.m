//
//  InteractionCenterViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "InteractionCenterViewController.h"
#import "InteractionCenterHeaderView.h"
#import "InteractionCenterHomeVo.h"
#import "NewsCustomButtonCell.h"
#import "InteractionCenterSingleCell.h"
#import "PersonalInformationViewController.h"
#import "InteractionCenterHomeModel.h"
#import "InteractionReviewOrVoteTableViewController.h"
#import "HeartTalkListViewController.h"

@interface InteractionCenterViewController ()<UIApplicationDelegate,UITableViewDelegate,UITableViewDataSource,NewsCustomButtonCellDelegate,InteractionCenterHeaderViewDelegate>


@property (nonatomic, strong) UITableView *tableView;

//首页数据
@property (nonatomic, strong) InteractionCenterHomeVo *homeVo;

@property (nonatomic, strong) InteractionCenterHeaderView *headerView;

@property (nonatomic, strong) HeartTalkListViewController *talkListView;


@end

@implementation InteractionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self initData];
    
}

- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 0 , kScreen_Width, kScreen_Height - 48) delegateAgent:self superview:self.view];
    InteractionCenterHeaderView *headerView = [[InteractionCenterHeaderView alloc] init];
    [headerView setFrame:CGRectMake(0, 0, kScreen_Width, SKXFrom6(150))];
    headerView.user = [UserOperation shareInstance].user;
    headerView.delegate = self;
    headerView.tag = 101;
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    self.navigationController.cloudox = @"hey，this is category!";
}

- (void)initData {
    
    [MyNotification addObserver:self selector:@selector(userInformationChange) name:NotificationUserInformationChange object:nil];
}
#pragma mark - 
- (void)userInformationChange {
    
    self.headerView.user = [UserOperation shareInstance].user;
}

#pragma mark - lazyLoad
- (InteractionCenterHomeVo *)homeVo {
    if (!_homeVo) {
        _homeVo = [InteractionCenterHomeVo new];
    }
    return _homeVo;
}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"互动中心";
}
#pragma mark - tabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return self.homeVo.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    return ((NSArray *)self.homeVo.itemArray[section]).count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *ID = @"CUSTOMID";
        NewsCustomButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[NewsCustomButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.delegate = self;
        cell.customArray = self.homeVo.itemArray[indexPath.section];
        return cell;
        
    } else {
        
        static NSString *ID = @"SINGLEID";
        InteractionCenterSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[InteractionCenterSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.configParams = self.homeVo.itemArray[indexPath.section][indexPath.row];
        return cell;
        
    }

}
#pragma mark - tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return 0;
    return SKXFrom6(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return SKXFrom6(85);
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = SystemGrayBackgroundColor;
        headerView;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    NSDictionary *configParams = self.homeVo.itemArray[indexPath.section][indexPath.row];
    NSString *className = [configParams objectForKey:@"className"];
    //退出登录判断
    if ([className isEqualToString:UserLogOutSign]) {
        [self logout];
        return;
    }
    Class class = NSClassFromString(className);
    if (class) {
  
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark -NewsCustomButtonCellDelegate 
- (void)clickToSelectItem:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    NSDictionary *configParams = self.homeVo.itemArray[0][index];
    NSString *className = [configParams objectForKey:@"className"];
    
    
    if ([className isEqualToString:@"InteractionReviewOrVoteTableViewController"]) {
        InteractionReviewOrVoteTableViewController *reviewView = [[InteractionReviewOrVoteTableViewController alloc] init];
        if (index == 2) {
            
            reviewView.pageType = MeDemocraticReViewPageType;
        } else if (index == 3) {
            
            reviewView.pageType = MeOnlineVotePageType;
        }
        [self.navigationController pushViewController:reviewView animated:YES];
        return;
    }
    //交心谈心
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
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *viewController = class.new;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - InteractionCenterHeaderViewDelegate
- (void)headerViewActionDetected:(InteractionCenterHeaderView *)sender {
    
    PersonalInformationViewController *personalInformationView = [[PersonalInformationViewController alloc] init];   
    [self.navigationController pushViewController:personalInformationView animated:YES];
}

#pragma mark - logout 
- (void)logout {
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __weak typeof(self) weakSelf = self;
        [self showHudInView:self.view hint:@"退出登录中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] logout:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil) {
                    [weakSelf hideHud];
                    [weakSelf showHint:error.errorDescription];
                }
                else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationloginStateChange object:@NO];
                }
            });
        });
    }];
    [alterController addAction:cancelAction];
    [alterController addAction:comfirmAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alterController animated: YES completion: nil];
    });
}
- (void)dealloc {
    
    [MyNotification removeObserver:self name:NotificationUserInformationChange object:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat imageHight = SKXFrom6(150);
    CGFloat width = self.view.frame.size.width; // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y; // 偏移的y值，还要考虑导航栏的64哦
    if (yOffset < 0) {//向下拉是负值，向上是正
        CGFloat totalOffset = imageHight + ABS(yOffset);
        CGFloat f = totalOffset / imageHight;//缩放比例
        //拉伸后的图片的frame应该是同比例缩放。
        _headerView.backViewRect =  CGRectMake(0, yOffset, width * f, totalOffset);
        self.navBarBgAlpha = @"0.0";
    } else if (yOffset < 40) {
        CGFloat proportion = yOffset/40;
        self.navBarBgAlpha = [NSString stringWithFormat:@"%.1f",proportion];
    } else {
        self.navBarBgAlpha = @"1.0";
    }
}

#pragma mark - life
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
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
