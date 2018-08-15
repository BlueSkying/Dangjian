//
//  TheoryLearningBaseTableViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


//
typedef NS_OPTIONS(NSInteger, TheoryLearningPageType) {
    
    /**党史*/
    TheoryLearningHistoryThePartyPageType = 0,
    /**党章党规*/
    TheoryLearningRulesThePartyPageType = 1,
    /**系列讲话*/
    TheoryLearningSeriesOfSpeechPageType = 2,
    /**理论推送*/
    TheoryLearningTheTheoryPushPageType = 3,


};

@interface TheoryLearningBaseTableViewController : UITableViewController

@property (nonatomic, assign) TheoryLearningPageType pageType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
