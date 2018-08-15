//
//  CalendarDetailViewController.h
//  ThePartyBuild
//
//  Created by TuringLi on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "BaseViewController.h"
#import "dayWorkModel.h"
@interface CalendarDetailViewController : BaseViewController

@property (nonatomic ,strong) UILabel *textLabel;
@property (nonatomic ,strong) dayWorkModel *model;
@end
