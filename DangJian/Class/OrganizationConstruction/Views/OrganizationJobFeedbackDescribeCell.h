//
//  OrganizationJobFeedbackDescribeCell.h
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrganizationJobFeedbackDescribeCellDelegate <UITableViewDelegate>

@optional
- (void)feedbackDescribeUpdatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)feedbackDescribeUpdatedText:(NSString *)text submitkey:(NSString *)submitkey;


@end

@interface OrganizationJobFeedbackDescribeCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,assign) CGFloat CellHeight;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSString * contentStr;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, assign)id<OrganizationJobFeedbackDescribeCellDelegate> delegate;
/**
 显示的参数
 */
@property (nonatomic, strong) NSDictionary *configParams;
@end
