//
//  OnlineVotingCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OnlineVotingCell : UITableViewCell


@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelect;

/**
 文字
 */
@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, copy) void(^onlineVoteCellSelectBlock)(NSDictionary *param);
@end
