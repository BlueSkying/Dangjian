//
//  ChooseCell.m
//  LifePro
//
//  Created by huangchen on 16/7/22.
//  Copyright © 2016年 gaoyong. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
     self.titleLabel = [[UILabel alloc] init];
     self.titleLabel.backgroundColor = [UIColor clearColor];
     self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
     self.titleLabel.textAlignment = NSTextAlignmentLeft;
     self.titleLabel.font = [UIFont systemFontOfSize:14.0];
     [self.contentView addSubview:self.titleLabel];
     [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0.0);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(25.0);
        make.height.right.equalTo(self.contentView);
      }];

     self.subTitleLabel = [[UILabel alloc] init];
     self.subTitleLabel.backgroundColor = [UIColor clearColor];
     self.subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
     self.subTitleLabel.textAlignment = NSTextAlignmentRight;
     self.subTitleLabel.font = [UIFont systemFontOfSize:14.0];
     [self.contentView addSubview:self.subTitleLabel];
     [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0.0);
       make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0.0);
       make.height.equalTo(self.contentView);
     }];
  }
    return self;
}

-(void)setObecject:(NSDictionary*)dict withIndex:(NSInteger)index{
    self.titleLabel.text = dict[kTitle];
    self.subTitleLabel.text = dict[kSubTitle];
   if(index==0){
        [self addLongLine];
        [self addShortLine];
   }else if (index==3){
        [self addDownLongLine];
    }else{
        [self addShortLine];
    }
}

-(void)setObject:(NSDictionary *)dict{
    self.titleLabel.text = dict[kTitle];
    self.subTitleLabel.text = dict[kSubTitle];
    if([dict[kTitle] isEqualToString:@"物业公司"]){
        [self addLongLine];
        [self addShortLine];
    }else{
        [self addDownLongLine];
    }
}

-(void)setContent:(NSDictionary *)dict{
    if([dict[kTitle] rangeOfString:@"登录"].location!=NSNotFound){
      self.titleLabel.textColor = [UIColor colorWithHexString:@"ff5555"];
    }else{
      self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];  
    }
    self.titleLabel.text = dict[kTitle];
    self.subTitleLabel.text = dict[kSubTitle];
}

-(void)addLongLine{
    UIView *hornlineView = [UIView new];
    hornlineView.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self addSubview:hornlineView];
    [hornlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.top.left.right.equalTo(self);
    }];
}

-(void)addShortLine{
    UIView *secondlineView = [UIView new];
    secondlineView.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self addSubview:secondlineView];
    [secondlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1.0);
        make.height.mas_equalTo(1.0);
        make.left.mas_equalTo(self).offset(15.0);
        make.right.equalTo(self);
    }];

}

-(void)addDownLongLine{
    UIView *hornlineView = [UIView new];
    hornlineView.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [self addSubview:hornlineView];
    [hornlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1.0);
        make.height.mas_equalTo(1.0);
        make.right.left.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
