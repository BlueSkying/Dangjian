//
//  OnlineTestDetailsViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestDetailsViewController.h"
#import "OnlineTestCountdownView.h"
#import "OnlineTestQidChoiceView.h"
#import "OnlineTestOptionsCell.h"
#import "OnlineTestHeaderView.h"
#import "OnlineTestDetailsVo.h"
#import "OnlineTestOptionsVo.h"
#import "OnlineTestHistoricalPerformanceViewController.h"
#import "JXTAlertController.h"
#import "SKPlaceholderView.h"
#import "NSString+Util.h"




@interface OnlineTestDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,OnlineTestCountdownViewDelegate,OnlineTestQidChoiceViewDelegate> {
   
    /**上一个选中的*/
    NSInteger _thePreviousIndex;
    /**当前的选项*/
    NSInteger _theCurrentIndex;
}

@property (nonatomic, strong) UITableView *tableView;
/**
 全部数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
//占位图
@property (nonatomic, strong) SKPlaceholderView *placeholderView;

/**
 当前题的实体
 */
@property (nonatomic, strong) OnlineTestDetailsVo *optionVo;
/**
 选择题号的view
 */
@property (nonatomic, strong) OnlineTestQidChoiceView *qidChoiceView;
/**
 倒计时页面
 */
@property (nonatomic, strong) OnlineTestCountdownView *topDetailsView;
@end


@implementation OnlineTestDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _thePreviousIndex = 0;
    _theCurrentIndex = 0;
    [self setUpNavigationBar];
    [self initCustomView];
    [self getData];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = _testVo.title.length > 7 ? [NSString stringWithFormat:@"%@...",[_testVo.title substringToIndex:7]] : _testVo.title;
}
- (void)getData {
    
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    [OnlineTestDetailsVo examInformationTestId:_testVo.examinationPaperId success:^(id result) {
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager hideAlert];
            //转换数组模型
            NSArray *lisArray = [OnlineTestDetailsVo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
            weakSelf.dataArray = lisArray.mutableCopy;
            //根据数据处理视图
            [weakSelf changeViewDependsOnData];
        }
    }];
}

- (void)changeViewDependsOnData {
    
    if (self.dataArray.count > 0) {
        
        //可以考试则进入倒计时页面
        if (_testVo.isexpire) {
            self.topDetailsView.countdown = _testVo.duration;
        }
        self.optionVo = [self.dataArray firstObject];
        //选题模块刷新
        [self reloadQidChoiceView];
        self.qidChoiceView.selectedIndex = _thePreviousIndex + 1;
        [self.tableView reloadData];
//        self.placeholderView.hidden = YES;
        self.qidChoiceView.hidden = NO;
        if (self.testVo.isexpire) {
            [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];
        }
    } else {
//        self.placeholderView.hidden = NO;
        self.qidChoiceView.hidden = YES;
    }
}
#pragma mark -- init
- (void)initCustomView {
    
    //计算时间描述文字的高度
    CGSize countDownViewSize = [Helper markGetAuthenticSize:_testVo.content Font:FONT_12 MaxSize:CGSizeMake(kScreen_Width - 50, 1000)];
    CGFloat CountdownViewHeight = countDownViewSize.height;
    CountdownViewHeight += 100;
    
    OnlineTestCountdownView *topDetailsView = [[OnlineTestCountdownView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, CountdownViewHeight)];
    topDetailsView.delegate = self;
    topDetailsView.testDescribe = _testVo.content;
    [self.view addSubview:topDetailsView];
    _topDetailsView = topDetailsView;
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(topDetailsView.frame), kScreen_Width, kScreen_Height - 50 - 64 - CountdownViewHeight) delegateAgent:self superview:self.view];
    
    OnlineTestQidChoiceView *qidChoiceView = [[OnlineTestQidChoiceView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 50, kScreen_Width, 50) superView:self.view];
    qidChoiceView.delegate = self;
    _qidChoiceView = qidChoiceView;
    qidChoiceView.hidden = YES;
    [self.view addSubview:qidChoiceView];
}
- (void)reloadQidChoiceView {
    
    _qidChoiceView.totalArray = self.dataArray;
}
#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (SKPlaceholderView *)placeholderView {
    
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.tableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noContent_icon";
        _placeholderView.titleText = @"暂无试题";
        _placeholderView.titleLabel.textColor = Color_9;
        [self.tableView addSubview:_placeholderView];
    }
    return _placeholderView;
    
}
#pragma mark -- tableDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.optionVo.optionArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ID";
    
    OnlineTestOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OnlineTestOptionsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.optionVo = self.optionVo.optionArray[indexPath.row];
    return cell;
    
}
#pragma mark -- tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

   return ((OnlineTestOptionsVo *)self.optionVo.optionArray[indexPath.row]).cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    OnlineTestHeaderView *headerView = [OnlineTestHeaderView headerViewWithTableView:tableView];
    headerView.qidId = [NSString stringWithFormat:@"Q%ld.",(long)(_theCurrentIndex + 1)];
    headerView.title = [NSString stringWithFormat:@"Q%ld.%@",(long)(_theCurrentIndex + 1),self.optionVo.titleDetails ? self.optionVo.titleDetails : @""];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    OnlineTestHeaderView *headerView = [OnlineTestHeaderView headerViewWithTableView:tableView];
    headerView.qidId = [NSString stringWithFormat:@"Q%ld.",(long)(_theCurrentIndex + 1)];
    headerView.title = [NSString stringWithFormat:@"Q%ld.%@",(long)(_theCurrentIndex + 1),self.optionVo.titleDetails ? self.optionVo.titleDetails : @""];
    CGFloat height = [headerView heighthHeaderView];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //需要判断试题类型
    //多选
    if (self.optionVo.questionsType == TestQuestionsMoreType) {
        
        if (self.optionVo.optionArray.count > indexPath.row) {
            OnlineTestOptionsVo *optionsVo = self.optionVo.optionArray[indexPath.row];
            ((OnlineTestOptionsVo *)self.optionVo.optionArray[indexPath.row]).isSelected =  !optionsVo.isSelected;
        }
    } else if (self.optionVo.questionsType == TestQuestionsJudgeType ||
               self.optionVo.questionsType == TestQuestionsSingleType) {
        //        单选和判断
        [self.optionVo.optionArray enumerateObjectsUsingBlock:^(OnlineTestOptionsVo  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.isSelected  = NO;
        }];
        ((OnlineTestOptionsVo *)self.optionVo.optionArray[indexPath.row]).isSelected = YES;
    }
    //刷新视图
    [_tableView reloadData];

}
#pragma mark -- delegate
//OnlineTestCountdownViewDelegate
- (void)onlineTestCountdownViewOutOfTime {
    
    __weak typeof(self) weakSelf = self;
    [self jxt_showAlertWithTitle:@"提示" message:@"考试时间已到，系统将自动为您提交" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionCancelTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        //提交成绩了
        if (buttonIndex == 0) {
            [weakSelf commtiTestScores];
        }
    }];
}

//,OnlineTestQidChoiceViewDelegate
- (void)onlineTestQidChoiceViewNavBarItemClicked:(UIButton *)sender topicIndex:(NSInteger)topicIndex{
    

    [self switchTopicIndex:topicIndex];
}
- (void)onlineTestQidChoiceViewQidSelectedIndex:(NSInteger)index {
    
    DDLogInfo(@"选择第几道题了啊%ld",(long)(index + 1));
    
    [self switchTopicIndex:index];
}
//计算分值在切换的时候处理的
- (void)switchTopicIndex:(NSInteger)index {
    

    _thePreviousIndex = _theCurrentIndex;
    _theCurrentIndex = index;
    __block OnlineTestDetailsVo *previousOptionVo = self.optionVo;
    // 异步处理数据 计算本题得分
    dispatch_queue_t queuet = dispatch_queue_create("calculateThread", NULL);
    dispatch_async(queuet, ^{
        
        __block BOOL isRight = YES;
        [previousOptionVo.optionArray enumerateObjectsUsingBlock:^(OnlineTestOptionsVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected != obj.correctAnswer) {
                isRight = NO;
                *stop = YES;
            }
        }];
//        判断是否是正确的
        if (isRight) {
            previousOptionVo.actualPoints = previousOptionVo.score;
        } else {
            previousOptionVo.actualPoints = 0;
        }
        [self.dataArray replaceObjectAtIndex:_thePreviousIndex withObject:previousOptionVo];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self reloadQidChoiceView];
        });
    });
    if (self.dataArray.count > index) {
        self.optionVo = self.dataArray[index];
        [_tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];

    }
}
//计算分值
- (void)calculateTheScore {
    
    __block BOOL isRight = YES;
    //此处需要同步计算 ，异步可能出现问题
    OnlineTestDetailsVo *previousOptionVo = self.optionVo;
    [previousOptionVo.optionArray enumerateObjectsUsingBlock:^(OnlineTestOptionsVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected != obj.correctAnswer) {
            isRight = NO;
            *stop = YES;
        }
    }];
    //        判断是否是正确的
    if (isRight) {
        previousOptionVo.actualPoints = previousOptionVo.score;
    } else {
        previousOptionVo.actualPoints = 0;
    }
    [self.dataArray replaceObjectAtIndex:_thePreviousIndex withObject:previousOptionVo];
    [self reloadQidChoiceView];
}
#pragma mark -- action
//提交成绩
- (void)rightButtonTouchUpInside:(UIButton *)sender {

    [self commtiTestScores];
}
#pragma mark -- commit score
- (void)commtiTestScores {
    
    [SKHUDManager showLoadingText:@"提交中..."];
    [self calculateTheScore];
    __block NSInteger score = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(OnlineTestDetailsVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        score += obj.actualPoints;
    }];
    DDLogInfo(@"%ld",(long)score);
    __weak typeof(self) weakSelf = self;
    [InterfaceManager examCommitScoreValue:[NSString stringWithFormat:@"%ld",(long)score] examId:_testVo.examinationPaperId success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            
            [SKHUDManager showBriefAlert:@"试卷提交成功"];
            OnlineTestHistoricalPerformanceViewController *historyPageView = [[OnlineTestHistoricalPerformanceViewController alloc] init];
            [weakSelf.navigationController pushViewController:historyPageView animated:YES];
        }
    }];
}


- (void)dealloc {
    
    
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
