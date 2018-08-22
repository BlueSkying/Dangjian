//
//  MyQuestionCell.m
//  DangJian
//
//  Created by huangchen on 2018/8/22.
//  Copyright © 2018年 Sakya. All rights reserved.
//

#import "MyQuestionCell.h"

@implementation MyQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView * borderView =[[UIView alloc]init];
        borderView.backgroundColor=[UIColor colorWithHexString:@"DFDFDF"];
        borderView.layer.cornerRadius = 2;
        [self.contentView addSubview:borderView];
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15.0); make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10.0);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15.0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(20.0);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(25.0);
                make.right.mas_equalTo(80);
                make.height.mas_equalTo(40);
        }];
        
        self.levelLabel = [[UILabel alloc] init];
        self.levelLabel.backgroundColor = [UIColor orangeColor];
        self.levelLabel.textColor = [UIColor colorWithHexString:@"ff5555"];
        self.levelLabel.layer.cornerRadius = 8;
        self.levelLabel.textAlignment = NSTextAlignmentRight;
        self.levelLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_top).mas_offset(0.0);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(15.0);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(30);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.levelLabel.mas_top).mas_offset(0.0);
            make.left.mas_equalTo(self.levelLabel.mas_right).mas_offset(15.0); make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-25);
                make.height.mas_equalTo(40);
        }];
        
        UIView * linvView =[[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width-50,0.5)];
        linvView.backgroundColor=[UIColor colorWithHexString:@"DFDFDF"];
        [self.contentView addSubview:linvView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(linvView.mas_top).mas_offset(10.0);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(25.0);
            make.right.mas_equalTo(self.contentView.mas_left).mas_offset(-25.0);
                make.height.mas_equalTo(60);
        }];
        
        UIView * darkView =[[UIView alloc]init];
        darkView.backgroundColor=[UIColor colorWithHexString:@"DFDFDF"];
        [self.contentView addSubview:darkView];
        [darkView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.contentView).mas_offset(15.0); make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(10.0);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15.0);
                make.height.mas_equalTo(45);
        }];
        
        self.creatorLabel = [[UILabel alloc] init];
        self.creatorLabel.backgroundColor = [UIColor clearColor];
        self.creatorLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.creatorLabel.textAlignment = NSTextAlignmentLeft;
        self.creatorLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.creatorLabel];
        [self.creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.contentView).mas_offset(25.0); make.top.mas_equalTo(darkView.mas_top).mas_offset(0.0);
            make.width.mas_equalTo(200);
              make.height.mas_equalTo(darkView.frame.size.height);
        }];
        
        self.changeTimeLabel = [[UILabel alloc] init];
        self.changeTimeLabel.backgroundColor = [UIColor clearColor];
        self.changeTimeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.changeTimeLabel.textAlignment = NSTextAlignmentRight;
        self.changeTimeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.changeTimeLabel];
        [self.changeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-25.0); make.top.mas_equalTo(darkView.mas_top).mas_offset(0.0);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(darkView.frame.size.height);
        }];
    }
    return self;
}

-(void)setObject:(NSDictionary *)dict{
    
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
