//
//  OnlineTestListCell.h
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineTestPaperListVo.h"



@interface OnlineTestListCell : UITableViewCell

@property (nonatomic, strong) OnlineTestPaperListVo *testVo;

@property (nonatomic, strong) OnlineTestPaperListVo *historyScoreVo;

@end
