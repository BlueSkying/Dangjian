//
//  OrganizationFeedbackViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationFeedbackViewController.h"
#import "SKSegmentedView.h"
#import "SKScrollView.h"
#import "OrganizationJobFeedbackListView.h"
#import "WorkFeedbackEditViewController.h"

static BOOL SDImagedownloderOldShouldDecompressImages = YES;


@interface OrganizationFeedbackViewController ()

@property (nonatomic , strong) SKSegmentedView *chanelView;

@property (nonatomic , strong) SKScrollView *tmpScrollView;
/**
 seg title
 */
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation OrganizationFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
    
    
    [self setUpNavigationBar];
    [self initCustomView];
    
}

//初始化数据
- (void)initData {
    
    _titleArray = @[@"查阅展示",
                    @"我的展示"];
}
- (void)initCustomView {
    
    if ([[UserOperation shareInstance].user.orgLevel integerValue] == 2 &&
          [UserOperation shareInstance].user.leader  == NO) {
        [self setUpSingleView];
    } else {
        [self setNavigationRightBarButtonWithImageNamed:@"nav_right_whiteAdd_button"];
        [self initData];
        [self setUpChanelView];
        [self setUpSNScrollView];
    }

}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"工作展示";
}


#pragma mark -- 创建更多频道的View
- (void)setUpSingleView {
    
    OrganizationJobFeedbackListView *newsListView = [[OrganizationJobFeedbackListView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
    //用于区分查个人的
    newsListView.mine = NO;
    // --
    [self.view addSubview:newsListView];
    [newsListView autoRefreshCanBe];
}

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
    
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        
        OrganizationJobFeedbackListView *newsListView = [[OrganizationJobFeedbackListView alloc] initWithFrame:self.tmpScrollView.bounds];
        //用于区分查个人和全部
        newsListView.mine = i == 0 ? NO : YES;
        // --
        [self.tmpScrollView loadNewsListView:newsListView ];
    }
    
    [self.view addSubview:self.tmpScrollView];
    
}

#pragma mark - action
//添加我的反馈
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    WorkFeedbackEditViewController *editView = [[WorkFeedbackEditViewController alloc] init];
    editView.isEdit = YES;
    editView.addReportFeedvackSuccessBlock = ^{
        // -- 自动刷新
        OrganizationJobFeedbackListView *tmpView;
        tmpView = (OrganizationJobFeedbackListView *)[weakSelf.tmpScrollView getCurrentNewsListView];
        [tmpView manualRefreshData];
        
    };
    [self.navigationController pushViewController:editView animated:YES];
}

#pragma mark - life
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // -- 自动刷新
    OrganizationJobFeedbackListView *tmpView = (OrganizationJobFeedbackListView *)[self.tmpScrollView getCurrentNewsListView];
    if (tmpView) [tmpView autoRefreshCanBe];
    
}
- (void)dealloc {
  

    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    //   解决内存崩溃
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
    }];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无

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
