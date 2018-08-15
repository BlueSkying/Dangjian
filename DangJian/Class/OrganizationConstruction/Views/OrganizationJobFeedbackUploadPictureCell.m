//
//  OrganizationJobFeedbackUploadPictureCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackUploadPictureCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>
#import "SKActionSheet.h"
//相册，拍照
typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
//左侧title宽度
static CGFloat const CellLeftTitleWidth = 85;

#define CollectionCellHeight 90

@interface OrganizationJobFeedbackUploadPictureCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,TestDeleteCellDelegate> {
    
    UIScrollView *imageScrollView;
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
    UILabel *_titleLabel;
    // 添加图片的下标
    NSInteger _itemIndex;
}
@property (nonatomic, strong) UICollectionView *collectionView;  // pic adder

//保存图片信息数组可以是image 和Nsstring；
@property(nonatomic, strong)NSMutableArray *imageArray;
@property(nonatomic, strong)NSMutableDictionary *imageDict;


@end

@implementation OrganizationJobFeedbackUploadPictureCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCollectionView];
    }
    return self;
}
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}
- (NSMutableDictionary *)imageDict {
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _imageDict;
}
- (void)initCollectionView {
    
    _titleLabel=[[UILabel alloc] init];
    _titleLabel.textColor = Color_6;
    _titleLabel.font = FONT_16;
    [self.contentView addSubview:_titleLabel];
    __weak typeof(self) weakSelf = self;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.width.offset(SKXFrom6(CellLeftTitleWidth));
    }];
    
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = CollectionCellHeight;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SKXFrom6(CellLeftTitleWidth) + 15, 0, kScreen_Width - SKXFrom6(CellLeftTitleWidth) - 15 - 15, CollectionCellHeight) collectionViewLayout:_layout];  // 400
    CGFloat rgb = 255.0 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    //_collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.contentView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    //bottomline
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(15, CollectionCellHeight - 0.5, kScreen_Width - 15, 0.5);
    bottomLine.backgroundColor = SystemGraySeparatedLineColor.CGColor;
    [self.contentView.layer addSublayer:bottomLine];
}


#pragma mark UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.imageArray.count < 2) {
        
        return self.imageArray.count + 1;
    } else {
        
        return self.imageArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == self.imageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"organization_addPicture_icon"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.row = indexPath.row;
        [cell setDelegate:self];
        cell.deleteBtn.hidden = NO;
        if (self.imageArray[indexPath.row]&&[self.imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            [cell.imageView setImage:self.imageArray[indexPath.row]];
        }
    }
    
    return cell;
}
// 点击了图标或者点击了add
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.contentView endEditing:YES];
    [[Helper superViewControllerWithView:self].view endEditing:YES];
    _itemIndex = indexPath.row;
    [self selectAddPictureStyle];  // 点击增加或替换图片按钮
  
}
- (void)selectAddPictureStyle {
    
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
}
- (void)chosePhoto:(ChosePhontType)type {
    
    
    if (type == ChosePhontTypeAlbum) {
        
        [self pushImagePickerController];
        
    } else if (type == ChosePhontTypeCamera) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        }else{
            return;
        }
        [[Helper superViewControllerWithView:self] presentViewController:picker animated:YES completion:^{
        }];
    }
}
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    UIViewController *currentViewController = [Helper superViewControllerWithView:self];
    imagePickerVc.delegate =self;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.navigationBar.barTintColor = currentViewController.navigationController.navigationBar.barTintColor;
    imagePickerVc.navigationBar.tintColor = currentViewController.navigationController.navigationBar.tintColor;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.needCircleCrop = NO;
    [currentViewController presentViewController:imagePickerVc animated:YES completion:nil];
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
    if (self.imageArray.count > _itemIndex) {
        [self.imageArray replaceObjectAtIndex:_itemIndex withObject:image];
    } else {
        [self.imageArray addObject:image];
    }
    [self imageEditFinish];
    [_collectionView reloadData];
}
#pragma  mark -TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //    NSMutableArray *selectedAssets = [NSMutableArray arrayWithArray:assets];
    UIImage *selectImage = [selectedPhotos firstObject];
    if (self.imageArray.count > _itemIndex) {
        [self.imageArray replaceObjectAtIndex:_itemIndex withObject:selectImage];
    } else {
        [self.imageArray addObject:selectImage];
    }
    [self imageEditFinish];
    [_collectionView reloadData];
    
}

- (void)setConfigParams:(NSDictionary *)configParams {
    _configParams = configParams;
    _titleLabel.text = [configParams objectForKey:@"title"];
}

#pragma mark Click Event
// 删除按钮
- (void)clickToDeleteCellWithButton:(UIButton *)sender {
    
    if (self.imageArray.count > sender.tag) {
        [self.imageArray removeObjectAtIndex:sender.tag];
        if (_delegate && [_delegate respondsToSelector:@selector(uploadPictureDeleteImages:itemIndex:)]) {
            [_delegate uploadPictureDeleteImages:self.imageArray itemIndex:sender.tag];
        }
        
        
        [self.collectionView reloadData];
//        _layout.itemCount = self.imageArray.count;
//        [_collectionView performBatchUpdates:^{
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
//            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        } completion:^(BOOL finished) {
//            [_collectionView reloadData];
//            
//        }];   
    }
}
- (void)imageEditFinish {
    

    if (_delegate &&
        [_delegate respondsToSelector:@selector(uploadPictureSelectSuccessImages:itemIndex:)]) {
        [_delegate uploadPictureSelectSuccessImages:self.imageArray itemIndex:_itemIndex];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
