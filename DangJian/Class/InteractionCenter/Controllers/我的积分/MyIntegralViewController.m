//
//  MyIntegralViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "MyIntegralHeaderView.h"
#import "TemplateCellProtocol.h"
#import "InteractionCenterMyIntegralModel.h"
#import "SKPlaceholderView.h"
#import "IntegralInstructionsViewController.h"


@interface MyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) InteractionCenterMyIntegralModel*integalModel;

@property (nonatomic, strong) MyIntegralHeaderView *integralHeaderview;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;

@end

@implementation MyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"我的积分"];
    
}
- (void)initCustomView {

    MyIntegralHeaderView *headerView = [[MyIntegralHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 235)];
    headerView.tag = 1001;
    [self.view addSubview:headerView];
    _integralHeaderview = headerView;
    
    [self setNavigationRightBarButtonWithImageNamed:@"InteractionCenter_integral_icon"];

    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreen_Width, kScreen_Height - CGRectGetMaxY(headerView.frame)) delegateAgent:self superview:self.view];
    [_tableView registerClass:NSClassFromString(@"InteractionCenterMyIntegralCell") forCellReuseIdentifier:@"InteractionCenterMyIntegralCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadDataIsHeader:YES];

}
- (InteractionCenterMyIntegralModel *)integalModel {
    if (!_integalModel) {
        _integalModel = [InteractionCenterMyIntegralModel new];
    }
    return _integalModel;
}

#pragma mark - tableDelegate tableDataSurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     TemplateContainerModel<TemplateContainerProtocol> *list = self.integalModel;
    return [list numberOfChildModelsInContainer];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id <TemplateRenderProtocol> model = [self.integalModel rowModelAtIndexPath:indexPath];
    UITableViewCell <TemplateCellProtocol> * cell = [tableView dequeueReusableCellWithIdentifier:[model floorIdentifier]];
    [cell processData:model];
    if(!cell){
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }else{
        return (UITableViewCell *)cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<TemplateRenderProtocol>floor = [self.integalModel rowModelAtIndexPath:indexPath];
    if ([floor respondsToSelector:@selector(floorIdentifier)]) {
        NSString *cellIdentifier = [floor floorIdentifier];
        Class<TemplateCellProtocol> cellClass = NSClassFromString(cellIdentifier);
        CGSize size = [cellClass calculateSizeWithData:floor constrainedToSize:CGSizeMake(tableView.frame.size.width, 0.0)];
        return size.height;
    }
    return 0;
}




#pragma mark - load refresh Data
- (void)refreshData {
    [self loadDataIsHeader:YES];
}
- (void)loadMoreData {
    [self loadDataIsHeader:NO];
}
- (void)loadDataIsHeader:(BOOL)isHeader {
   
    __weak typeof(self) weakSelf = self;
    [self.integalModel pointsIsHeader:isHeader success:^(InteractionCenterMyIntegralModel *result) {
       
        //结束加载
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (result) {
            weakSelf.integalModel = result;
//            积分
            if (weakSelf.integralHeaderview.progressValue == 0) {
                weakSelf.integralHeaderview.progressValue = [result.points doubleValue];
            }
            [weakSelf.tableView reloadData];
        }
        
        //判断是否还能加载数据
        if (result.pageNo < result.totalPage) {
            weakSelf.tableView.mj_footer.hidden = NO;
        } else {
            weakSelf.tableView.mj_footer.hidden = YES;
        }
        //判断有没有数据显示占位图
        if (weakSelf.integalModel.totalArray.count > 0) {
            weakSelf.placeholderView.hidden = YES;
        } else {
            weakSelf.placeholderView.hidden = NO;
        }
    } failed:^(id error) {
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
}
//占位图
- (SKPlaceholderView *)placeholderView {
    
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.tableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noContent_icon";
        _placeholderView.titleText = @"暂无内容";
        _placeholderView.titleLabel.textColor = Color_9;
        [self.tableView addSubview:_placeholderView];
    }
    return _placeholderView;
}
#pragma mark -- action
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    IntegralInstructionsViewController *webView = [[IntegralInstructionsViewController alloc] init];
    webView.urlID = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,INTEGRALDESCRIBEURL];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
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
