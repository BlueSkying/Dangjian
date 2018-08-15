//
//  OnlineTestHistoricalPerformanceViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestHistoricalPerformanceViewController.h"
#import "OnlineTestListCell.h"
#import "OnlineTestPaperListVo.h"
#import "OnlineTestDetailsViewController.h"


@interface OnlineTestHistoricalPerformanceViewController ()
@property (nonatomic, strong) OnlineTestPaperListVo *listVo;

@end

@implementation OnlineTestHistoricalPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"历史成绩";
    [self setDefaultNavigationLeftBarButton];
}
- (void)initCustomView {
    
    self.showRefreshHeader = YES;
    [self tableViewDidTriggerHeaderRefresh];
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
    
    
    
    static NSString *ID = @"LISTID";
    OnlineTestPaperListVo *historyScoreVo;
    if (self.listVo.totalArray.count > indexPath.row) {
        historyScoreVo = self.listVo.totalArray[indexPath.row];
    }
    OnlineTestListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[OnlineTestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.historyScoreVo = historyScoreVo;
    return cell;
    
}

#pragma marl - tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    __weak typeof(self) weakSelf = self;
    [self.listVo examHistoryScoreListIsHeaderRefresh:isHeaderRefresh success:^(OnlineTestPaperListVo *result) {
        
        [weakSelf tableViewDidFinishTriggerHeader:isHeaderRefresh reload:NO];
        if (result) {
            
            weakSelf.listVo = result;
            if (result.pageNo < result.totalPage) {
                weakSelf.showRefreshFooter = YES;
            } else {
                weakSelf.showRefreshFooter = NO;
            }
            if (weakSelf.listVo.totalArray.count > 0) {
                
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
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //删除导航栈可能存在的填写界面
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[OnlineTestDetailsViewController class]] && controller ){
            [controller willMoveToParentViewController: nil];
            [viewControllers removeObject:controller];
            [self.navigationController setViewControllers:viewControllers animated:NO];
            break;
        }
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
