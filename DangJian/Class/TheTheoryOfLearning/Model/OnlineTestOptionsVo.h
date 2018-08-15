//
//  OnlineTestOptionsVo.h
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>


@class OnlineTestDetailsVo;

@interface OnlineTestOptionsVo : NSObject

//创建本类时返回的所有选项的模型数组
@property (nonatomic, strong) NSMutableArray *optionsArray;

//对其方式
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) CGFloat cellHeight;
/**
 选项
 */
@property (nonatomic, copy) NSString *topicTitle;
/**
 正确答案
 */
@property (nonatomic, assign) NSInteger correctAnswer;

//文字风格
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;
//是否被选中 需要跟正确答案对比 统一为int类型  0错误 1正确
@property (nonatomic, assign) NSInteger isSelected;




- (instancetype)initWithObject:(OnlineTestDetailsVo *)object;

@end
