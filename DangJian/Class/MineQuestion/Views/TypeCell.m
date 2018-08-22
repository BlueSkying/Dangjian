//
//  TypeCell.m
//  LifePro
//
//  Created by huangchen on 16/10/10.
//  Copyright © 2016年 gaoyong. All rights reserved.
//

#import "TypeCell.h"
#import "UIColor+expanded.h"
@implementation TypeCell
{
    NSMutableArray * btnArray;
    UIView * linvView;
}

#define width  kScreen_Width/2
#define height 50

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        btnArray = [[NSMutableArray alloc]initWithCapacity:2];
        [self addContentCell];
    }
    return self;
}

-(void)addContentCell{
    for(int i=0;i<2;i++){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame= CGRectMake(0+width*i, 0, width, 50);
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"2bb2c1"] forState:UIControlStateSelected];
        if(i==0){
            [btn setTitle:@"进行中" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"已完成" forState:UIControlStateNormal];
        }
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btnArray addObject:btn];
    }
    
    linvView =[[UIView alloc]initWithFrame:CGRectMake(0, 49, width,2)];
    linvView.backgroundColor=[UIColor colorWithHexString:@"2bb2c1"];
    [self addSubview:linvView];
    
    [self btnClick:[btnArray objectAtIndex:0]];  //默认选中第一个
}

-(void)setInfo:(NSDictionary *)dict{
    
}

-(void)btnClick:(UIButton *)sender{
    for(UIButton * tempbtn in btnArray){
        tempbtn.selected=NO;
        if(sender.tag == tempbtn.tag){
            sender.selected=YES;
        }
    }
    float  x_Temp=0;
    if(sender.tag==1){
        x_Temp=width;
    }
    // 改变按钮下面横线的位置坐标
    [UIView animateWithDuration:0.3 animations:^(void){
        linvView.frame=CGRectMake(x_Temp,49,width,2);
    }completion:^(BOOL finishde){
        
    }];
    
    // 按钮点击回调
    if(self.TypeBtnClickBlock){
        self.TypeBtnClickBlock(sender.tag);
    }
}

@end
