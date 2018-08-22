//
//  TypeCell.h
//  LifePro
//
//  Created by huangchen on 16/10/10.
//  Copyright © 2016年 gaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeCell : UIView

@property(nonatomic,copy)void(^TypeBtnClickBlock)(NSInteger index);

-(void)setInfo:(NSDictionary *)dict;

@end
