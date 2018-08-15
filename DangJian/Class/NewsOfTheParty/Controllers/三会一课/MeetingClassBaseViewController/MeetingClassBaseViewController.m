//
//  MeetingClassBaseViewController
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MeetingClassBaseViewController.h"
#import "SKSegmentedView.h"
#import "SKScrollView.h"
#import "SKListView.h"
#import "ChatViewController.h"

@interface MeetingClassBaseViewController ()<SKListViewDelegate>

@property (nonatomic , strong) SKSegmentedView *chanelView;

@property (nonatomic , strong) SKScrollView *tmpScrollView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *itemArray;


/**
 不同模块对应的群组信息
 */
@property (nonatomic, strong) EMGroup *groupInfo;


@end

@implementation MeetingClassBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpChanelView];
    [self setUpSNScrollView];
    [self setUpNavigationBar];
    [self getGroupList];
    
}

- (void)setPageType:(MeetingClassPageType)pageType {
    
    _pageType = pageType;
    switch (pageType) {
        case MeetingClassMemberConferencePageType:
            _titleArray = @[@"会议通知",
                            @"会议内容"];
            _itemArray =
            @[@(ArticleListRequestMemberMeetingNoticeType),
              @(ArticleListRequestMemberMeetingResolutionType)];
            self.navigationItem.title = @"党员大会";

            break;
        case MeetingClassThePartyBranchCommitteePageType:
            _titleArray = @[@"会议通知",
                            @"会议纪要"];
            _itemArray =
            @[@(ArticleListRequestThePartyBranchCommitteeNoticeType),
              @(ArticleListRequestThePartyBranchCommitteeResolutionType)];
            self.navigationItem.title = @"党支部委员会";
            break;
        case MeetingClassThePartyGroupPageType :
            _titleArray = @[@"会议通知",
                            @"会议内容"];
            _itemArray =
            @[@(ArticleListRequestThePartyGroupNoticeType),
              @(ArticleListRequestThePartyGroupResolutionType)];
            self.navigationItem.title = @"党小组会";
            break;
        case MeetingClassThePartyClassPageType:
            _titleArray = @[@"党课讲义",
                            @"微党课学习"];
            _itemArray =
            @[@(ArticleListRequestThePartyClassNotesType),
              @(ArticleListRequestThePartyClassLearningType)];
            self.navigationItem.title = @"党课";
            break;
        default:
            break;
    }
}
- (void)setUpNavigationBar {
    
    if (_pageType != MeetingClassThePartyClassPageType) {
        
//        [self setNavigationRightBarButtonWithtitle:@"会议室" titleColor:[UIColor whiteColor]];
    }

}
#pragma mark -- 获取群组列表
- (void)getGroupList {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        EMError *error = nil;
        NSArray *myGroups = [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:1 pageSize:50 error:&error];
        __block EMGroup *joinGroup;
        if (!error) {
            [myGroups enumerateObjectsUsingBlock:^(EMGroup *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.subject isEqualToString:@"党员大会"] && _pageType == MeetingClassMemberConferencePageType) {
                    
                    joinGroup = obj;
                } else if ([obj.subject isEqualToString:@"党支部委员会"] && _pageType == MeetingClassThePartyBranchCommitteePageType) {
                   
                    joinGroup = obj;
                } else if ([obj.subject isEqualToString:@"党小组会"] && _pageType == MeetingClassThePartyGroupPageType) {
                    
                    joinGroup = obj;
                }
                DDLogInfo(@"获取成功 -- %@",obj.groupId);
            }];
        }
        self.groupInfo = joinGroup;
    });
    
    //本地群组
 //   NSArray *groupList = [[EMClient sharedClient].groupManager getJoinedGroups];
 //   NSLog(@"%@",groupList);
}

#pragma mark -- 创建更多频道的View
// -- 创建分类频道的滚动视图
- (void) setUpChanelView{
    
    __weak typeof(self) weakSelf = self;
    // -- 分类频道的滚动视图
    self.chanelView = [[SKSegmentedView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 43)];
    // -- 循环创建分类频道按钮
    [self.chanelView loadButtonTitleArray:self.titleArray];
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
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        
        SKListView *newsListView = [[SKListView alloc] initWithFrame:self.tmpScrollView.bounds];
        newsListView.articleType = [self.itemArray[i] integerValue];
        newsListView.delegate = self;
        [self.tmpScrollView loadNewsListView:newsListView ];
    }
    //回调或者说是通知主线程刷新，
    [self.view addSubview:self.tmpScrollView];
    
}


- (void)listViewRequestDataSender:(SKListView *)sender Params:(NSDictionary *)params success:(requestListDataBlock)success {
    
    success(nil);
}
#pragma mark -- rightNavButtonAction  chat
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    //进入聊天室
//    15805433577473
    if (!self.groupInfo) {
        [SKHUDManager showBriefMessage:@"暂时没有加入会议室，请联系管理员确认" InView:self.view];
    } else {
        UIViewController *chatController = nil;
        chatController = [[ChatViewController alloc] initWithConversationChatter:self.groupInfo.groupId conversationType:EMConversationTypeGroupChat];
        chatController.title = self.groupInfo.subject ? self.groupInfo.subject : @"群组" ;
        [self.navigationController pushViewController:chatController animated:YES];
    }
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
