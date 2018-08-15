//
//  SKCircleView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKCircleView.h"
#import "NSTimer+sk_blockSupport.h"

static const CGFloat progressStrokeWidth = 7;

@interface SKCircleView () {
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;//用来填充的图层
    UIBezierPath *backGroundBezierPath;//背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;//用来填充的贝赛尔曲线
    
    UIColor *progressColor;//进度条颜色
    UIColor *progressTrackColor;//进度条轨道颜色
    
    NSTimer * timer;//定时器用作动画
    CGPoint center;//中心点
}
@end

@implementation SKCircleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        progressColor = [UIColor whiteColor];
        progressTrackColor = Color_system_red;
        
        //创建背景图层
        backGroundLayer = [CAShapeLayer layer];
        backGroundLayer.fillColor = nil;
        backGroundLayer.frame = self.bounds;
        
        //创建填充图层
        frontFillLayer = [CAShapeLayer layer];
        frontFillLayer.fillColor = nil;
        frontFillLayer.frame = self.bounds;
        
        UILabel *contenLabel = [[UILabel alloc] init];
        [contenLabel setText:@"00"];
        [contenLabel setTextAlignment:NSTextAlignmentRight];
        [contenLabel setTextColor:[UIColor whiteColor]];
        [contenLabel setFont:[UIFont systemFontOfSize:45]];
        [self addSubview:contenLabel];
        _contentLabel = contenLabel;
        __weak typeof(self) weakSelf = self;
        [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf);
            make.top.offset(30);
            make.height.offset(35);
        }];
        
        UILabel *percentageLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:[UIColor whiteColor] textAligment:NSTextAlignmentLeft numberOfLines:1 text:@"%" font:FONT_17];
        [self addSubview:percentageLabel];
        [percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contenLabel.mas_right);
            make.bottom.mas_equalTo(contenLabel.mas_bottom);
        }];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setTextAlignment:NSTextAlignmentCenter];
        [detailLabel setTextColor:[UIColor whiteColor]];
        [detailLabel setText:@"积分达标进度"];
        detailLabel.font = FONT_15;
        detailLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(contenLabel.mas_bottom).offset(10);
        }];
        frontFillLayer.strokeColor = progressColor.CGColor;
        backGroundLayer.strokeColor = progressTrackColor.CGColor;
        
        center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-progressStrokeWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        backGroundLayer.path = backGroundBezierPath.CGPath;
        
        frontFillLayer.lineWidth = progressStrokeWidth;
        backGroundLayer.lineWidth = progressStrokeWidth;
        
        [self.layer addSublayer:backGroundLayer];
        [self.layer addSublayer:frontFillLayer];
    }
    
    return self;
}


- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    __weak typeof(self) wSelf = self;
    __block double progress = 0.0;
    timer = [NSTimer sk_scheduledTimerWithTimeInterval:0.01 block:^{
        
        if (progress >= _progressValue || progress >= 1.0f) {
            if (timer) {
                [timer invalidate];
                timer = nil;
                [wSelf fillPathContent:progress];
            }
            return;
        } else {
            [wSelf fillPathContent:progress];
        }
        progress += 0.01 * (_progressValue);
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)fillPathContent:(CGFloat)progress {
    
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-progressStrokeWidth)/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*progress-M_PI_2 clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    self.contentLabel.text = [NSString stringWithFormat:@"%ld",(long)(progress * 100)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
