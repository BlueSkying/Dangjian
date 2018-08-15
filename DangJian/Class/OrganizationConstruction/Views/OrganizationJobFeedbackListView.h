//
//  OrganizationJobFeedbackListView.h
//  DangJian
//
//  Created by Sakya on 2017/6/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationJobFeedbackListView : UIView
/**
 是否是查询用户自己的数据
 */
@property (nonatomic, assign) BOOL mine;

- (void)autoRefreshCanBe;

- (void)manualRefreshData;
@end
