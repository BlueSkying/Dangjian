//
//  NewsSingleImageOptionCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "NewsSingleImageOptionCell.h"

@implementation NewsSingleImageOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}
- (void)initCustomView {
    
    UIImageView *subjectImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:subjectImageView];
    [subjectImageView setImage:[UIImage imageNamed:@"news_meetingClass_icon"]];
    [subjectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.top.offset(0);
        make.right.offset(-10);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    
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
