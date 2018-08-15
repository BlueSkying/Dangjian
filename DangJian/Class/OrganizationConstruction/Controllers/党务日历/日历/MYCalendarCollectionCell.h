//
//  MYCalendarCollectionCell.h
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYCalendarDayModel;

@interface MYCalendarCollectionCell : UICollectionViewCell


/**日历数据*/
@property (nonatomic, strong) MYCalendarDayModel *model;

/**自定义选中动画*/
@property (nonatomic, assign) BOOL isMySelcted;

@end
