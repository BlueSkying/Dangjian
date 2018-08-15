//
//  OrganizationOnlinePaymentViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationOnlinePaymentViewController.h"
#import "OrganizationPaymentModeCell.h"
#import "OrganizationPaymentInfoCell.h"
#import "PayManager.h"
#import "SKPlaceholderView.h"

@interface OrganizationOnlinePaymentViewController ()<UITableViewDelegate,UITableViewDataSource,OrganizationPaymentChannelCellDelegate,
PayApiManagerDelegate,SKPlaceholderViewDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PaymentDetailsModel *paymentModel;

@property (nonatomic, strong) SKPlaceholderView *placeholderView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation OrganizationOnlinePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
    [self initData];
    [PayManager sharedManager].delegate = self;

}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"缴费详情";
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    _tableView.tableFooterView = footerView;
    UIButton *confirmPaymentButton = [SKBuildKit buttonTitle:@"确认支付" backgroundColor:Color_system_red titleColor:[UIColor whiteColor] font:FONT_17 cornerRadius:ControlsCornerRadius superview:footerView];
    confirmPaymentButton.frame = CGRectMake(15, 20, kScreen_Width - 30, 45);
    [confirmPaymentButton addTarget:self action:@selector(confirmPaymentSelected) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmPaymentButton];

}
- (void)initData {
    
    self.paymentModel.paymentChannel = PaymentModeWeChat;
    
}
- (SKPlaceholderView *)placeholderView {
    if (!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, CGRectGetHeight(_tableView.frame)) placeholderType:SKPlaceholderViewDefaultType];
        _placeholderView.delegate = self;
        _placeholderView.titleText = @"缴费成功";
        _placeholderView.imageName = @"organization_paySuccess_icon";
        [self.view addSubview:_placeholderView];
    }
    return _placeholderView;
}
#pragma mark - getter
- (PaymentDetailsModel *)paymentModel {
    if (!_paymentModel) {
        _paymentModel = [PaymentDetailsModel new];
    }
    return _paymentModel;
}
- (NSArray *)dataArray {
    if (!_dataArray) {
        
        /**
        //获取当前年月
        // 获取代表公历的NSCalendar对象
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        unsigned unitFlags = NSCalendarUnitYear |
        kCFCalendarUnitMonth;
        // 获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags
                                              fromDate:dt];
        // 获取各时间字段的数值
        NSString *nowYear = [NSString stringWithFormat:@"%ld年%ld月",(long)comp.year,(long)comp.month];
         */
        UserInformationVo *user = [UserOperation shareInstance].user;
        NSString *phone = user.account;
        NSString *toBePaidAmount = [NSString stringWithFormat:@"%@元",_duesVo.payment ? _duesVo.payment : @"0.00"];
        
        NSArray *dataArray = @[_duesVo.year,
                               toBePaidAmount,
                               user.nickname ? user.nickname : phone,
                               phone];
        _dataArray = dataArray;
    }
    return _dataArray;
}

#pragma mark - tableViewDelegate tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 4;
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        static NSString *ID = @"OrganizationPaymentInfoCell";
        OrganizationPaymentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[OrganizationPaymentInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.titleLabel.text = self.paymentModel.titleArray[indexPath.row];
        cell.contentLabel.text = self.dataArray[indexPath.row];
        
        return cell;
    }
    static NSString *ID = @"OrganizationPaymentModeCell";
    OrganizationPaymentModeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrganizationPaymentModeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)return 48;
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return ({
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = SystemGrayBackgroundColor;
        headerView;
    });
}
#pragma mark - action
//支付
- (void)confirmPaymentSelected {
    
    [SKHUDManager showLoading];
 
    PaymentChannelMode channelMode = self.paymentModel.paymentChannel;
//    借口请求支付信息
    [PaymentDetailsModel payCostOrderId:_duesVo.listId payChannel:channelMode backlogId:_backlogId success:^(NSString *result) {
        [SKHUDManager hideAlert];
        if (result) {
            [[PayManager sharedManager] payChannel:channelMode payOrderString:result];
        }
    }];
}
#pragma mark - skplaceholderdelegate
- (void)placeholderViewButtonActionDetected:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- paymanagerdelegate
//支付结果的回调
- (void)managerDidRecvPayState:(BOOL)state result:(NSString *)result {
    

    //      支付成功需要调用接口来处理支付回调
    if (state) {

        self.placeholderView.hidden = NO;
        //支付成功的通知
        [MyNotification postNotificationName:NOTIFICATIONCOSTPAYSUCCESS object:nil];
    } else {
//        支付失败提示
        [SKHUDManager showBriefAlert:result];
    }

}


#pragma mark - OrganizationPaymentChannelCellDelegate
//选择支付方式
- (void)paymentChannelSelected:(UIButton *)sender {
    
    DDLogInfo(@"%ld",(long)sender.tag);
    if (sender.tag == 1000) {
        self.paymentModel.paymentChannel = PaymentModeAlipay;
        
    } else {
        self.paymentModel.paymentChannel = PaymentModeWeChat;
    }
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
