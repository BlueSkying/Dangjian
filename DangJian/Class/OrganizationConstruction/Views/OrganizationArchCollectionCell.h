//
//  OrganizationArchCollectionCell.h
//  DangJian
//
//  Created by Sakya on 2017/6/16.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationalStructureVo.h"

@interface OrganizationArchItemCell : UICollectionViewCell


@end

@protocol OrganizationArchCollectionCellDelegate <NSObject>

- (void)archCollectionCellSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface OrganizationArchCollectionCell : UITableViewCell

@property (nonatomic, strong) NSArray <OrganizationalStructureVo *>*memberArray;

@property (nonatomic, weak) id<OrganizationArchCollectionCellDelegate>delegate;
@end
