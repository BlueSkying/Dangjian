//
//  OnlineVotingCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineVotingCell.h"
#import "DemocraticSelectOptionButton.h"


@implementation OnlineVotingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    DemocraticSelectOptionButton *button = [DemocraticSelectOptionButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    [button setUserInteractionEnabled:NO];
    [button setTitle:@"优秀" forState:UIControlStateNormal];
    [button setTag:1001];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
        make.right.offset(-15);
    }];

}

- (void)setIsSelect:(BOOL)isSelect {
   
    UIButton *selectButton = [self viewWithTag:1001];
    if (isSelect) {
        [selectButton setSelected:YES];
    } else {
        [selectButton setSelected:NO];
    }
}

- (void)setTitleText:(NSString *)titleText {
    
    UIButton *selectButton = [self viewWithTag:1001];
    [selectButton setTitle:titleText forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
