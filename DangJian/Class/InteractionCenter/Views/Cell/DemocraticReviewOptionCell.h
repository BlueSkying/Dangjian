//
//  DemocraticReviewOptionCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemocraticAppraisalVo.h"

@protocol DemocraticReviewOptionCellDelegate <NSObject>

- (void)democraticReviewOption:(DemocraticAppraisalVo *)appraisalVo
                     indexPath:(NSIndexPath*)indexPath;


@end

@interface DemocraticReviewOptionCell : UITableViewCell

@property (nonatomic, strong) DemocraticAppraisalVo *appraisalVo;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<DemocraticReviewOptionCellDelegate>delegate;


@end
