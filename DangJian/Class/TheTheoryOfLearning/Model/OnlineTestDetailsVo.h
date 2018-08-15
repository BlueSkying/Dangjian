//
//  OnlineTestDetailsVo.h
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_OPTIONS(NSInteger, TestQuestionsType) {
    //单选
    TestQuestionsSingleType = 0,
    //多选
    TestQuestionsMoreType = 1,
    //判断
    TestQuestionsJudgeType
};

@interface OnlineTestDetailsVo : NSObject

/**题号*/
@property (nonatomic, assign) NSInteger qidId;
/**options*/
@property (nonatomic, copy) NSString *options; //选项 ‘||’分隔
//模型数组 选项模型 OnlineTestOptionsVo
@property (nonatomic, strong) NSMutableArray *optionArray;
/**标题*/
@property (nonatomic, copy) NSString *title;

/**自己添加的全部标题包括题号，试题类型*/
@property (nonatomic, copy) NSString *titleDetails;
/**试题类型：SINGLE("单选"),MORE("多选"),JUDGE("判断")*/
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) TestQuestionsType  questionsType;
/**试题结果*/
@property (nonatomic, copy) NSString *optionsResult;
/**试题分值*/
@property (nonatomic, assign) NSInteger score;

//自加属性为了计算
/**
 获取到的分数 每一个道题都需要计算一下
 */
@property (nonatomic, assign) NSInteger actualPoints;

/**
 题是否做了
 */
@property (nonatomic, assign) BOOL isDone;


+ (void)examInformationTestId:(NSString *)testId
                      success:(void(^)(id result)) successBlock;
@end
