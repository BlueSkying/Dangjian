//
//  OrganizationalCollectionViewCell.h
//  DangJian
//
//  Created by Sakya on 17/5/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationalStructureVo.h"


@interface OrganizationalStructureTopCell : UITableViewCell

@end
typedef NS_OPTIONS(NSInteger, OrganizationalStructureCellType) {
    
    //顶端的组织框架的cell
    OrganizationalStructureCellTypeTop = 0,
    //中部cell类型
    OrganizationalStructureCellTypeMid = 1,
    //    底部cell类型
    OrganizationalStructureCellTypeBottom = 2,
    
};
@interface OrganizationalStructureTableViewCell : UITableViewCell

@end

@protocol OrganizationalCollectionViewCellDelegate <NSObject>

- (void)organizationalViewSelectRowAtIndexPath:(NSIndexPath *)indexPath organizationVo:(OrganizationalStructureVo *)organizationVo;

@end

@interface OrganizationalCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) OrganizationalStructureVo *organizationVo;

@property (nonatomic, weak) id<OrganizationalCollectionViewCellDelegate>delegate;

@end
