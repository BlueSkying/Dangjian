//
//  ThePartyNewsViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThePartyNewsViewController.h"
#import "SKSegmentedView.h"
#import "SKScrollView.h"
#import "SKListView.h"

@interface ThePartyNewsViewController ()<SKListViewDelegate>

@property (nonatomic , strong) SKSegmentedView *chanelView;
@property (nonatomic , strong) SKScrollView *tmpScrollView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray <NSDictionary *>*itemArray;
@end

@implementation ThePartyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];    
    _titleArray = @[@"中央新闻",@"行业动态",@"阿烟信息"];
    
    [self setUpChanelView];
    [self setUpSNScrollView];

}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"党建要闻";
}
- (NSArray <NSDictionary *>*)itemArray {
    if (!_itemArray) {
        
        _itemArray = @[@{@"type":@(ArticleListRequestTheCentralNewsType),
                         @"title":@"中央新闻"},
                       @{@"type":@(ArticleListRequestIndustryDynamicType),
                         @"title":@"行业动态"},
                       @{@"type":@(ArticleListRequestSmokeInformationType),
                         @"title":@"阿烟信息"}];
    }
    return _itemArray;
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
    
    // -- 循环创建ListView
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        
        SKListView *newsListView = [[SKListView alloc] initWithFrame:self.tmpScrollView.bounds];
        newsListView.articleType = [[self.itemArray[i] objectForKey:@"type"] integerValue];
        newsListView.delegate = self;
        [self.tmpScrollView loadNewsListView:newsListView ];
    }
    //回调或者说是通知主线程刷新，
    [self.view addSubview:self.tmpScrollView];
    /**  线程安全问题
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        // -- 循环创建ListView 
        for (NSInteger i = 0; i < _titleArray.count; i++) {
            
            SKListView *newsListView = [[SKListView alloc] initWithFrame:self.tmpScrollView.bounds];
            newsListView.delegate = self;
            [self.tmpScrollView loadNewsListView:newsListView ];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.view addSubview:self.tmpScrollView];
            
        });
    });
    */
}


- (void)listViewRequestDataSender:(SKListView *)sender Params:(NSDictionary *)params success:(requestListDataBlock)success {
    
    success(nil);
}
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
        // -- 自动刷新
    SKListView *tmpView = (SKListView *)[self.tmpScrollView getCurrentNewsListView];
    [tmpView autoRefreshCanBe];
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
