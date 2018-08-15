//
//  OnlineTestCountdownView.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestCountdownView.h"

@interface OnlineTestCountdownView ()

@property (nonatomic, strong) dispatch_source_t timer; //定时器

@property (nonatomic, strong) UILabel *timeLabel; //显示时间

@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation OnlineTestCountdownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
     
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView {
    
    __weak typeof(self) weakSelf = self;

    UIImageView *promptImageView = [[UIImageView alloc] init];
    [self addSubview:promptImageView];
    [promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(12);
        make.width.offset(12);
        make.height.mas_equalTo(promptImageView.mas_width);
        
    }];
    promptImageView.image = [UIImage imageNamed:@"onlineTest_remind_icon"];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    [self addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(promptImageView.mas_right).offset(5);
        make.top.offset(11);
        make.right.offset(-15);
    }];
    detailLabel.font = FONT_12;
    detailLabel.textColor = Color_8;
    detailLabel.text = @"测试考试内容啊";
    detailLabel.numberOfLines = 0;
    _detailLabel = detailLabel;
    
    UILabel *remainingLabel = [[UILabel alloc] init];
    [self addSubview:remainingLabel];
    [remainingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    remainingLabel.text = @"剩余考试时间";
    remainingLabel.font = FONT_16;
    remainingLabel.textColor = Color_6;
    

    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(remainingLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    timeLabel.text = @"00:00:00";
    timeLabel.font = [UIFont systemFontOfSize:26];
    timeLabel.textColor = Color_system_red;
    _timeLabel = timeLabel;
    
}
#pragma maerk - setter
- (void)setCountdown:(NSInteger)countdown {
    _countdown = countdown;
    if (_countdown > 0) [self createTimer];
}
- (void)setTestDescribe:(NSString *)testDescribe {
    
    _detailLabel.text = testDescribe;
}

#pragma mark - 定时器 (GCD)
- (void)createTimer {
    
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block NSInteger timeout = _countdown * 60 + 1;
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(weakSelf.timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时
        if (timeout <= 0) {
            //关闭定时器
            dispatch_source_cancel(weakSelf.timer);
            //MRC下需要释放，这里不需要
            //            dispatch_realse(timer);
            //注意: ，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            dispatch_async(dispatch_get_main_queue(), ^{
                //时间用完了啊
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onlineTestCountdownViewOutOfTime)]) {
                    [weakSelf.delegate onlineTestCountdownViewOutOfTime];
                }
              
            });
        } else {
            
            //处于正在倒计时，在主线程中刷新上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //重新计算 时/分/秒
                NSString *str_hour = [NSString stringWithFormat:@"%02ld",(long)(timeout/3600)];
                NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(timeout%3600)/60];
                NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)(timeout%60)];
                
                NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
                //修改倒计时标签及显示内容
//                NSLog(@"%@",format_time);
                weakSelf.timeLabel.text = format_time;
            });
        }
    });
    
    dispatch_resume(_timer);
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, Color_c.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, 0, CGRectGetMaxY(rect) - 1);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.frame.size.width, CGRectGetMaxY(rect) - 1);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {1,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

/**
 *  停止倒计时
 *  别小看销毁定时器，没用好可就内存泄漏咯
 */
- (void)dealloc {
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    
}
@end
