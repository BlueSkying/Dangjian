//
//  SKTableViewCustomButton.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKTableViewCustomButton.h"

#define ImageWidth SKXFrom6(28)

@implementation SKTableViewCustomButton


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setTitleColor:Color_6 forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.titleLabel setFont:FontScale_12];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.adjustsImageWhenHighlighted = NO;
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
     CGFloat ImageSize = ImageWidth;
    return CGRectMake((self.frame.size.width - ImageSize)/2, SKXFrom6(15), ImageSize , ImageSize );
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat ImageSize = ImageWidth;
    return CGRectMake(0, ImageSize + SKXFrom6(15)  , self.frame.size.width, self.frame.size.height - (ImageSize + SKXFrom6(15)));
}
@end
