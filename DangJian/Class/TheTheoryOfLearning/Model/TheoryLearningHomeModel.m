//
//  TheoryLearningHomeModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "TheoryLearningHomeModel.h"
#import "HomeBannerVo.h"

@implementation TheoryLearningHomeModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"zxxx":@"ArticleListBaseModel",
             @"carousel":@"HomeBannerVo"};
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        
        NSArray *buttonArray =
        @[@{@"imageName":@"learn_thePartyHistory_button",
            @"className":@"ThePartyHistoryTableViewController",
            @"title":@"党史"},
          @{@"imageName":@"learn_thePartyRules_button",
            @"className":@"ThePartyChapterRuleViewController",
            @"title":@"党章党规"},
          @{@"imageName":@"learn_seriesOfSpeech_button",
            @"className":@"SeriesOfSpeechViewController",
            @"title":@"系列讲话"},
          @{@"imageName":@"learn_theTheoryPush_button",
            @"className":@"TheTheoryPushTableViewController",
            @"title":@"理论推送"}];
        _itemArray = [NSMutableArray arrayWithArray:buttonArray];
        
    }
    return _itemArray;
}
- (NSMutableArray *)reviewArray {
    if (!_reviewArray) {
        
        
        NSArray *buttonArray =
        @[@{@"imageName":@"learn_onlineTest_icon",
            @"className":@"OnlineTestClassificationViewController",
            @"title":@"在线考试"},
          @{@"imageName":@"learn_historicalPerformance_icon",
        @"className":@"OnlineTestHistoricalPerformanceViewController",
            @"title":@"历史成绩"}];
        _reviewArray = [NSMutableArray arrayWithArray:buttonArray];
        
    }
    return _reviewArray;
}
+ (void)homePageTheoryLearningSuccess:(void(^)(TheoryLearningHomeModel *result)) successBlock
                                  failed:(void(^)(id error)) failedBlock {
    
    [InterfaceManager homePageType:HomePageTheTheoryLearningType success:^(id result) {
        
        TheoryLearningHomeModel *homeVo;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            
            homeVo = [TheoryLearningHomeModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            
            [homeVo.carousel enumerateObjectsUsingBlock:^(HomeBannerVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [homeVo.imageArray addObject:obj.imageUrl];
                //判断是不是外链
                [homeVo.targetsArray addObject:[NSString stringWithFormat:@"%@%@/%@",InterfaceIPAddress,URLBANNERTARHETADDRESS,obj.targetId
                                                ]];
            }];
        }
        successBlock(homeVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)targetsArray {
    if (!_targetsArray) {
        _targetsArray = [NSMutableArray array];
    }
    return _targetsArray;
}



@end
