//
//  SKCircleView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKCircleView : UIView

@property (nonatomic, strong) UILabel *contentLabel;//内容

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, assign)CGFloat progressValue;//

- (instancetype)initWithFrame:(CGRect)frame;
@end
