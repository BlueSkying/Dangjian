//
//  OrganizationStructureViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationStructureViewController.h"
#import "OrganizationMemberInfoViewController.h"
#import "OrganizationArchCollectionCell.h"
#import "OrganizationArchSingleCell.h"

@interface OrganizationStructureViewController ()<UITableViewDelegate,UITableViewDataSource,OrganizationArchCollectionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrganizationalStructureVo *organizationVo;

@end

@implementation OrganizationStructureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self getData];

}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"组织架构";
}
- (void)getData {
    
    //获取组织架构详细信息
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    [OrganizationalStructureVo organizationListSuccess:^(OrganizationalStructureVo *result) {
        if (result) {
            [SKHUDManager hideAlert];
            weakSelf.organizationVo = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
}

#pragma mark -- tableViewDelegate tableViewDetaSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ||
        indexPath.section == 1) {
        OrganizationalStructureVo *relationVo;
        if (indexPath.section == 0) {
            
            relationVo = self.organizationVo;
        } else {
            if (self.organizationVo.childrenVo.count > 0) {
                relationVo = self.organizationVo.childrenVo.firstObject;
            }
        }
        static NSString *ID = @"OrganizationArchSingleCell";
        OrganizationArchSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[OrganizationArchSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.titleLabel.text = relationVo.name;
        return cell;
    }
    static NSString *ID = @"OrganizationArchCollectionCell";
    OrganizationArchCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrganizationArchCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.organizationVo.childrenVo.count > 0 &&
        ((OrganizationalStructureVo *)self.organizationVo.childrenVo.firstObject).childrenVo.count > 0) {
        NSArray *memberArray = ((OrganizationalStructureVo *)self.organizationVo.childrenVo.firstObject).childrenVo;
        cell.memberArray = memberArray;
    }
    cell.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) return 90;
    return 370;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationalStructureVo *relationVo;
    if (indexPath.section == 2) return;
    if (indexPath.section == 0) {
        relationVo = self.organizationVo;
    } else {
        if (self.organizationVo.childrenVo.count > 0) {
            relationVo = self.organizationVo.childrenVo.firstObject;
        }
    }
    OrganizationMemberInfoViewController *statiscalView = [[OrganizationMemberInfoViewController alloc] init];
    OrganizationalStructureVo *organizationInfoVo = [OrganizationalStructureVo new];
    if (indexPath.section == 0) {
        organizationInfoVo.locationHierarchy = OrganizationLocationHierarchyGroup;
    } else if (indexPath.section == 1) {
        organizationInfoVo.locationHierarchy = OrganizationLocationHierarchyMeeting;
        organizationInfoVo.changeDate = relationVo.changeDate;
    }
    organizationInfoVo.orgLevel = relationVo.orgLevel;
    organizationInfoVo.orgId = relationVo.orgId;
    organizationInfoVo.name = relationVo.name;

    statiscalView.organizationInfoVo = organizationInfoVo;
    [self.navigationController pushViewController:statiscalView animated:YES];
    
}
#pragma mark - OrganizationArchCollectionCellDelegate
- (void)archCollectionCellSelectedIndexPath:(NSIndexPath *)indexPath {
   
    OrganizationalStructureVo *relationVo;
    if (self.organizationVo.childrenVo.count > 0) {
        NSArray *memberArray = ((OrganizationalStructureVo *)self.organizationVo.childrenVo.firstObject).childrenVo;
        if (memberArray.count > indexPath.row) {
            relationVo = memberArray[indexPath.row];
        }
    }
    OrganizationalStructureVo *organizationInfoVo = [OrganizationalStructureVo new];
    OrganizationMemberInfoViewController *statiscalView = [[OrganizationMemberInfoViewController alloc] init];
    organizationInfoVo.orgId = relationVo.orgId;
    organizationInfoVo.changeDate = relationVo.changeDate;
    organizationInfoVo.locationHierarchy = OrganizationLocationHierarchyBranch;
    organizationInfoVo.orgLevel = relationVo.orgLevel;
    organizationInfoVo.name = relationVo.name;

    statiscalView.organizationInfoVo = organizationInfoVo;
    [self.navigationController pushViewController:statiscalView animated:YES];

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
