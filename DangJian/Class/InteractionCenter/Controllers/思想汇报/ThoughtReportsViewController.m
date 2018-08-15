//
//  ThoughtReportsViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThoughtReportsViewController.h"
#import "SKSegmentedView.h"
#import "SKScrollView.h"
#import "PublickSingleTitleListView.h"
#import "ThoughtReportsEditViewController.h"

@interface ThoughtReportsViewController ()<PublickSingleTitleListViewDelegate>

@property (nonatomic , strong) SKSegmentedView *chanelView;

@property (nonatomic , strong) SKScrollView *tmpScrollView;
/**
 seg title
 */
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation ThoughtReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)initCustomView {
    
    //判断是否是领导
    if ([UserOperation shareInstance].user.leader) {
        
        [self initData];
        [self setUpChanelView];
        [self setUpSNScrollView];
        
    } else {
        //只初始化一个页面
        [self setUpSingleView];
    }
    
}
//初始化数据
- (void)initData {
    
    _titleArray = @[@"查阅汇报",
                    @"我的汇报"];
}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"思想汇报";
    [self setNavigationRightBarButtonWithImageNamed:@"nav_right_whiteAdd_button"];
}


#pragma mark -- 创建更多频道的View
// -- 创建分类频道的滚动视图
- (void) setUpChanelView{
    
    __weak typeof(self) weakSelf = self;
    
    // -- 分类频道的滚动视图
    self.chanelView = [[SKSegmentedView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 43)];
    // -- 循环创建分类频道按钮
    [self.chanelView loadButtonTitleArray:_titleArray];
    // -- 选中默认按钮
    [self.chanelView chanelButtonDefaultClick];
    // -- Block 回调点击的按钮在数组中的下标
    [self.chanelView setChanelButtonIdex:^(NSInteger index) {
        
        [weakSelf.tmpScrollView scrollToNewListViewWithIndex:index];
    }];
    
    [self.view addSubview:self.chanelView];
}

#pragma mark -- 创建承载列表的滚动视图 和列表
// -- 创建列表的滚动视图
- (void) setUpSNScrollView{
    
    __weak typeof(self) weakSelf = self;
    // -- 滚动视图
    self.tmpScrollView = [[SKScrollView alloc] initWithFrame:CGRectMake(0, 64 + 43, kScreen_Width, kScreen_Height - 64 - 43)];
    // -- 超出父视图范围就干掉
    [self.tmpScrollView setClipsToBounds:YES];
    // -- 滑动停止的时候拿到当前View
    [self.tmpScrollView setGetEndToView:^(UIView *tmpView) {
        SKListView *listView = (SKListView *)tmpView;
        // -- 进行刷新
        [listView autoRefreshCanBe];
    }];
    
    // -- 滑动停止的时候拿到当前View的index
    [self.tmpScrollView setGetEndscrollToIndex:^(NSInteger index) {
        [weakSelf.chanelView scrollToChanelViewWithIndex:index];
    }];
    
    // -- 循环创建ListView 并传入相应数据
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        
        PublickSingleTitleListView *newsListView = [[PublickSingleTitleListView alloc] initWithFrame:self.tmpScrollView.bounds];
        newsListView.pageType = ReportObjectType;
        newsListView.delegate = self;
        newsListView.mine = i == 0 ? NO : YES;
        
        // --
        [self.tmpScrollView loadNewsListView:newsListView ];
    }
    [self.view addSubview:self.tmpScrollView];
}
- (void)setUpSingleView {
    
    PublickSingleTitleListView *newsListView = [[PublickSingleTitleListView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
    newsListView.pageType = ReportObjectType;
    //用于区分查个人和全部
    newsListView.mine = YES;
    newsListView.delegate = self;
    [newsListView autoRefreshCanBe];
    newsListView.tag = 1001;
    // --
    [self.view addSubview:newsListView];
    
}



#pragma mark - SKListViewDelegate
//返回请求数据
- (void)listViewRequestDataSender:(SKListView *)sender Params:(NSDictionary *)params success:(requestListDataBlock)success {
    
    success(nil);
}
#pragma mark - action
//添加我的反馈
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    ThoughtReportsEditViewController *editView = [[ThoughtReportsEditViewController alloc] init];
    editView.isEdit = YES;
    editView.addReportFeedvackSuccessBlock = ^{
        //编辑完成刷新页面
        PublickSingleTitleListView *tmpView;
        if ([UserOperation shareInstance].user.leader) {
            tmpView = (PublickSingleTitleListView *)[weakSelf.tmpScrollView getCurrentNewsListView];
        } else {
            
            tmpView = (PublickSingleTitleListView *)[weakSelf.view viewWithTag:1001];
        }
        [tmpView manualRefreshData];
    };
    [self.navigationController pushViewController:editView animated:YES];
}

#pragma mark - life
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // -- 自动刷新
    PublickSingleTitleListView *tmpView = (PublickSingleTitleListView *)[self.tmpScrollView getCurrentNewsListView];
    
    [tmpView autoRefreshCanBe];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
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
