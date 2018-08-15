//
//  AddressSectionHeaderView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YUFoldingSectionState) {
    
    YUFoldingSectionStateFlod, // 折叠
    YUFoldingSectionStateShow, // 打开
};

@protocol AddressSectionHeaderViewDelegate <NSObject>

-(void)sectionViewSelectViewSection:(NSInteger)section;

@end
@interface AddressSectionHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;



@property(nonatomic ,copy)NSString *titleName;

@property(nonatomic, copy)NSString *groupCount;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) NSMutableArray *openDataArray; //打开数组
@property (nonatomic, assign) YUFoldingSectionState sectionState;
@property(nonatomic, assign)id<AddressSectionHeaderViewDelegate>delegate;
@end
