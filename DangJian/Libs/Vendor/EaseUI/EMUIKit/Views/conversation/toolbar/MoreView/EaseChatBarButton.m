//
//  EaseChatBarButton.m
//  DangJian
//
//  Created by Sakya on 17/5/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "EaseChatBarButton.h"

@implementation EaseChatBarButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setTitleColor:Color_9 forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.adjustsImageWhenHighlighted = NO;
    self.backgroundColor = [UIColor clearColor];
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake((self.frame.size.width - 40)/2, 5, 40 , 40 );
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 40 + 10, self.frame.size.width, 30);
    
}

@end
