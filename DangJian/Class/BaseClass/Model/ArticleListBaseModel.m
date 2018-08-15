//
//  ArticleListBaseModel.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/4.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ArticleListBaseModel.h"

@implementation ArticleListBaseModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"articleID":@"id"};
}
+ (NSDictionary*)mj_objectClassInArray {
    
    return @{@"list":@"ArticleListBaseModel"};
}
//- (void)setCreateTime:(NSString *)createTime {
//    
//    if (createTime && [createTime containsString:@"-"] && [createTime containsString:@" "]) {
//        NSArray *sepString = [createTime componentsSeparatedByString:@" "];
//        _createTime = [NSString stringWithFormat:@"%@",sepString.firstObject];
//    } else {
//        _createTime = createTime;
//    }
//    
//}
- (void)setImgUrl:(NSString *)imgUrl {
    if ([imgUrl containsString:@"http"]) {
        _imgUrl = imgUrl;
    } else {
        _imgUrl = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,imgUrl];
    }
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}
- (void)articleListType:(ArticleListRequestType)articleType
                success:(void(^)(ArticleListBaseModel *result)) successBlock
                 failed:(void(^)(id error)) failedBlock {

   
    if (self.pageNo == 0) {
        [self.listArray removeAllObjects];
    }
    self.pageNo ++;
    __weak typeof(self) weakSelf = self;
    [InterfaceManager articleListPageNo:self.pageNo articleType:articleType success:^(id result) {
        
        ArticleListBaseModel *articelListVo;
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            
            articelListVo = [ArticleListBaseModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.listArray addObjectsFromArray:articelListVo.list];;
            articelListVo.listArray = weakSelf.listArray;
            DDLogInfo(@"%@",articelListVo);
        }
        successBlock(articelListVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
}
@end
