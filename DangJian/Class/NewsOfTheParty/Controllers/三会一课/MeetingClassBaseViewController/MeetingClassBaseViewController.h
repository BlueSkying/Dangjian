//
//  MeetingClassBaseViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSInteger,  MeetingClassPageType) {
    
    /**党员大会*/
    MeetingClassMemberConferencePageType = 0,
    /**党支部委员会*/
    MeetingClassThePartyBranchCommitteePageType = 1,
    /**党小组会*/
    MeetingClassThePartyGroupPageType = 2,
    /**党课*/
    MeetingClassThePartyClassPageType = 3
};

@interface MeetingClassBaseViewController : BaseViewController


/**
 进入的页面类型
 */
@property (nonatomic, assign) MeetingClassPageType pageType;
@end
