//
//  DemocraticSelectOptionButton.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "DemocraticSelectOptionButton.h"

@implementation DemocraticSelectOptionButton


- (void)drawRect:(CGRect)rect {
    
    [self setImage:[UIImage imageNamed:@"interaction_optionCell_unSelected_button"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"interaction_optionCell_selected_button"] forState:UIControlStateSelected];
    [self setTitleColor:Color_6 forState:UIControlStateNormal];
    [self.titleLabel setFont:FONT_15];

}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(0, CGRectGetHeight(self.frame)/2 - 10, 20, 20);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(30, 0, CGRectGetWidth(self.frame) - 30, CGRectGetHeight(self.frame));
}

@end
