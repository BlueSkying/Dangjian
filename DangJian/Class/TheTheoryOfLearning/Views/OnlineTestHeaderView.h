//
//  OnlineTestHeaderView.h
//  DangJian
//
//  Created by Sakya on 17/5/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineTestHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

- (CGFloat)heighthHeaderView;

@property (nonatomic, copy) NSString *title;
/**题号*/
@property (nonatomic, copy) NSString *qidId;

@end
