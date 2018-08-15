//
//  ThoughtReportsEditViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ThoughtReportsEditViewController.h"
#import "PublickTextViewCell.h"

@interface ThoughtReportsEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,PublickTextViewCellDelegate>{
    
    UITableView * _tableView;
}

@property (nonatomic, strong) NSArray *paramArray;

/**
 保存上传的参数
 */
@property (nonatomic, strong) NSMutableDictionary *submitDictionary;

@end

@implementation ThoughtReportsEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initData];
    [self initCustomView];
    
}
- (void)initCustomView {
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
//初始化数据
- (void)initData {
    _paramArray = @[@{@"title":@"汇报主题:",
                      @"placeholder":@"请输入汇报主题",
                      @"submitKey":@"subject"},
                    @{@"title":@"汇报内容:",
                      @"placeholder":@"请输入汇报内容（1000字以内）",
                      @"submitKey":@"content"}];
}
- (NSMutableDictionary *)submitDictionary {
    if (!_submitDictionary) {
        _submitDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [Helper setObject:self.reportFeedbackVo.subject forKey:@"subject" inDic:_submitDictionary];
        [Helper setObject:self.reportFeedbackVo.content forKey:@"content" inDic:_submitDictionary];
    }
    return _submitDictionary;
}

- (void)setUpNavigationBar {
    self.navigationItem.title = @"思想汇报";
    if (_isEdit) {
        [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _paramArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifer = @"cellIdentifier";
    PublickTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[PublickTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate=self;
    }
    cell.indexPath = indexPath;
    cell.tableView = _tableView;
    cell.configParams = _paramArray[indexPath.section];
    if (!_isEdit) {
        cell.userInteractionEnabled = NO;
    }
    if (indexPath.section == 0) {
        cell.keyType = UIReturnKeyDone;
        cell.contentStr = self.submitDictionary[@"subject"];
    } else if (indexPath.section == 1) {
        cell.keyType = UIReturnKeyDefault;
        cell.contentStr = self.submitDictionary[@"content"];
    }
    return cell;
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    PublickTextViewCell * cell = (PublickTextViewCell *)[tableView.dataSource tableView:_tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [cell CellHeight];
    if (cellHeight<44)  return 44;
    return cellHeight;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return SKXFrom6(10);
    return SKXFrom6(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - PublickTextViewCellDelegate
- (void)updatedText:(NSString *)text submitkey:(NSString *)submitkey {
    
    [Helper setObject:text forKey:submitkey inDic:self.submitDictionary];
}

#pragma mark - action
//提交
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    DDLogInfo(@"%@",self.submitDictionary);
    if (![self checkSubmitParams]) return;
    __weak typeof(self) weakSelf = self;
    [SKHUDManager showLoading];
    [InterfaceManager thoughtReportsSubmitSubject:[self.submitDictionary objectForKey:@"subject"] content:[self.submitDictionary objectForKey:@"content"] backlogId:_backlogId success:^(id result) {
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"提交成功"];
            weakSelf.addReportFeedvackSuccessBlock ? weakSelf.addReportFeedvackSuccessBlock(): nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)checkSubmitParams {
    
    NSString *subject = [self.submitDictionary objectForKey:@"subject"];
    if (!subject||
        [subject isEqualToString:@""]) {
        [SKHUDManager showBriefAlert:@"请输入汇报主题"];
        return NO;
    }
    if ([subject length] > 50) {
        [SKHUDManager showBriefAlert:@"汇报主题过长，请输入50字以内"];
        return NO;
    }
    NSString *content = [self.submitDictionary objectForKey:@"content"];
    if (!content||
        [content isEqualToString:@""]) {
        [SKHUDManager showBriefAlert:@"请输入汇报内容"];
        return NO;
    }
    if ([content length] > 1000) {
        [SKHUDManager showBriefAlert:@"汇报主题过长，请输入1000字以内"];
        return NO;
    }
    return YES;
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
