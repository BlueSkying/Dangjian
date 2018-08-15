//
//  NewsCustomButtonCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewsCustomButtonCellDelegate <NSObject>

@optional
- (void)clickToSelectItem:(UIButton *)sender;

//返回具体的位置
- (void)customButtonToSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface NewsCustomButtonCell : UITableViewCell


@property (nonatomic, strong) NSArray <NSDictionary *>*customArray;

@property (nonatomic, weak) id<NewsCustomButtonCellDelegate>delegate;

/**
包含多个的section
 */
@property (nonatomic, assign) NSInteger section;
@end
