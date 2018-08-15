//
//  AddressSectionHeaderView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AddressSectionHeaderView.h"

#define YUFoldingIconSize                13.0f

@interface AddressSectionHeaderView (){
    
    //view的唯一标示tag
    NSInteger _section;
    
    //分组名字
    UILabel *_groupNameLabel;
    
    //成员数量的Label
    UILabel *_numberLB;
    
    
}


@property (nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic, strong)UIView *bootmLine;

@end

@implementation AddressSectionHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *headerId = @"headerView";
    AddressSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (headerView == nil) {
        headerView = [[AddressSectionHeaderView alloc] initWithReuseIdentifier:headerId];
    }
    
    return headerView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initCustomView];
        [self reloadUI];

    }
    return self;
}

-(void)reloadUI{
    
    if (self.sectionState == YUFoldingSectionStateShow) {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.bootmLine.hidden = YES;
        
    } else {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        self.bootmLine.hidden = NO;
    }
}


-(void)initCustomView{

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backView;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImageView.image = [UIImage imageNamed:@"addressbook_header_icon"];
    [backView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(backView);
        make.width.offset(YUFoldingIconSize);
        make.height.offset(YUFoldingIconSize);

    }];
    
    UIView *bootmline = [[UIView alloc] init];
    [backView addSubview:bootmline];
    [bootmline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(.5);
    }];
    bootmline.backgroundColor = SystemGraySeparatedLineColor;
    _bootmLine = bootmline;
    
    //为头视图添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    
    
   


    //右边组员个数显示
    UILabel *numberLB = [[UILabel alloc] init];
    numberLB.textAlignment = NSTextAlignmentRight;
    numberLB.font = FONT_15;
    numberLB.textColor = Color_9;
    [backView addSubview:numberLB];
    [numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.centerY.mas_equalTo(backView);
        make.width.offset(28);
    }];
    _numberLB = numberLB;
    
    
    //    创建的显示文字的label
    UILabel *groupLabel = [[UILabel alloc] init];
    [backView addSubview: groupLabel];
    [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.right.lessThanOrEqualTo(numberLB.mas_left).offset(-5);
    }];
    groupLabel.numberOfLines = 0;
    groupLabel.font = FONT_17;
    groupLabel.textColor = Color_3;
    _groupNameLabel = groupLabel;
}

-(void)setTitleName:(NSString *)titleName{
    _groupNameLabel.text = titleName;
    
}
-(void)setGroupCount:(NSString *)groupCount{
    _numberLB.text = groupCount;
}

- (void)setSectionState:(YUFoldingSectionState)sectionState {
    
    _sectionState = sectionState;
    [self reloadUI];
}



-(void)handleTap:(UIGestureRecognizer *)sender{
    
    
    [self shouldExpand:![NSNumber numberWithInteger:self.sectionState].boolValue];
    self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionViewSelectViewSection:)]) {
        
        [self.delegate sectionViewSelectViewSection:_section];
    }
}
-(void)shouldExpand:(BOOL)shouldExpand
{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (shouldExpand) {
                             self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                         } else {
                             self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
                         }
                     } completion:^(BOOL finished) {
                         if (finished == YES) {
                             self.bootmLine.hidden = shouldExpand;
                         }
                     }];
}

//重置frame
-(void)layoutSubviews{
    CGRect frame = self.frame;
    [self setFrame:frame];
}

@end
