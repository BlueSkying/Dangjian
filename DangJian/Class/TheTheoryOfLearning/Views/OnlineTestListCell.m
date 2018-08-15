//
//  OnlineTestListCell.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestListCell.h"

@interface OnlineTestListCell ()
@property (nonatomic, strong) UILabel *timeLabel;//考试时间
@property (nonatomic, strong) UILabel *dateLabel;//考试日期
@property (nonatomic, strong) UILabel *titleLabel;//试卷名字
@property (nonatomic, strong) UILabel *scoreLabel;//考试成绩
@property (nonatomic, strong) UIImageView *passImageView;//是否通过标志
@property (nonatomic, strong) UIView *leftStateView;//左边显示状态的颜色条
@end

@implementation OnlineTestListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = SystemGrayBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UIView *backView = [[UIView alloc] init];
      [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(10);
        make.bottom.offset(-2);
    }];
    
    backView.backgroundColor= [UIColor whiteColor];
    backView.layer.cornerRadius= 4.0f;
    backView.layer.shadowColor= Color_system_red.CGColor;
    backView.layer.shadowOffset=CGSizeMake(1, 1);
    backView.layer.shadowOpacity=0.1;
    backView.layer.shadowRadius=1;

    //左边竖条
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 108)];
    [backView addSubview:leftView];
    leftView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    UIBezierPath  *maskPath= [UIBezierPath  bezierPathWithRoundedRect:leftView.bounds
                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                          cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer*maskLayer = [[CAShapeLayer  alloc]  init];
    maskLayer.frame = leftView.bounds;
    maskLayer.path = maskPath.CGPath;
    leftView.layer.mask = maskLayer;
    _leftStateView = leftView;
    
//    试卷名lable
    UILabel *titleLabel = [[UILabel alloc] init];
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(20);
        make.top.offset(10);
        make.right.offset(-90);
    }];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = Color_3;
    titleLabel.font = FontScale_15;
    _titleLabel = titleLabel;
    
    //成绩
    UILabel *scoreLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:Color_system_red textAligment:NSTextAlignmentRight numberOfLines:1 text:nil font:FontScale_15];
    [backView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- 15);
        make.centerY.mas_equalTo(titleLabel);
    }];
    scoreLabel.hidden = YES;
    _scoreLabel = scoreLabel;
    
//    考试起止日期
    UILabel *dateLabel = [[UILabel alloc] init];
    [backView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.bottom.offset(-15);
        make.right.offset(-20);
    }];
    dateLabel.textColor = Color_6;
    dateLabel.text = @"考试截止日期：";
    dateLabel.font = FontScale_13;
    _dateLabel = dateLabel;

    //考试时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.bottom.mas_equalTo(dateLabel.mas_top).offset(-5);
    }];
    timeLabel.text = @"考试时间：";
    timeLabel.textColor = Color_6;
    timeLabel.font = FontScale_14;
    timeLabel.hidden = YES;
    _timeLabel = timeLabel;
    
    UIImageView *passImageView = [[UIImageView alloc] init];
    [backView addSubview:passImageView];
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(scoreLabel.mas_right);
        make.top.offset(40);
        make.bottom.offset(-5);
        make.width.mas_equalTo(passImageView.mas_height);
    }];
    passImageView.contentMode = UIViewContentModeScaleAspectFit;
    passImageView.hidden = YES;
    _passImageView = passImageView;
    

}
- (void)setTestVo:(OnlineTestPaperListVo *)testVo {
    
    _timeLabel.hidden = NO;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
        make.right.offset(-20);
    }];
    _timeLabel.text = [NSString stringWithFormat:@"考试时间：%ld分钟",(long)testVo.duration];
    _dateLabel.text = [NSString stringWithFormat:@"考试截止日期：%@",testVo.expire];
    _titleLabel.text = [NSString stringWithFormat:@"%@",testVo.title];
    if (testVo.isexpire) {
        _leftStateView.backgroundColor = Color_system_red;
    } else {
        _leftStateView.backgroundColor = Color_c;
    }
}

#pragma mark -- setter
- (void)setHistoryScoreVo:(OnlineTestPaperListVo *)historyScoreVo {
    
  
    _passImageView.hidden = NO;
    _scoreLabel.hidden = NO;
    _scoreLabel.text = [NSString stringWithFormat:@"%@分",historyScoreVo.value];
    _dateLabel.text = [NSString stringWithFormat:@"考试日期：%@",historyScoreVo.examDate];
    _titleLabel.text = [NSString stringWithFormat:@"%@",historyScoreVo.examName];
    if ([historyScoreVo.pass boolValue] == YES) {
        _leftStateView.backgroundColor = HexRGB(0x39ae4a);
        _scoreLabel.textColor = HexRGB(0x39ae4a);
        //通过考试
        [_passImageView setImage:[UIImage imageNamed:@"onlineTest_pass_icon"]];
    } else {
//        未通过
        _leftStateView.backgroundColor = Color_c;
        _scoreLabel.textColor = Color_system_red;
        [_passImageView setImage:[UIImage imageNamed:@"onlineTest_noPass_icon"]];
    }
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
