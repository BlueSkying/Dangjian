//
//  SKSegmentedView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKSegmentedView.h"


//正常button 文字font
static CGFloat const ButtonTitleNormalFont = 16;
//选择button 文字font
static CGFloat const ButtonTitleSelectedFont = 17;


@interface SKSegmentedView (){
    // -- 记录水平方向按钮的X坐标
    CGFloat horizontalX;
}
/**
 *  记录Button的数组
 */
@property (nonatomic , strong) NSMutableArray *buttonArray;
/**
 *
 */
@property (nonatomic, strong) CALayer *indicateLayer;

@end

@implementation SKSegmentedView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // -- 水平按钮坐标初始值为15
        horizontalX = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpChanelScrollViewAndMoreButton];
    }
    
    return self;
}
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}
- (void) setUpChanelScrollViewAndMoreButton{
    

    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1.25, CGRectGetWidth(self.frame), 0.5)];
    bottomLineView.backgroundColor = SystemGraySeparatedLineColor;
    [self addSubview:bottomLineView];
    // --
    _indicateLayer = [[CALayer alloc] init];
    _indicateLayer.backgroundColor = Color_system_red.CGColor;
    [bottomLineView.layer addSublayer:_indicateLayer];
    
}



- (void) loadButtonTitleArray:(NSArray *)titleArray {
    
    if (titleArray == nil)return;
    NSInteger titleCount = titleArray.count;
    CGFloat buttonWidth = CGRectGetWidth(self.frame)/titleCount;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) - 1;
    for (NSInteger i = 0; i < titleCount; i ++) {
        
        UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentedButton setFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight)];
        [segmentedButton setTitle:titleArray[i] forState:UIControlStateNormal];
        segmentedButton.tag = i;
        [segmentedButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleNormalFont]];
        [segmentedButton setTitleColor:Color_9 forState:UIControlStateNormal];
        
        // -- 选中状态文字颜色
        [segmentedButton setTitleColor:Color_system_red forState:UIControlStateSelected];
        [segmentedButton addTarget:self action:@selector(clickToSelectSegment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:segmentedButton];
        [self.buttonArray addObject:segmentedButton];
    }
    [_indicateLayer setFrame:CGRectMake(10, -0.75, buttonWidth - 20, 2)];
    [self chanelButtonDefaultClick];
}

// -- 默认第一个按钮为选中状态
- (void) chanelButtonDefaultClick{
    
    UIButton *tmpButton = [self.buttonArray firstObject];
    [tmpButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleSelectedFont]];
    [tmpButton setSelected:YES];
    
}

// -- 选择频道按钮点击方法
- (void) clickToSelectSegment:(UIButton *)sender{
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (obj  && [obj isKindOfClass:[UIButton class]]) {
            
            [(UIButton *)obj  setSelected:NO];
            [((UIButton *)obj).titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleNormalFont]];
        }
    }];
    
    [sender setSelected:YES];
    [sender.titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleSelectedFont]];

    [_indicateLayer setPosition:CGPointMake(sender.center.x, 0.25)];

    // -- 根据数组里存得对象 去查找相对应的下标 index是从0开始的
    NSInteger buttonIndex = [self.buttonArray indexOfObject:sender];
    
    if (self.chanelButtonIdex) {
        // -- 把数组下标传出去
        self.chanelButtonIdex(buttonIndex + 1);
    }
}

// -- 根据当前View的下标对分类频道按钮进行选中操作
- (void) scrollToChanelViewWithIndex:(NSInteger)index{
    
    if (self.buttonArray.count > index - 1) {
        
        UIButton *tmpButton = self.buttonArray[index - 1];
        
        // -- 按钮置为未选中的状态
        [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (obj && [obj isKindOfClass:[UIButton class]]) {
                
                [(UIButton *)obj setSelected:NO];
                [((UIButton *)obj).titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleNormalFont]];
            }
        }];
        
        // -- 选中按钮
        [tmpButton setSelected:YES];
        [tmpButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonTitleSelectedFont]];
        [_indicateLayer setPosition:CGPointMake(tmpButton.center.x, 0.25)];
        
    }
}





@end
