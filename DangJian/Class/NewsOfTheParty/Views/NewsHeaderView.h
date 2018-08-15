//
//  NewsHeaderView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, NewsHeaderViewType) {
    
    //正常的header 没有上面的灰条
    NewsHeaderViewNormalType = 0,
//    上面添加灰条
    NewsHeaderViewArticleGreyType = 1,

};

@class NewsHeaderView;
@protocol NewsHeaderViewDelegate <NSObject>

- (void)headViewTapGestureDetected:(NewsHeaderView *)sender;

@end
@interface NewsHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;


#pragma mark - custom
@property (nonatomic, copy) NSString *headerTitle;
//即代表是否可以点击更多
@property (nonatomic, assign) BOOL isShowMore;
//是否现实低端黑线
@property (nonatomic, assign) BOOL showLine;
//类型
@property (nonatomic, assign) NewsHeaderViewType viewType;
@property (nonatomic, weak) id<NewsHeaderViewDelegate>delegate;


@end
