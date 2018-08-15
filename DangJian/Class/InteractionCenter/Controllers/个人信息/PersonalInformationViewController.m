//
//  PersonalInformationViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PersonalInformationModifyCell.h"
#import "PersonalModifyNameViewController.h"
#import "TZImagePickerController.h"
#import "SKActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "InteractionCenterHomeModel.h"


//相册，拍照
typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface PersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) UITableView *tableView;
//
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableDictionary *personalInfoDict;


@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    [self setUpNavItemTitle:@"个人信息"];
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];

}
#pragma mark - loadLazy
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray =
        @[@{@"title":@"头像",
            @"className":@"PictureLookEditViewController"},
          @{@"title":@"昵称",
            @"className":@"PersonalModifyNameViewController"}];
    }
    return _titleArray;
}
- (NSMutableDictionary *)personalInfoDict {
    if (!_personalInfoDict) {
       
        _personalInfoDict = [NSMutableDictionary dictionaryWithCapacity:0];
        UserInformationVo *user = [UserOperation shareInstance].user;
        [Helper setObject:user.nickname forKey:@"nickName" inDic:self.personalInfoDict];
        [Helper setObject:user.image forKey:@"image" inDic:self.personalInfoDict];
    }
    return _personalInfoDict;
}

#pragma mark - tabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *ID = @"INFORMATIONID";
    PersonalInformationModifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[PersonalInformationModifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
        cell.type = PersonalModifyHeaderCellType;
        if ([self.personalInfoDict.allKeys containsObject:@"image"]) {
            cell.imageParams = self.personalInfoDict;
        }
    } else if (indexPath.section == 1) {
        cell.type = PersonalModifyNameCellType;
        cell.contentText = self.personalInfoDict[@"nickName"];
    }
    cell.configParams = self.titleArray[indexPath.section];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return SKXFrom6(64);
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
    
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        
        SKActionSheet *actionSheetView = [[SKActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册"] AttachTitle:nil];
        actionSheetView.ButtonIndex = ^(NSInteger buttonIndex){
            
            switch (buttonIndex)
            {
                case 1:
                    //           拍照
                    [self chosePhoto:ChosePhontTypeCamera];
                    
                    break;
                case 2:  //打开相册拍照
                    [self chosePhoto:ChosePhontTypeAlbum];
                    
                    break;
            }
            
            
        };
        
    } else if (indexPath.section == 1) {
        
        PersonalModifyNameViewController *modifyNameView = [[PersonalModifyNameViewController alloc] init];
        modifyNameView.nickName = [self.personalInfoDict objectForKey:@"nickName"];
        modifyNameView.modifyNickNameBlock = ^(NSString *nickName){
            
            DDLogInfo(@"%@",nickName);
            [Helper setObject:nickName forKey:@"nickName" inDic:weakSelf.personalInfoDict];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:modifyNameView animated:YES];
    }
  
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
    //    NSMutableArray *selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    if (selectedPhotos.count > 0) {
        UIImage *selectImage = [selectedPhotos firstObject];
        [self updateHeadImage:selectImage];
    }
    
    
}

- (void)updateHeadImage:(UIImage *)image {
    
    /**
     [SKHUDManager showLoading];
     NSArray *imageArray = @[image];
     __weak typeof(self) weakSelf = self;
     [InteractionCenterHomeModel userInformationModifyImages:imageArray success:^(UserInformationVo *result) {
     if (result) {
     [SKHUDManager showBriefAlert:@"修改成功"];
     [UserOperation shareInstance].user = result;
     [Helper setObject:result.image forKey:@"image" inDic:weakSelf.personalInfoDict];
     [weakSelf.tableView reloadData];
     //通知 用户信息改变
     [MyNotification postNotificationName:NotificationUserInformationChange object:nil];
     }
     }];
     */
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
