//
//  DemocraticAppraisalViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DemocraticAppraisalViewController.h"

@interface DemocraticAppraisalViewController ()<UITableViewDelegate,UITableViewDataSource,DemocraticReviewOptionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <DemocraticAppraisalVo *>*optionArray;


@end

@implementation DemocraticAppraisalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self initData];
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"民主评议"];
    [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    //实例化一个CAShapeLayer对象
    CALayer *border = [CALayer layer];
    [border setFrame:CGRectMake(0, 50 - 0.5, kScreen_Width, 0.5)];
    //不设置填充颜色,如果不置空默认为黑色
    border.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    //添加到当前view的layer层上 , 这里注意不要无意义的重复添加哦
    [headerView.layer addSublayer:border];
    
    UILabel *nameLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"姓名" font:FONT_15];
    [nameLabel setFrame:CGRectMake(15, 0, 90, CGRectGetHeight(headerView.frame))];
    [headerView addSubview:nameLabel];
    
    
    UILabel *scoreLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_6 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"综合评价" font:FONT_15];
    [scoreLabel setFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, kScreen_Width - 90 - 15, CGRectGetHeight(headerView.frame))];
    [headerView addSubview:scoreLabel];
    

}
- (void)initData {
   
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    
    [InterfaceManager democraticAppraisalDetailsApprId:_appraisalVo.contentId success:^(id result) {
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager hideAlert];
            NSArray *options = [DemocraticAppraisalVo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
            weakSelf.optionArray = options.mutableCopy;
            [weakSelf.tableView reloadData];
        }
    }];
    
}
- (NSMutableArray <DemocraticAppraisalVo *>*)optionArray {
    if (!_optionArray) {
        _optionArray = [NSMutableArray array];
    }
    return _optionArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.optionArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemocraticAppraisalVo *appraisalVo;
    if (self.optionArray.count > indexPath.row) {
        appraisalVo = self.optionArray[indexPath.row];
    }
    static NSString *ID = @"DemocraticID";
    DemocraticReviewOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[DemocraticReviewOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.appraisalVo = appraisalVo;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 50;
}

#pragma mark -- action
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    if (self.optionArray.count == 0) {
        [SKHUDManager showBriefAlert:@"没有评选，无需提交"];
        return;
    }
    __block NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.optionArray enumerateObjectsUsingBlock:^(DemocraticAppraisalVo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.choiceResult ||
            !obj.contentId) {
            *stop = YES;
        } else{
            NSDictionary *resultDict = @{@"ids":obj.contentId,
                                         @"results":obj.choiceResult};
            [resultArray addObject:resultDict];
        }
    }];
    if (resultArray.count != self.optionArray.count) {
        [SKHUDManager showBriefAlert:@"必须全部评价完才能提交"];
        return;
    }
    [SKHUDManager showLoadingText:@"提交中..."];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager democraticAppraisalSubmitApprId:_appraisalVo.contentId parameArray:resultArray success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"评议成功"];
            weakSelf.appraisalSuccessBlock ? weakSelf.appraisalSuccessBlock() : nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -- DemocraticReviewOptionCellDelegate
- (void)democraticReviewOption:(DemocraticAppraisalVo *)appraisalVo indexPath:(NSIndexPath *)indexPath {
    
    [self.optionArray replaceObjectAtIndex:indexPath.row withObject:appraisalVo];

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
