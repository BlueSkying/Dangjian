//
//  PublickTextViewCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublickTextViewCellDelegate <UITableViewDelegate>

@optional
- (void)updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)updatedText:(NSString *)text submitkey:(NSString *)submitkey;


@end


@interface PublickTextViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,assign) CGFloat CellHeight;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSIndexPath * indexPath;
//填入的内容
@property (nonatomic,strong) NSString * contentStr;

@property (nonatomic, assign) UIReturnKeyType keyType;
/**
 是否能够输入
 */
@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic,assign)id<PublickTextViewCellDelegate> delegate;
/**
 显示的参数
 */
@property (nonatomic, strong) NSDictionary *configParams;
@end
