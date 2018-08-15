//
//  DuesRecordViewController.m
//  DangJian
//
//  Created by Sakya on 17/6/1.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DuesRecordViewController.h"


@interface DuesRecordViewController ()


@end

@implementation DuesRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    
}
- (void)setUpNavigationBar {
    
    if (_isPayCost) {
        self.navigationItem.title = @"在线缴费";

    } else {
        self.navigationItem.title = @"详情";
    }
}
- (void)initCustomView {
    
    if (!_isPayCost) {
        DuesRecordContentView *headerView = [[DuesRecordContentView alloc] init];
        [headerView setFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        headerView.backgroundColor = [Helper colorWithHexString:@"#f0f0f4"];
        headerView.dateLabel.text = @"年／月";
        headerView.toBePaidLabel.text = @"已缴党费";
        headerView.toBePaidLabel.textColor = COLOR_LIGHTBLUE;
        headerView.alreadyPayLabel.text = @"待缴党费";
        headerView.alreadyPayLabel.textColor = Color_system_red;
        [self.view addSubview:headerView];
        [self.tableView setFrame:CGRectMake(0,  40, kScreen_Width, kScreen_Height  - 40)];
    }
    self.showRefreshHeader = YES;
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - getter
- (DuesVo *)duesVo {
    if (!_duesVo) {
        _duesVo = [DuesVo new];
    }
    return _duesVo;
}

#pragma mark -- tableDelegate tableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.duesVo.totalArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"DuesRecordCell";
    DuesVo *duesVo;
    if (self.duesVo.totalArray.count > indexPath.row) {
        duesVo = self.duesVo.totalArray[indexPath.row];
    }
    DuesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[DuesRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.duesVo = duesVo;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}



//刷新加载数据
- (void)tableViewDidTriggerFooterRefresh {
    [self getDataIsHeader:NO];
}
- (void)tableViewDidTriggerHeaderRefresh {
    [self getDataIsHeader:YES];
}
- (void)getDataIsHeader:(BOOL)isHeader {
    
    __weak typeof(self) weakSelf = self;
    //缴费进入的就是查询自己的 同为true
    [self.duesVo duesQueryIsHeader:isHeader account:_workNumber mine:_isPayCost year:_payCostDate success:^(DuesVo *result) {
        
        [weakSelf tableViewDidFinishTriggerHeader:isHeader reload:NO];
        if (result) {
            
            weakSelf.duesVo = result;
            if (result.pageNo < result.totalPage) {
                weakSelf.showRefreshFooter = YES;
            } else {
                weakSelf.showRefreshFooter = NO;
            }
            [weakSelf showTableBlankViewDependDataCount:weakSelf.duesVo.totalArray.count];
            [weakSelf.tableView reloadData];
        }
    } failed:^(id error) {
        [weakSelf tableViewDidFinishTriggerHeader:isHeader reload:NO];
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
