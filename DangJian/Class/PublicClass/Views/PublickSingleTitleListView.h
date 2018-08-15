//
//  PublickSingleTitleListView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThoughtReportsEditViewController.h"
#import "WorkFeedbackEditViewController.h"

@class PublickSingleTitleListView;


/**
 请求params
 
 NSDictionary 包括 pageNo  listArray  totalPage 可以到时候换成model
 */

typedef void (^requestListDataBlock)(NSDictionary *);

@protocol PublickSingleTitleListViewDelegate <NSObject>


/**
 代理处理事件
 
 @param sender sender
 @param params 传递参数 包括 pageNo  listArray  totalPage  可以到时候换成model
 @param success 返回的参数
 */
- (void)listViewRequestDataSender:(PublickSingleTitleListView *)sender
                           Params:(NSDictionary *)params
                          success:(requestListDataBlock)success;

@end

@interface PublickSingleTitleListView : UIView


@property (nonatomic, assign) ReportFeedbackType pageType;


/**
 是否是查询用户自己的数据
 */
@property (nonatomic, assign) BOOL mine;

@property (nonatomic, weak) id<PublickSingleTitleListViewDelegate>delegate;

- (void)autoRefreshCanBe;

- (void)manualRefreshData;

@end
