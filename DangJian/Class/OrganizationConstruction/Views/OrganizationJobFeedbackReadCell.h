//
//  OrganizationJobFeedbackReadCell.h
//  DangJian
//
//  Created by Sakya on 2017/6/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationJobFeedbackModel.h"



@interface OrganizationJobFeedbackReadCell : UITableViewCell

//绑定数据
- (void)bindDataJobFeedbackReadVo:(JobFeedbackReadModel *)jobFeedbackReadVo
            imageLoadSuccessBlock:(void(^)(UIImage *image))loadSuccessBlock;
@end