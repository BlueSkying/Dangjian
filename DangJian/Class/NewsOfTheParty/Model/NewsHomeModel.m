//
//  NewsHomeModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "NewsHomeModel.h"

@implementation NewsHomeModel



- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        
        NSArray *buttonArray =
            @[@{@"imageName":@"news_thePartyBuild_icon",
                @"className":@"ThePartyNewsViewController",
                    @"title":@"党建要闻"},
              @{@"imageName":@"news_theTheoryOfLearning",
                @"className":@"TheoryLearningViewController",
                    @"title":@"理论学习"},
              @{@"imageName":@"news_organizationConstruction_icon",
                @"className":@"OrganizationViewController",
                    @"title":@"组织管理"}];
        _itemArray = [NSMutableArray arrayWithArray:buttonArray];
        
    }
    return _itemArray;
}
- (NSMutableArray *)subjectArray {
    if (!_subjectArray) {
        
        NSArray *buttonArray =
            @[@{@"imageName":@"news_learnDo_icon",
                @"className":@"LearnToDoViewController",
                    @"title":@"两学一做"},
              @{@"imageName":@"news_lzbuild_icon",
                @"className":@"IntegrityBuildViewController",
                    @"title":@"廉政建设"}];
        _subjectArray = [NSMutableArray arrayWithArray:buttonArray];
        
    }
    return _subjectArray;
}
+ (void)homePageThePartyBuildNewsSuccess:(void(^)(NewsHomeModel *result)) successBlock
                                  failed:(void(^)(id error)) failedBlock {
    
    [InterfaceManager homePageType:HomePageThePartyBuildType success:^(id result) {
       
        NewsHomeModel *homeVo;
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            homeVo = [NewsHomeModel new];
            NSArray *carouselArray = [[result objectForKey:@"data"] objectForKey:@"carousel"];

            [carouselArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *imageUrl = [obj objectForKey:@"imageUrl"];
                if (![imageUrl containsString:@"http"]) {
                    imageUrl = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,imageUrl];
                }
                [homeVo.imageArray addObject:imageUrl];
                [homeVo.targetsArray addObject:[NSString stringWithFormat:@"%@%@/%@",InterfaceIPAddress,URLBANNERTARHETADDRESS,[obj objectForKey:@"id"]]];
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
