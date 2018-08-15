//
//  MeetingClassHomeModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MeetingClassHomeModel.h"

@implementation MeetingClassHomeModel
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        
        NSArray *buttonArray =
        @[@{@"imageName":@"news_memberConference_icon",
            @"className":@"MeetingClassBaseViewController",
            @"title":@"党员大会"},
          @{@"imageName":@"news_branchCommittee_icon",
            @"className":@"MeetingClassBaseViewController",
            @"title":@"党支部委员会"},
          @{@"imageName":@"news_thePartyGroup_icon",
            @"className":@"MeetingClassBaseViewController",
            @"title":@"党小组会"},
          @{@"imageName":@"news_partyLecture_icon",
            @"className":@"MeetingClassBaseViewController",
            @"title":@"党课"}];
        _itemArray = [NSMutableArray arrayWithArray:buttonArray];
        
    }
    return _itemArray;
}
@end
