//
//  MemberInformationViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MemberInformationViewController.h"
#import "PersonalInformationModifyCell.h"
#import "SKPopupView.h"
#import "PersonalModifyNameViewController.h"
#import "TZImagePickerController.h"
#import "SKActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "PersonalModifyNameViewController.h"
#import "InteractionCenterHomeModel.h"
#import "MemberEditTextFieldCell.h"
#import "MemberIndividualInfoEditViewController.h"
//相册，拍照
typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface MemberInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,SKPopupViewDelegate,MemberEditTextFieldCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
//初始化数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MemberInformationVo *memberInformation;
/**
 上传的参数
 */
@property (nonatomic, strong) NSMutableDictionary *commitParameters;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/**
 修改信息的弹框
 */
@property (nonatomic, strong) SKPopupView *popupView;

@end

@implementation MemberInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationBar];
    [self initCustomView];

}
- (void)setUpNavigationBar {
    
    [self setUpNavItemTitle:@"党员信息"];
    [self setNavigationRightBarButtonWithtitle:@"提交" titleColor:[UIColor whiteColor]];
    
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];
    
}


#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = self.memberInformation.dataArray;
    }
    return _dataArray;
}
- (MemberInformationVo *)memberInformation {
    if (!_memberInformation) {
        _memberInformation = [MemberInformationVo new];
    }
    return _memberInformation;
}
- (NSMutableDictionary *)commitParameters {
    if (!_commitParameters) {
        _commitParameters = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _commitParameters;
}
- (SKPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[SKPopupView alloc] initWithTitle:@"姓名" type:SKPopupViewDatePickViewType withInputString:nil selectArray:nil];
        _popupView.delegate = self;
    }
    return _popupView;
}
#pragma mark - tabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count > section) {
        return ((NSArray *)self.dataArray[section]).count;
    }
    return 0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellCustomVo *cellCustomVo;
    if (self.dataArray.count > indexPath.section &&
        ((NSArray *)self.dataArray[indexPath.section]).count > indexPath.row) {
        cellCustomVo = self.dataArray[indexPath.section][indexPath.row];
    }
    
//    更换头像
    if (indexPath.section == 0) {
        static NSString *cellID = @"INFORMATIONID";
        PersonalInformationModifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            
            cell = [[PersonalInformationModifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.section == 0) {
            cell.type = PersonalModifyHeaderCellType;
        }
        cell.customVo = cellCustomVo;
        return cell;
    } else {
//        文字信息
        static NSString *ID = @"TextFieldID";
        MemberEditTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            
            cell = [[MemberEditTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.indexPath = indexPath;
        cell.customVo = cellCustomVo;
        cell.delegate = self;
        return cell;
    }
}
#pragma mark -- tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return SKXFrom6(66);
    return SKXFrom6(45);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SKXFrom6(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = SystemGrayBackgroundColor;
        headerView;
    });
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    //针对不同的cell定制不同的任务
    CellCustomVo *cellCustomVo;
    if (self.dataArray.count > indexPath.section &&
        ((NSArray *)self.dataArray[indexPath.section]).count > indexPath.row) {
        
        cellCustomVo = self.dataArray[indexPath.section][indexPath.row];
    }
    self.popupView.indexPath = indexPath;
    self.popupView.key = cellCustomVo.key;

    
    if ([cellCustomVo.action isEqualToString:@"image"]) {
        //修改头像
        [self chosePhotoAction];
        
    } else  if ([cellCustomVo.action isEqualToString:@"sex"]) {
    
        [self.popupView initAlertTitle:cellCustomVo.title type:SKPopupViewPickerDefaultType animation:YES withInputString:cellCustomVo.content selectArray:@[@"男",@"女"]];
        [self.popupView sk_show];
        
    } else  if ([cellCustomVo.action isEqualToString:@"education"]) {
        
        [self.popupView initAlertTitle:cellCustomVo.title type:SKPopupViewPickerDefaultType animation:YES withInputString:cellCustomVo.content selectArray:@[@"小学",@"初中",@"高中",@"中专",@"大专",@"本科",@"硕士",@"博士"]];
        [self.popupView sk_show];
        
    } else  if ([cellCustomVo.action isEqualToString:@"birth"] ||
                [cellCustomVo.action isEqualToString:@"partyTime"]) {
        
        [self.popupView initAlertTitle:cellCustomVo.title type:SKPopupViewDatePickViewType animation:YES withInputString:cellCustomVo.content selectArray:nil];
        [self.popupView sk_show];
        
    } else if ([cellCustomVo.key isEqualToString:@"train"] ||
               [cellCustomVo.key isEqualToString:@"award"] ||
               [cellCustomVo.key isEqualToString:@"punishment"]){
        
        //填写
        __weak typeof(self) weakSelf = self;
        MemberIndividualInfoEditViewController *infoEditView = [[MemberIndividualInfoEditViewController alloc] init];
        infoEditView.memberCustomVo = cellCustomVo;
        infoEditView.memberInfoEditBlock = ^(CellCustomVo *customVo) {
            if (weakSelf.dataArray.count > indexPath.section &&
                ((NSArray *)weakSelf.dataArray[indexPath.section]).count > indexPath.row) {
                ((CellCustomVo *)weakSelf.dataArray[indexPath.section][indexPath.row]).content = customVo.content;
            }
            [Helper setObject:customVo.content forKey:customVo.key inDic:weakSelf.commitParameters];
        };
        
        [self.navigationController pushViewController:infoEditView animated:YES];
    }
    //-- *************修改需求重新修改*****--//
    /**
    else  if ([cellCustomVo.action isEqualToString:@"sex"]) {
        //修改性别
        
        [self.alterView initAlertTitle:cellCustomVo.title type:SKPromptCustomPickerDefaultType animation:YES withInputString:nil selectArray:@[@"男",@"女"]];
        [self.alterView sk_show];
        
    } else {
        
        [self.alterView initAlertTitle:cellCustomVo.title type:cellCustomVo.alterStyle animation:YES withInputString:cellCustomVo.content selectArray:nil];
        self.alterView.placeholder = cellCustomVo.placeholder;
        self.alterView.promptNavBarType = cellCustomVo.alterNavBarType;
        [self.alterView sk_show];
    }
   */
}
#pragma mark -- textFieldCellDelegate
- (void)textFieldCellChangeText:(NSString *)content key:(NSString *)key indexPath:(NSIndexPath *)indexPath  {
    
    if (self.dataArray.count > indexPath.section &&
        ((NSArray *)self.dataArray[indexPath.section]).count > indexPath.row) {
        ((CellCustomVo *)self.dataArray[indexPath.section][indexPath.row]).content = content;
    }
    [Helper setObject:content forKey:key inDic:self.commitParameters];
}
#pragma mark -- SKPopupViewDelegate
- (void)sk_alterViewPutputKey:(NSString *)key content:(NSString *)content indexPath:(NSIndexPath *)indexPath {

    if (self.dataArray.count > indexPath.section &&
        ((NSArray *)self.dataArray[indexPath.section]).count > indexPath.row) {
        
        ((CellCustomVo *)self.dataArray[indexPath.section][indexPath.row]).content = content;
    }
    [Helper setObject:content forKey:key inDic:self.commitParameters];
    [_tableView reloadData];

}
#pragma mark -- SLAlterViewDelegate
   //-- *************修改需求重新修改*****--//
/**
- (void)sk_alterNavBarClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    
    CellCustomVo *cellCustomVo;
    
    //计算对应的下标
    NSInteger sectionIndex = 0;
    NSInteger rowIndex = 0;
    
    //向右移动计算下标
    if (sender.tag == 0) {
        
        if (indexPath.row - 1 > -1) {
            sectionIndex = indexPath.section;
            rowIndex = indexPath.row - 1;
        } else {
            sectionIndex = indexPath.section - 1;
            rowIndex = ((NSArray *)self.dataArray[sectionIndex]).count - 1;
        }
        
        
    } else if (sender.tag == 1) {
        //        向左移动计算下标
        if (indexPath.row + 1 < ((NSArray *)self.dataArray[indexPath.section]).count) {
            sectionIndex = indexPath.section;
            rowIndex = indexPath.row + 1;
        } else {
            
            sectionIndex = indexPath.section + 1;
            rowIndex = 0;
        }
    }
    
    if (self.dataArray.count > sectionIndex &&
        ((NSArray *)self.dataArray[sectionIndex]).count > rowIndex) {
        cellCustomVo = self.dataArray[sectionIndex][rowIndex];
    }
  

    self.alterView.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    if ([cellCustomVo.action isEqualToString:@"sex"]) {
        //修改性别
        
        [self.alterView initAlertTitle:cellCustomVo.title type:SKPromptCustomPickerDefaultType animation:YES withInputString:nil selectArray:@[@"男",@"女"]];
        
    } else {
        
        [self.alterView initAlertTitle:cellCustomVo.title type:cellCustomVo.alterStyle animation:YES withInputString:cellCustomVo.content selectArray:nil];
        self.alterView.placeholder = cellCustomVo.placeholder;
        self.alterView.promptNavBarType = cellCustomVo.alterNavBarType;
    }
    
}
*/

#pragma mark - notification
 /**
//监听textfield的变化
- (void)textFieldDidChanged:(NSNotification *)noti{
    // 数据源赋值
    UITextField *textField=noti.object;
    NSString *fillInText = textField.text;
    NSIndexPath *indexPath = textField.indexPath;
    CellCustomVo *cellCustomVo;
    
    //如果文字大于10个就截取
    if (fillInText.length > 10) {
        [SKHUDManager showBriefAlert:@"最多输入10个字"];
        textField.text = [fillInText substringToIndex:10];
    } else {
//        获取文字进行赋值
        if (self.dataArray.count > indexPath.section &&
            ((NSArray *)self.dataArray[indexPath.section]).count > indexPath.row) {
            
            ((CellCustomVo *)self.dataArray[indexPath.section][indexPath.row]).content = fillInText;
            cellCustomVo = self.dataArray[indexPath.section][indexPath.row];
        }
        [Helper setObject:cellCustomVo.content forKey:cellCustomVo.content inDic:self.commitParameters];
    }
  
}
 */
#pragma mark -- commit  提交党员信息
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
//    信息监测        
    //提交个人信息
    [SKHUDManager showLoadingText:@"提交中..."];
    NSString *education = [self.commitParameters objectForKey:@"education"];
    if (education && education.length > 0) {
        [Helper setObject:[MemberInformationVo checkIsCommit:YES text:education] forKey:@"education" inDic:self.commitParameters];
    }
    [InteractionCenterHomeModel userInfomationCommitParamters:self.commitParameters success:^(UserInformationVo *result) {
        if (result) {
            [SKHUDManager showBriefAlert:@"修改成功"];
            [MyNotification postNotificationName:NotificationUserInformationChange object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(id error) {
        
    }];
}

#pragma mark -- action
//选择图片
- (void)chosePhotoAction {
    
    SKActionSheet *actionSheetView = [[SKActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册"] AttachTitle:nil];
    actionSheetView.ButtonIndex = ^(NSInteger buttonIndex){
        
        switch (buttonIndex) {
            case 1:
                //           拍照
                [self chosePhoto:ChosePhontTypeCamera];
                
                break;
            case 2:  //打开相册拍照
                [self chosePhoto:ChosePhontTypeAlbum];
                
                break;
        }
    };
}
- (void)chosePhoto:(ChosePhontType)type {
    
    
    if (type == ChosePhontTypeAlbum) {
        
        [self pushImagePickerController];
        
    } else if (type == ChosePhontTypeCamera) {
        
        UIImagePickerController *piker = [[UIImagePickerController alloc] init];
        piker.delegate = self;
        piker.allowsEditing=YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        }else{
            return;
        }
        [self presentViewController:piker animated:YES completion:^{
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate 选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    //选取照片
    [self updateHeadImage:image];
}
#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.delegate =self;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.needCircleCrop = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma  mark -TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
   
    NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //相册选取照片
    if (selectedPhotos.count > 0) {
        UIImage *selectImage = [selectedPhotos firstObject];
        [self updateHeadImage:selectImage];
    }
}

- (void)updateHeadImage:(UIImage *)image {

    //保存头像信息
    ((CellCustomVo *)self.dataArray[0][0]).content = image;
    [Helper setObject:image forKey:@"image" inDic:self.commitParameters];
    [_tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}
- (void)dealloc{
    

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
