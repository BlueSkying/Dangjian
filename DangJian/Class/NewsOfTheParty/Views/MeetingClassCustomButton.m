//
//  MeetingClassCustomButton.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MeetingClassCustomButton.h"

@implementation MeetingClassCustomButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setTitleColor:Color_9 forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:FontScale_14];
    self.adjustsImageWhenHighlighted = NO;
    
    //设置圆角度
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    
//    设置阴影
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=self.layer.frame;
    subLayer.frame=fixframe;
    subLayer.cornerRadius=4;
    subLayer.backgroundColor=[Color_9 colorWithAlphaComponent:0.5].CGColor;
    subLayer.shadowColor=Color_9.CGColor;
    subLayer.shadowOffset=CGSizeMake(1,1);
    subLayer.shadowOpacity=0.8;
    subLayer.shadowRadius=1;
    [self.superview.layer insertSublayer:subLayer below:self.layer];
    
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat ImageSize = self.frame.size.width * 4/9;
    return CGRectMake((self.frame.size.width - ImageSize)/2, SKXFrom6(25), ImageSize , ImageSize );
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat ImageSize = self.frame.size.width * 4/9;
    return CGRectMake(0, ImageSize + SKXFrom6(15)  , self.frame.size.width, self.frame.size.height - (ImageSize + SKXFrom6(20)));
}

@end
