//
//  OnlineVotingViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineVotingViewController.h"
#import "OnlineVoteHeaderFooterView.h"
#import "OnlineVotingCell.h"
@interface OnlineVotingViewController ()<UITableViewDelegate,UITableViewDataSource,OnlineVoteHeaderFooterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OnlineVoteHeaderFooterView *headerView;

@property (nonatomic, strong) NSMutableDictionary *configParams;
/**
 在线投票
 */
@property (nonatomic, strong) NSMutableArray <DemocraticAppraisalVo *>*onlineVoteArray;

@end

@implementation OnlineVotingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self initData];
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    _headerView = [[OnlineVoteHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200) type:OnlineVoteHeaderiew];
    _headerView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    
    OnlineVoteHeaderFooterView *footerView = [[OnlineVoteHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 55) type:OnlineVoteFooterView];
    footerView.delegate = self;
    footerView.tag = 1001;
    _tableView.tableFooterView = footerView;

}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"在线投票"];
}
- (void)initData {
    
    [SKHUDManager showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager onlineVoteDetailsVoteId:_appraisalVo.contentId success:^(id result) {
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            
            [SKHUDManager hideAlert];
            NSArray  *onlineVoteArray = [DemocraticAppraisalVo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
            weakSelf.onlineVoteArray = onlineVoteArray.mutableCopy;
            [weakSelf reloadViewData];
            [weakSelf.headerView reload];
        }
    }];
}
- (void)reloadViewData {
    
    [self.tableView reloadData];
    DemocraticAppraisalVo *onlineVo;
    if (self.onlineVoteArray.count > 0) {
        onlineVo = self.onlineVoteArray.firstObject;
    }
    if (onlineVo.title)     [self setUpNavItemTitle:onlineVo.title];



}
- (NSMutableArray <DemocraticAppraisalVo *>*)onlineVoteArray {
    if (!_onlineVoteArray) {
        _onlineVoteArray = [NSMutableArray array];
    }
    return _onlineVoteArray;
}
- (NSMutableDictionary *)configParams {
    if (!_configParams) {
        _configParams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _configParams;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.onlineVoteArray.count > 0) {
        return ((DemocraticAppraisalVo *)(self.onlineVoteArray.firstObject)).choiceArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *titleText;
    if (((DemocraticAppraisalVo *)(self.onlineVoteArray.firstObject)).choiceArray.count > indexPath.row) {
       titleText  = ((DemocraticAppraisalVo *)(self.onlineVoteArray.firstObject)).choiceArray[indexPath.row];
    }
    static NSString *ID = @"DemocraticID";
    OnlineVotingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OnlineVotingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.titleText = titleText;
    NSString *isSelect = [self.configParams objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell.isSelect = [isSelect boolValue];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellSingleTextHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlineVotingCell * cell = (OnlineVotingCell *)[tableView.dataSource tableView:_tableView cellForRowAtIndexPath:indexPath];
    UIButton *isSelectButton = [cell viewWithTag:1001];
    if (isSelectButton.isSelected) {
        
        [Helper setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row] inDic:self.configParams];
        
    } else {
        
//        改变投票的数据
        DemocraticAppraisalVo *onlineVo = self.onlineVoteArray.firstObject;
        if (onlineVo.radio) {
            [self.configParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.configParams setObject:@"0" forKey:key];
            }];
            [Helper setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row] inDic:self.configParams];
        } else {
            [Helper setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row] inDic:self.configParams];
        }
    }
    
    [self detectionSelectMember];
    [_tableView reloadData];
}

/**
 检测选择成员
 */
- (void)detectionSelectMember {
    
    __block BOOL isSelect = NO;
    //上传数据处理 改变提交按钮状态
    [self.configParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj integerValue] == 1) {
            isSelect = YES;
            *stop = YES;
        }
    }];
    if (isSelect) {
        ((OnlineVoteHeaderFooterView *)_tableView.tableFooterView).canClicked = YES;
    } else {
        ((OnlineVoteHeaderFooterView *)_tableView.tableFooterView).canClicked = NO;
    }
    
}



#pragma mark headerDelegate
- (void)heightForOnlineVoteHeaderView:(OnlineVoteHeaderFooterView *)decorationView height:(CGFloat)height {
    
    [_tableView beginUpdates];
    _headerView.frame = CGRectMake(0, 0, kScreen_Width, height);
    _tableView.tableHeaderView = _headerView;
    [_tableView endUpdates];
}
- (DemocraticAppraisalVo *)headerFooterView:(OnlineVoteHeaderFooterView *)decorationView {
   
    DemocraticAppraisalVo *onlineVo;
    if (self.onlineVoteArray.count > 0) {
        onlineVo = self.onlineVoteArray.firstObject;
    }
    return onlineVo;
}
- (void)footerViewSelected:(UIButton *)sender {
    //提交
    DDLogDebug(@"提交");
    DemocraticAppraisalVo *onlineVo;
    if (self.onlineVoteArray.count > 0) {
        onlineVo  = self.onlineVoteArray.firstObject;
    }
    __block NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    __block NSInteger index;
    //上传数据处理
    [self.configParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        index += 1;
        //筛选选中的
        if ([obj integerValue] == 1) {
            [resultArray addObject:[NSString stringWithFormat:@"%ld",(long)([key integerValue] + 1)]];
        }
    }];
    if (resultArray.count == 0) {
        [SKHUDManager showBriefAlert:@"请选择成员后再投票"];
        return;
    }

    [SKHUDManager showLoadingText:@"提交中..."];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager onlineVoteCommitVoteId:_appraisalVo.contentId ids:onlineVo.contentId resultsArray:resultArray success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"投票成功"];
            weakSelf.onlineVotingSuccessBlock ? weakSelf.onlineVotingSuccessBlock() : nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
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
