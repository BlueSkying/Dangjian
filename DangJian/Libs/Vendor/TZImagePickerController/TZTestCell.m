//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"
#import "UIView+Layout.h"

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setCornerRadius:5.0f];
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds  = YES;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
       
        // 注释掉_deleteButton
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"organization_deletePicture_icon"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(self.tz_width - 36, 0, 36, 36);
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleteBtn.alpha = 0.8;
        [_deleteBtn addTarget:self action:@selector(clickToSendButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    UIView *cellSnapshotView = nil;
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}
-(void)clickToSendButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToDeleteCellWithButton:)]) {
        [self.delegate clickToDeleteCellWithButton:sender];
    }
}

@end
