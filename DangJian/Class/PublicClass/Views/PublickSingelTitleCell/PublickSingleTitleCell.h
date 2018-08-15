//
//  PublickSingleTitleCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublickSingleTitleCell : UITableViewCell


/**
 唯一标题文字
 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;
/**
 是否显示右箭头
 */
@property (nonatomic, assign) BOOL showArrow;
@end
