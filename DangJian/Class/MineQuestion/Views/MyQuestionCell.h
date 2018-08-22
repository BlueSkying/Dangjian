//
//  MyQuestionCell.h
//  DangJian
//
//  Created by huangchen on 2018/8/22.
//  Copyright © 2018年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQuestionCell : UITableViewCell
// 问题名称
@property(nonatomic,strong)UILabel * titleLabel;
// 问题等级
@property(nonatomic,strong)UILabel * levelLabel;
// 新增时间
@property(nonatomic,strong)UILabel * timeLabel;
// 问题内容
@property(nonatomic,strong)UILabel * contentLabel;
// 问题提出人
@property(nonatomic,strong)UILabel * creatorLabel;
// 问题整改时间
@property(nonatomic,strong)UILabel * changeTimeLabel;

-(void)setObject:(NSDictionary *)dict;

@end
