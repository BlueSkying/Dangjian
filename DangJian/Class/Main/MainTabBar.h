//
//  MainTabBar.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;

@protocol MainTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;
- (void)tabBarClickWriteButton:(MainTabBar *)tabBar;
@end

@interface MainTabBar : UIView
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem defaultSelectedIndex:(NSInteger)index;

@property(nonatomic, weak)id <MainTabBarDelegate>delegate;

- (void)tabBarSelectedIndex:(NSUInteger)index;

@end
