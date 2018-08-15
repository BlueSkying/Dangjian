//
//  MYCalendarCollectionCell.m
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "MYCalendarCollectionCell.h"
#import "MYCalendarDayModel.h"

@interface MYCalendarCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *upLB;

@property (weak, nonatomic) IBOutlet UILabel *downLB;

//动画
@property (weak, nonatomic) IBOutlet UIView *animationView;
/**下方灰点*/
@property (weak, nonatomic) IBOutlet UIView *dotView;

@end

@implementation MYCalendarCollectionCell
- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.animationView.layer.cornerRadius = 22;
    
    self.dotView.layer.cornerRadius = 2;
    self.dotView.backgroundColor = [UIColor clearColor];
    self.upLB.font = FONT_17;
    self.upLB.textColor = HexRGB(0x333333);
    self.downLB.font = [UIFont systemFontOfSize:10];
    self.downLB.textColor = HexRGB(0x666666);
}

- (void)setModel:(MYCalendarDayModel *)model {

    if (model == nil) {
        
        self.upLB.text = @"";
        self.downLB.text = @"";
        
        //设置不能选中
        self.userInteractionEnabled = NO;
        self.animationView.backgroundColor = [UIColor clearColor];
        self.animationView.layer.borderWidth = 0;
        self.dotView.backgroundColor = [UIColor clearColor];
        return;
    }
    _model = model;
    
    //获取今天日期
    NSString *today = [TyunTool getTodayDate];
    
    
    if (!model.workDayDate || [model.workDayDate isEqualToString:@""]) {
        
        self.animationView.layer.borderWidth = 0;
        self.animationView.layer.borderColor = [UIColor clearColor].CGColor;
        self.animationView.backgroundColor = [UIColor clearColor];
        self.upLB.textColor = HexRGB(0x333333);
        self.downLB.textColor = HexRGB(0x666666);
        self.dotView.backgroundColor = [UIColor clearColor];
    } else {
        
        self.animationView.backgroundColor = [UIColor clearColor];
        self.upLB.textColor = HexRGB(0x333333);
        self.downLB.textColor = HexRGB(0x666666);
        self.dotView.backgroundColor = Color_system_red;
    }


    
    
    
    
    if ([model.gong_li isEqualToString:today]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MYTodayCell" object:self];
        });
    }
    
    
    self.userInteractionEnabled = YES;
    //公历日
    self.upLB.text = model.gongli_Day;
    //藏历日
    self.downLB.text = model.day;

}

- (void)setIsMySelcted:(BOOL)isMySelcted {
    
    _isMySelcted = isMySelcted;
    
    
    //设置选中状态
    if (isMySelcted == YES) {
        //遮罩
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.animationView.backgroundColor = Color_system_red;
        } completion:nil];
        
        //文字颜色
        self.upLB.textColor = [UIColor whiteColor];
        self.downLB.textColor = [UIColor whiteColor];
        self.dotView.backgroundColor = [UIColor clearColor];
        if (self.model.workDayDate) {
            self.dotView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        //未选中状态
        //需要判断多层结构
        
    //如果是工作日
        if (self.model.workDayDate) {
            
            self.animationView.backgroundColor = [UIColor clearColor];
            self.upLB.textColor = HexRGB(0x333333);
            self.downLB.textColor = HexRGB(0x666666);
            self.dotView.backgroundColor = Color_system_red;
        }
        //如果是当天的
        if ([[TyunTool getTodayDate] isEqualToString:self.model.gong_li]) {
            self.animationView.layer.borderWidth = 1;
            self.animationView.layer.borderColor = Color_system_red.CGColor;
            self.animationView.backgroundColor = [UIColor clearColor];
            self.upLB.textColor = HexRGB(0x333333);
            self.downLB.textColor = HexRGB(0x666666);
            self.dotView.backgroundColor = [UIColor clearColor];
            if (self.model.workDayDate) {
                self.dotView.backgroundColor = Color_system_red;
            }
        }
      //  如果既不是工作日也不是当天的提醒
        if (!self.model.workDayDate && ![[TyunTool getTodayDate] isEqualToString:self.model.gong_li]) {
            
            self.animationView.backgroundColor = [UIColor clearColor];
            self.animationView.layer.borderWidth = 0;
            self.upLB.textColor = HexRGB(0x333333);
            self.downLB.textColor = HexRGB(0x666666);
            self.dotView.backgroundColor = [UIColor clearColor];
        }

    }
}

@end
