//
//  ThePartyTraceViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThePartyTraceViewController.h"
#import "TemplateContainerModel.h"
#import "InteractionCenterThePartyTraceModel.h"
#import "TemplateCellProtocol.h"
#import "SKPlaceholderView.h"


static NSString *const CellIdentifier = @"InteractionCenterThePartyTraceCell";

@interface ThePartyTraceViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) InteractionCenterThePartyTraceModel *thePartyTraceModel;
@property (nonatomic, strong) SKPlaceholderView *placeholderView;



@end

@implementation ThePartyTraceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"我的党迹"];
    
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    [_tableView registerClass:NSClassFromString(CellIdentifier) forCellReuseIdentifier:CellIdentifier];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    UIImageView *grayLineImageView = [[UIImageView alloc] init];
    [footerView addSubview:grayLineImageView];
    [grayLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.bottom.offset(0);
        make.width.offset(4);
    }];
    grayLineImageView.backgroundColor = SystemGraySeparatedLineColor;
    _tableView.tableFooterView = footerView;

    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [SKHUDManager showLoading];
    [self refreshData];
    
}
- (InteractionCenterThePartyTraceModel *)thePartyTraceModel {
    if (!_thePartyTraceModel) {
        _thePartyTraceModel = [InteractionCenterThePartyTraceModel new];
    }
    return _thePartyTraceModel;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TemplateContainerModel<TemplateContainerProtocol> *list = (TemplateContainerModel *)self.thePartyTraceModel;
    return [list numberOfChildModelsInContainer];

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id <TemplateRenderProtocol> model = [self.thePartyTraceModel rowModelAtIndexPath:indexPath];
    UITableViewCell <TemplateCellProtocol> * cell = [tableView dequeueReusableCellWithIdentifier:[model floorIdentifier]];
    [cell processData:model];
    //    [cell tapOnePlace:[self tapBlockForModel:model]];
    if(!cell){
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }else{
        return (UITableViewCell *)cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id <TemplateRenderProtocol>  floor = [self.thePartyTraceModel rowModelAtIndexPath:indexPath];
    if ([floor respondsToSelector:@selector(floorIdentifier)]) {
        NSString *cellIdentifier = [floor floorIdentifier];
        Class<TemplateCellProtocol> viewClass = NSClassFromString(cellIdentifier);
        CGSize size = [viewClass calculateSizeWithData:floor constrainedToSize:CGSizeMake(tableView.frame.size.width, 0.0)];
        return size.height;
    }
    return 0;
}

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

- (void)loadMoreData {
    
    [self loadDataIsHeader:NO];
}
- (void)refreshData {
    
    [self loadDataIsHeader:YES];
}

//刷新数据和加载数据
- (void)loadDataIsHeader:(BOOL)isHeader {
    
    __weak typeof (self) weakSelf = self;
    [weakSelf.thePartyTraceModel trackQueryIsHeader:isHeader success:^(InteractionCenterThePartyTraceModel *result) {
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (result) {
            [SKHUDManager hideAlert];
            weakSelf.thePartyTraceModel = result;
            [weakSelf.tableView reloadData];
            if (weakSelf.thePartyTraceModel.totalPage > weakSelf.thePartyTraceModel.pageNo) {
                weakSelf.tableView.mj_footer.hidden = NO;
            } else {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            if (weakSelf.thePartyTraceModel.totalArray.count > 0) {
                weakSelf.placeholderView.hidden = YES;
            } else {
                weakSelf.placeholderView.hidden = NO;
            }
        }
    } failed:^(id error) {
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
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
