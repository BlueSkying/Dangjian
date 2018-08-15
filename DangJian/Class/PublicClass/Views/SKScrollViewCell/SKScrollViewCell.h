//
//  SKScrollViewCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WebViewBlock)(NSString *);
typedef void (^SearchBlock) ();


@protocol SKScrollViewCellDelegate <NSObject>

- (void)sk_scrollViewDidSelectItemAtIndex:(NSInteger)index;

@end

@interface SKScrollViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) WebViewBlock block;
@property (nonatomic, copy) SearchBlock searchBlock;
@property (nonatomic, strong) NSArray *urlArr;//网络图片数组
@property (nonatomic, strong) NSArray *dataArray; //数据信息

@property (nonatomic, weak) id<SKScrollViewCellDelegate>delegate;
@end
