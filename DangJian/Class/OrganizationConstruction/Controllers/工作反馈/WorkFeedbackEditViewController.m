//
//  WorkFeedbackEditViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "WorkFeedbackEditViewController.h"
#import "PublickTextViewCell.h"
#import "CCDatePickerView.h"
#import "OrganizationJobFeedbackModel.h"
#import "OrganizationJobFeedbackUploadPictureCell.h"
#import "OrganizationJobFeedbackDescribeCell.h"

@interface WorkFeedbackEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,PublickTextViewCellDelegate,OrganizationJobFeedbackDescribeCellDelegate,JobFeedbackUploadPictureCellDelegate>

/**
 保存上传的参数
 */
@property (nonatomic, strong) NSMutableDictionary *submitDictionary;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JobFeedbackCommitModel *commitModel;

@end

@implementation WorkFeedbackEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
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
- (JobFeedbackCommitModel *)commitModel {
    if (!_commitModel) {
        _commitModel = [JobFeedbackCommitModel new];
    }
    return _commitModel;
}
- (NSMutableDictionary *)submitDictionary {
    if (!_submitDictionary) {
    
        _submitDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _submitDictionary;
}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"新增工作展示";
    [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];

}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //根据是否选择第二张图片来判断是否显示第二张图片的描述
    if (section == 0) {
        if (self.commitModel.images.count > 1) return 3;
        return 2;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

//    选择图片风格的cell
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        
        static NSString * identifer = @"OrganizationJobFeedbackUploadPictureCell";
        OrganizationJobFeedbackUploadPictureCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell=[[OrganizationJobFeedbackUploadPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.configParams = self.commitModel.dataArray[indexPath.section][indexPath.row];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1 &&
               indexPath.row == 2) {
//        输入反馈内容的cell
        static NSString * identifer = @"OrganizationJobFeedbackDescribeCell";
        OrganizationJobFeedbackDescribeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell=[[OrganizationJobFeedbackDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            cell.delegate=self;
        }
        cell.tableView=_tableView;
        cell.configParams = self.commitModel.dataArray[indexPath.section][indexPath.row];
        cell.contentStr = self.submitDictionary[@"content"];
        cell.canEdit = YES;
        return cell;
    }
//    剩余简略信息的cell
    static NSString * identifer = @"PublickTextViewCell";
    PublickTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[PublickTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate=self;
    }
    cell.canEdit = YES;
    cell.tableView=_tableView;
    cell.configParams = self.commitModel.dataArray[indexPath.section][indexPath.row];
    NSString *content;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            content = self.submitDictionary[@"desc1"];

        } else if (indexPath.row == 2) {
            content = self.submitDictionary[@"desc2"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.canEdit = NO;
            content = self.submitDictionary[@"activityDate"];
            
        } else if (indexPath.row == 1) {
            content = self.submitDictionary[@"subject"];
        } 
    }
    cell.contentStr = content;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return 90;
    } else if (indexPath.section == 1 &&
               indexPath.row == 2) {
        OrganizationJobFeedbackDescribeCell * cell = (OrganizationJobFeedbackDescribeCell *)[tableView.dataSource tableView:_tableView cellForRowAtIndexPath:indexPath];
        CGFloat cellHeight = [cell CellHeight];
        if (cellHeight < 50)  return 50 + 30;
        return cellHeight + 30;
    }
    PublickTextViewCell * cell = (PublickTextViewCell *)[tableView.dataSource tableView:_tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [cell CellHeight];
    if (cellHeight < 44)  return 44;
    return cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        CCDatePickerView *dateView=[[CCDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:dateView];
        dateView.blcok = ^(NSDate *dateString){
            DDLogInfo(@"年 = %ld  月 = %ld  日 = %ld  时 = %ld  分 = %ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,(long)dateString.hour,(long)dateString.minute);
            NSString *datestr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,(long)dateString.hour,(long)dateString.minute];
            [Helper setObject:datestr forKey:@"activityDate" inDic:weakSelf.submitDictionary];
            [weakSelf.tableView reloadData];
        };
        dateView.chooseTimeLabel.text = @"选择时间";
        [dateView fadeIn];
    }
    
}

#pragma mark - PublickTextViewCellDelegate
- (void)updatedText:(NSString *)text submitkey:(NSString *)submitkey {
    
    [Helper setObject:text forKey:submitkey inDic:self.submitDictionary];
}
- (void)feedbackDescribeUpdatedText:(NSString *)text submitkey:(NSString *)submitkey {
    
    [Helper setObject:text forKey:submitkey inDic:self.submitDictionary];
}
#pragma mark - JobFeedbackUploadPictureCellDelegate
- (void)uploadPictureSelectSuccessImages:(NSMutableArray *)images
                               itemIndex:(NSUInteger)itemIndex {
    
    self.commitModel.images = [NSMutableArray arrayWithArray:images];
    if (images.count == 1) {
        [Helper setObject:nil forKey:@"desc2" inDic:self.submitDictionary];
    }
    [_tableView reloadData];
}
- (void)uploadPictureDeleteImages:(NSMutableArray *)images itemIndex:(NSUInteger)itemIndex {
    
    self.commitModel.images = [NSMutableArray arrayWithArray:images];
    if (itemIndex == 0) {
        NSString *desc2 = [self.submitDictionary objectForKey:@"desc2"];
        [Helper setUnObject:desc2 forUnKey:@"desc1" inDictionary:self.submitDictionary];
        [Helper setUnObject:nil forUnKey:@"desc2" inDictionary:self.submitDictionary];

    } else if (itemIndex == 1){
        [Helper setUnObject:nil forUnKey:@"desc2" inDictionary:self.submitDictionary];
    }
    [_tableView reloadData];
}
#pragma mark - action
//提交
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    DDLogInfo(@"%@",self.submitDictionary);
    if (![self checkSubmitParams]) return;
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager jobFeedbackSubmitParams:self.submitDictionary images:self.commitModel.images success:^(id result) {
        
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"提交成功"];
             weakSelf.addReportFeedvackSuccessBlock ? weakSelf.addReportFeedvackSuccessBlock(): nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)checkSubmitParams {

    if (self.commitModel.images.count == 0) {
        [SKHUDManager showBriefAlert:@"请上传活动图片"];
        return NO;
    }
    if (self.commitModel.images.count > 0) {
        NSString *desc1 = [self.submitDictionary objectForKey:@"desc1"];
        if (!desc1 ||
            [desc1 isEqualToString:@""]) {
            [SKHUDManager showBriefAlert:@"请输入图片一描述"];
            return NO;
        }
        if (desc1.length > 255){
            [SKHUDManager showBriefAlert:@"图片一描述文字过长，请输入255字以内"];
            return NO;
        }
        if (self.commitModel.images.count == 2) {
            
            NSString *desc2 = [self.submitDictionary objectForKey:@"desc2"];
            if (!desc2 ||
                [desc2 isEqualToString:@""]) {
                [SKHUDManager showBriefAlert:@"请输入图片二描述"];
                return NO;
            }
            if (desc2.length > 255){
                [SKHUDManager showBriefAlert:@"图片二描述文字过长，请输入255字以内"];
                return NO;
            }
        }
    }
 
    
    NSString *activityDate = [self.submitDictionary objectForKey:@"activityDate"];
    if (!activityDate ||
        [activityDate isEqualToString:@""]){
        [SKHUDManager showBriefAlert:@"请选择活动时间"];
        return NO;
    }
    NSString *subject = [self.submitDictionary objectForKey:@"subject"];
    if (!subject ||
        [subject isEqualToString:@""]){
        [SKHUDManager showBriefAlert:@"请输入活动主题"];
        return NO;
    }
    if (subject.length > 50){
        [SKHUDManager showBriefAlert:@"活动主题文字过长，请输入50字以内"];
        return NO;
    }

    
    NSString *content = [self.submitDictionary objectForKey:@"content"];
    if (!content ||
        [content isEqualToString:@""]){
        [SKHUDManager showBriefAlert:@"请输入活动详细描述"];
        return NO;
    }
    if (content.length > 1000){
        [SKHUDManager showBriefAlert:@"活动详细描述文字过长，请输入1000字以内"];
        return NO;
    }
    if (_backlogId && _backlogId.length > 0) {
        [Helper setObject:_backlogId forKey:@"backlogId" inDic:self.submitDictionary];
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
