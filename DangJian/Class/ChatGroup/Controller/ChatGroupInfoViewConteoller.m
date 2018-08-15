//
//  ChatGroupInfoViewConteoller.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ChatGroupInfoViewConteoller.h"
#import "GroupMemberListCell.h"
#import "UserContactModel.h"

@interface ChatGroupInfoViewConteoller ()<UITableViewDelegate,UITableViewDataSource>

/**
 群组ID
 */
@property (nonatomic, strong) NSString *groupId;

@property (strong, nonatomic) NSMutableArray *dataSource;

/**
 aCursor          游标，首次调用传空
 */
@property (nonatomic, strong) NSString *cursor;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChatGroupInfoViewConteoller

- (instancetype)initWithGroupId:(NSString *)aGroupId
{
    self = [super init];
    if (self) {
        _groupId = aGroupId;
    }
    
    return self;
}

- (void)fetchGroupMembersIsHeader:(BOOL)isHeader
{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        __weak typeof(self) weakSelf = self;
        [[EMClient sharedClient].groupManager getGroupMemberListFromServerWithId:self.groupId cursor:self.cursor pageSize:20 completion:^(EMCursorResult *aResult, EMError *aError) {
            
            weakSelf.cursor = aResult.cursor;
            if (!aError) {
                if (isHeader) {
                    [weakSelf.dataSource removeAllObjects];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.dataSource addObjectsFromArray:aResult.list];
                    [weakSelf.tableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
                });
                
            }
            [weakSelf.tableView.mj_header endRefreshing];
            if (aResult.list.count == 0 || weakSelf.dataSource.count < 20) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }];
        
    });
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCustomView];
    [self setUpNarBarState];
}
- (void)setUpNarBarState {
    
    [self setUpNavItemTitle:@"会议室成员"];
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [_tableView.mj_header beginRefreshing];
    
}
- (void)loadMoreData {
    [self fetchGroupMembersIsHeader:NO];
}
- (void)refreshData {
    self.cursor = nil;
    [self fetchGroupMembersIsHeader:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *account;
    if (self.dataSource.count > indexPath.row) {
        account = [self.dataSource objectAtIndex:indexPath.row];
    }
    static NSString *ID = @"ID";
    GroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GroupMemberListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.name = account;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
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
