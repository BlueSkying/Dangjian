//
//  dayWorkCell.m
//  ThePartyBuild
//
//  Created by TuringLi on 17/5/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "dayWorkCell.h"

@implementation dayWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SKXFrom6(10), 0, SKXFrom6(280), 45)];
    self.titleLabel.textColor = HexRGB(0x333333);
    self.titleLabel.font = FONT_16;
    [self.contentView addSubview:self.titleLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, 1)];
    view.backgroundColor = HexRGB(0xf5f5f5);
    
    [self.contentView addSubview:view];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
