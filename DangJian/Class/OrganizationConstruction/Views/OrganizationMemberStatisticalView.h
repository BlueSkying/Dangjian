//
//  OrganizationMemberStatisticalView.h
//  DangJian
//
//  Created by Sakya on 2017/6/13.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationalStructureVo.h"

typedef NS_OPTIONS(NSInteger, OrganizationStatisticalHeaderType) {
    
    //正常的header
    OrganizationStatisticalNormalHeaderType = 0,
//    有换届时间的header
    OrganizationStatisticalDateHeaderType
};

@interface OrganizationStatisticalCountView : UIView

@end

@interface OrganizationItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;
@end

@interface OrganizationMemberStatisticalView : UIView

@property (nonatomic, strong) OrganizationalMemberVo *memberVo;

- (instancetype)initWithFrame:(CGRect)frame headerType:(OrganizationStatisticalHeaderType)headerType;

@end
