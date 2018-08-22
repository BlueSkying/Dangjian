//
//  MineQuestionVCN.m
//  DangJian
//
//  Created by huangchen on 2018/8/21.
//  Copyright © 2018年 Sakya. All rights reserved.
//

#import "MineQuestionVCN.h"
#import "TypeCell.h"
#import "ChooseCell.h"
#import "MyQuestionCell.h"
@interface MineQuestionVCN ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * name;
    NSString * departMent;
    NSString * timeGrap;
    NSString * isNeedRepair;   //1是待整改  0是已完成
    NSMutableArray * dataArray;  //数据源对象
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MineQuestionVCN

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    isNeedRepair = @"1";
    [self initData];
    [self initCustomView];
}

- (void)initCustomView {
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64 , kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 45;
    [_tableView registerClass:[TypeCell class] forCellReuseIdentifier:@"btnCell"];
    [_tableView registerClass:[ChooseCell class] forCellReuseIdentifier:@"chooseCell"];
    [_tableView registerClass:[MyQuestionCell class] forCellReuseIdentifier:@"questionCell"];
}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"我的问题";
}

- (void)initData{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [_dataSource removeAllObjects];
    
    [_dataSource addObject:@[@{kTitle:@"姓名",kSubTitle:name?name:@"请选择",kIdentifier:@"chooseCell"},@{kTitle:@"部门",kSubTitle:departMent?departMent:@"请选择",kIdentifier:@"chooseCell"},@{kTitle:@"时间",kSubTitle:timeGrap?timeGrap:@"请选择",kIdentifier:@"chooseCell"}]];
    [_dataSource addObject:@[@{kIsSelected:isNeedRepair,kIdentifier:@"btnCell"}]];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:dataArray.count];
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:obj,@"data",@"questionCell",kIdentifier, nil ];
        [array addObject:dict];
    }];
    [_dataSource addObject:array];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0 || section == 1){
        return 20;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = safeGetArrayObject(_dataSource,section);
    return array.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = safeGetArrayObject(_dataSource, indexPath.section);
    NSDictionary * dict =  safeGetArrayObject(array,indexPath.row);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dict[kIdentifier] forIndexPath:indexPath];
    if([cell isKindOfClass:[ChooseCell class]]){
        ChooseCell * chooseCell = (ChooseCell*)cell;
        [chooseCell setObject:dict];
    }else if ([cell isKindOfClass:[TypeCell class]]){
        TypeCell * typeCell = (TypeCell*)cell;
        [typeCell setInfo:dict];
    }else if ([cell isKindOfClass:[MyQuestionCell class]]){
        MyQuestionCell * questionCell = (MyQuestionCell*)cell;
        [questionCell setObject:dict];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //进入详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
