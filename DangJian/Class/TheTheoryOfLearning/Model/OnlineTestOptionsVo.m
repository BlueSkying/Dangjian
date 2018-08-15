//
//  OnlineTestOptionsVo.m
//  DangJian
//
//  Created by Sakya on 17/5/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestOptionsVo.h"
#import "NSString+Util.h"
#import "OnlineTestDetailsVo.h"


@implementation OnlineTestOptionsVo

- (instancetype)initWithObject:(OnlineTestDetailsVo *)object {

    if(self = [super init]){

        NSString *localOptions = object.options;
        NSString *localOptionsResult = object.optionsResult;
        //需要判断试卷类型啊判断还是选择😄
        if (object.questionsType == TestQuestionsJudgeType) {
            //自己添加的判断数据😔
            localOptions = @"A.正确||B.错误";
            if ([localOptionsResult integerValue] == 1) {
                localOptionsResult = @"10";
            } else {
                localOptionsResult = @"01";
            }
        }
        
        //对数据进行处理创建实体
        NSArray *options = [localOptions componentsSeparatedByString:@"||"];
        const char *string = [localOptionsResult UTF8String];
        NSInteger n = strlen(string);
        
        for (NSInteger i = 0; i < options.count; i++) {
            
            @autoreleasepool {
                OnlineTestOptionsVo *optionVo = [OnlineTestOptionsVo new];
                optionVo.topicTitle = options[i];
                if (n == options.count) {
                    NSRange localRange = NSMakeRange (i, 1);
                    optionVo.correctAnswer = [[localOptionsResult substringWithRange:localRange] integerValue];
                }
                [self.optionsArray addObject:optionVo];
            }
        }
    }
    return self;
}

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) {
        
        _optionsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _optionsArray;
}
- (CGFloat)cellHeight {
    
    if (!_cellHeight) {
        
        CGFloat cellHeight = [self getCellHeight];
        cellHeight += 10;
        cellHeight = cellHeight > 45 ? cellHeight : 45;
        //总高度 上面的间隙啊
        cellHeight += 15;
        //需要计算大一行的数据
        _cellHeight = ceil(cellHeight);
    }
    return _cellHeight;
}
- (NSTextAlignment)textAlignment {
    if (!_textAlignment) {
        if ([self getLabelWidth] > kScreen_Width - 50) {
            
            _textAlignment = NSTextAlignmentLeft;
        } else {
            _textAlignment = NSTextAlignmentCenter;
        }
    }
    return _textAlignment;
}

- (CGFloat)getCellHeight {
    
    
    CGFloat height = [_topicTitle boundingHeightWithSize:CGSizeMake(kScreen_Width - 50, CGFLOAT_MAX) font:FONT_15 paragraphStyle:self.paragraphStyle];
    //计算内容size
    return height;
}
- (CGFloat)getLabelWidth {
    
    CGFloat height = [_topicTitle widthWithFont:FONT_15 constrainedToHeight:40];
    return height;
}
- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2.0f;
        _paragraphStyle = paragraphStyle;
    }
    return _paragraphStyle;
}
@end
