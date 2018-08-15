//
//  SKListView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SKListView;
/**
 请求params

  NSDictionary 包括 pageNo  listArray  totalPage 可以到时候换成model
 */

typedef void (^requestListDataBlock)(NSDictionary *);

@protocol SKListViewDelegate <NSObject>


/**
 代理处理事件

 @param sender sender
 @param params 传递参数 包括 pageNo  listArray  totalPage  可以到时候换成model
 @param success 返回的参数
 */
- (void)listViewRequestDataSender:(SKListView *)sender
                           Params:(NSDictionary *)params
                          success:(requestListDataBlock)success;

@end

@interface SKListView : UIView


@property (nonatomic , assign) ArticleListRequestType articleType;

@property (nonatomic, weak) id<SKListViewDelegate>delegate;

- (void) autoRefreshCanBe;

@end
