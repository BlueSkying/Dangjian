//
//  ChooseCell.h
//  LifePro
//
//  Created by huangchen on 16/7/22.
//  Copyright © 2016年 gaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * subTitleLabel;

-(void)setObecject:(NSDictionary*)dict withIndex:(NSInteger)index;

-(void)setObject:(NSDictionary *)dict;

-(void)setContent:(NSDictionary *)dict;

@end
