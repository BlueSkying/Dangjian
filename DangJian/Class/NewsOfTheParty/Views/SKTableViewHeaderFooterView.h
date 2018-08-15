//
//  SKTableViewHeaderFooterView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/3.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKTableViewHeaderFooterViewType) {
    
    //正常的header 没有上面的灰条
    SKTableViewHeaderFooterViewNormalType = 0,
    //    上面添加灰条
    SKTableViewHeaderFooterViewArticleGreyType = 1,
    
};

@class SKTableViewHeaderFooterView;
@protocol SKTableViewHeaderFooterViewDelegate <NSObject>

- (void)headViewTapGestureDetected:(SKTableViewHeaderFooterView *)sender;

@end
@interface SKTableViewHeaderFooterView : UITableViewHeaderFooterView



#pragma mark - custom
@property (nonatomic, copy) NSString *headerTitle;
//即代表是否可以点击更多
@property (nonatomic, assign) BOOL isShowMore;
//是否现实低端黑线
@property (nonatomic, assign) BOOL showLine;
//类型
@property (nonatomic, assign) SKTableViewHeaderFooterViewType viewType;
@property (nonatomic, weak) id<SKTableViewHeaderFooterViewDelegate>delegate;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
