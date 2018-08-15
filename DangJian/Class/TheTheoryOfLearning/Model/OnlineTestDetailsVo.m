//
//  OnlineTestDetailsVo.m
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestDetailsVo.h"
#import "OnlineTestOptionsVo.h"



@implementation OnlineTestDetailsVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"qidId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"data":@"OnlineTestDetailsVo"};
}

#pragma setter
- (void)setType:(NSString *)type {
    _type = type;
    if ([type isEqualToString:@"SINGLE"]) {
        _questionsType = TestQuestionsSingleType;
    } else if ([type isEqualToString:@"MORE"]) {
        _questionsType = TestQuestionsMoreType;
        
    } else if ([type isEqualToString:@"JUDGE"]) {
        _questionsType = TestQuestionsJudgeType;
    }
}

#pragma mark - getter
//编辑选项实体
- (NSMutableArray *)optionArray {
    
    if (!_optionArray) {
        if (self) {
            _optionArray = [[OnlineTestOptionsVo alloc] initWithObject:self].optionsArray;
        } else {
            _optionArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return _optionArray;
}
- (BOOL)isDone {
    
  //为了获取即使的数据
    __block BOOL isDone = NO;
    if (_optionArray && _optionArray.count > 0) {
        //判断是否做了
        [_optionArray enumerateObjectsUsingBlock:^(OnlineTestOptionsVo  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected == 1) {
                isDone = YES;
                *stop = YES;
            }
        }];
    }
    _isDone = isDone;
    return _isDone;
}
- (NSString *)titleDetails {
    if (!_titleDetails) {
        NSString *topicType;
        if (_questionsType == TestQuestionsSingleType) {
            topicType = @"（单选）";
        } else if (_questionsType == TestQuestionsJudgeType) {
            topicType = @"（判断）";
        } else if (_questionsType == TestQuestionsMoreType) {
            topicType = @"（多选）";
        }
        _titleDetails = [NSString stringWithFormat:@"%@%@",_title,topicType];
    }
    return _titleDetails;
}

+ (void)examInformationTestId:(NSString *)testId
                      success:(void(^)(id result)) successBlock{
    
    [InterfaceManager examInfoId:testId success:^(id result) {
       
        successBlock(result);
    } failed:^(id error) {
    }];
}

@end
