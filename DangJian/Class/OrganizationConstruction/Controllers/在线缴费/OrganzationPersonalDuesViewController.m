//
//  OrganzationPersonalDuesViewController.m
//  DangJian
//
//  Created by Sakya on 2017/6/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganzationPersonalDuesViewController.h"
#import "OrganizationPatCostListCell.h"

@interface OrganzationPersonalDuesViewController ()<OrganizationPatCostListCellDelegate>

@end

@implementation OrganzationPersonalDuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNotification];
}
- (void)addNotification {
    
    [MyNotification addObserver:self selector:@selector(costPaySuccess:) name:NOTIFICATIONCOSTPAYSUCCESS object:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"DuesRecordCell";
    DuesVo *duesVo;
    if (self.duesVo.totalArray.count > indexPath.row) {
        duesVo = self.duesVo.totalArray[indexPath.row];
    }
    OrganizationPatCostListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrganizationPatCostListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.duesVo = duesVo;
    cell.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 145;
}


#pragma mark --OrganizationPatCostListCellDelegate
- (void)payCostListCellDuesVo:(DuesVo *)duesVo {
    //只有缴费进入的才能点击进入
    if (self.isPayCost) {
        
        if ([duesVo.payment doubleValue] <= 0) {
            [SKHUDManager showBriefAlert:@"没有待缴费用，不需要支付"];
            return;
        }
        OrganizationOnlinePaymentViewController *paymentView = [[OrganizationOnlinePaymentViewController alloc] init];
        paymentView.duesVo = duesVo;
        //如果是代办事项进入的
        paymentView.backlogId = _backlogId;
        [self.navigationController pushViewController:paymentView animated:YES];
    }
    
}
//        支付完成刷新页面
- (void)costPaySuccess:(NSNotification *)sender {
    
    [self tableViewDidTriggerHeaderRefresh];

}
- (void)dealloc {
    
    [MyNotification removeObserver:self name:NOTIFICATIONCOSTPAYSUCCESS object:nil];
    [MyNotification removeObserver:self];
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
