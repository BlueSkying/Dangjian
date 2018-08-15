//
//  OrganizationJobFeedbackUploadPictureCell.h
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobFeedbackUploadPictureCellDelegate <NSObject>

- (void)uploadPictureSelectSuccessImages:(NSMutableArray *)images
                               itemIndex:(NSUInteger)itemIndex;
- (void)uploadPictureDeleteImages:(NSMutableArray *)images
                        itemIndex:(NSUInteger)itemIndex;

@end

@interface OrganizationJobFeedbackUploadPictureCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *configParams;
@property (nonatomic, weak) id<JobFeedbackUploadPictureCellDelegate>delegate;

@end
