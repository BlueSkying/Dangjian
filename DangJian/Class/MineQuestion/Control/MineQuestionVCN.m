//
//  MineQuestionVCN.m
//  DangJian
//
//  Created by huangchen on 2018/8/21.
//  Copyright © 2018年 Sakya. All rights reserved.
//

#import "MineQuestionVCN.h"

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
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:obj,@"data",@"questionCell",kIdentifier, nil ];
        [_dataSource addObject:@[dict]];
    }];
    
    [_tableView reloadData];
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
