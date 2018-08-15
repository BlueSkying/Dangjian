//
//  OnlineTestListViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestListViewController.h"
#import "OnlineTestListCell.h"
#import "OnlineTestDetailsViewController.h"
#import "OnlineTestPaperListVo.h"


@interface OnlineTestListViewController ()

@property (nonatomic, strong) OnlineTestPaperListVo *listVo;


@end

@implementation OnlineTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = [_configParams objectForKey:@"title"] ? [_configParams objectForKey:@"title"] : @"在线考试";

}
- (void)initCustomView {
    
    self.showRefreshHeader = YES;
}

#pragma mark -- getter
- (OnlineTestPaperListVo *)listVo {
    if (!_listVo) {
        _listVo = [[OnlineTestPaperListVo alloc] init];
    }
    return _listVo;
}
#pragma mark -- setter



#pragma mark - tableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listVo.totalArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    OnlineTestPaperListVo *testVo;
    if (self.listVo.totalArray.count > indexPath.row) {
        testVo = self.listVo.totalArray[indexPath.row];
    }
    static NSString *ID = @"LISTID";
    OnlineTestListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OnlineTestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.testVo = testVo;
    return cell;
}

#pragma marl - tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OnlineTestPaperListVo *testVo;
    if (self.listVo.totalArray.count > indexPath.row) {
        testVo = self.listVo.totalArray[indexPath.row];
    }
    
//可能需要判断 试卷是否能考
//    需要与现在时间做对比
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimeIntervla = [nowDate timeIntervalSince1970];
    //获取今天0晨之前的时间
    NSTimeInterval getTimeIntervla = [Helper timeIntervalWithString:[NSString stringWithFormat:@"%@ 23:59:59",testVo.expire]];
    
    if (nowTimeIntervla > getTimeIntervla) {
        [SKHUDManager showBriefAlert:@"该试卷已过期"];
        return;
    }
    if (testVo.times < 1) {
        [SKHUDManager showBriefAlert:@"考试次数已用完"];
        return;
    }
    OnlineTestDetailsViewController *onlineTestListView = [[OnlineTestDetailsViewController alloc] init];
    onlineTestListView.testVo = testVo;
    [self.navigationController pushViewController:onlineTestListView animated:YES];
    
}
/**
 上拉加载
 */
- (void)tableViewDidTriggerFooterRefresh {
    
    [self loadIsHeaderRefresh:NO];
}
//下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    [self loadIsHeaderRefresh:YES ];
}
- (void)loadIsHeaderRefresh:(BOOL)isHeaderRefresh {
    
    NSString *examType = [_configParams objectForKey:@"className"];
    __weak typeof(self) weakSelf = self;
    [self.listVo examListIsHeaderRefresh:isHeaderRefresh type:examType missionId:_missionId success:^(OnlineTestPaperListVo *result) {
        
        [weakSelf tableViewDidFinishTriggerHeader:isHeaderRefresh reload:NO];
        if (result) {
            
            weakSelf.listVo = result;
            if (result.pageNo < result.totalPage) {
                weakSelf.showRefreshFooter = YES;
            } else {
                weakSelf.showRefreshFooter = NO;
            }
            [weakSelf showTableBlankViewDependDataCount:weakSelf.listVo.totalArray.count];
            [weakSelf.tableView reloadData];
        }
    } failed:^(id error) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeaderRefresh reload:NO];
    }];
}

//每次出现都需要刷新数据，
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self beginHeaderRefreshAnimation];
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
