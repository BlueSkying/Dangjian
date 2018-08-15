//
//  MainTabBar.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MainTabBar.h"
#import "MainTabBarButton.h"

@interface MainTabBar ()
{
    UIView *_redPoint;
    NSInteger _followUpCount;
}
@property(nonatomic, strong)NSMutableArray *tabbarBtnArray;
@property(nonatomic, weak)UIButton *writeButton;
@property(nonatomic, weak)MainTabBarButton *selectedButton;

@end

@implementation MainTabBar
- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.subviews.count);
    CGFloat btnH = self.frame.size.height;
    
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        MainTabBarButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
        if (nIndex == 1) {
            _redPoint = [[UIView alloc] initWithFrame:CGRectMake(btnW/2 + 13, 5, 8, 8)];
            [_redPoint setBackgroundColor:[UIColor redColor]];
            [_redPoint.layer setMasksToBounds:YES];
            [_redPoint.layer setCornerRadius:4.0f];
            _redPoint.tag = 0;
            [tabBarBtn addSubview:_redPoint];
            [_redPoint setHidden:YES];
        }
    }
    
}

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem defaultSelectedIndex:(NSInteger)index;
{
    MainTabBarButton *tabBarBtn = [[MainTabBarButton alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabbarBtnArray addObject:tabBarBtn];
    //default selected first one
    if (self.tabbarBtnArray.count == index) {
        [self ClickTabBarButton:tabBarBtn];
    }
}
- (void)ClickTabBarButton:(MainTabBarButton *)tabBarBtn{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
    self.selectedButton.selected = NO;
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}

#pragma mark publick 点击tabbar
- (void)tabBarSelectedIndex:(NSUInteger)index {
    
    //点击
    MainTabBarButton *tabBarBtn = self.tabbarBtnArray[index];
    if (tabBarBtn) {
        [self ClickTabBarButton:tabBarBtn];
    }
    
}

-(void)dealloc {
    
}



@end
