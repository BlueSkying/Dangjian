//
//  MainTabBarController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface MainTabBarController : UITabBarController{
    EMConnectionState _connectionState;
}

//设置默认选中的tabbar
-(id)initWithSelectIndex:(NSInteger)index;

@property (nonatomic, assign) NSInteger selectTabIndex;


//- (void)jumpToChatList;
- (void)setupUnreadMessageCount;
//
//- (void)networkChanged:(EMConnectionState)connectionState;
//
//- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
//
- (void)didReceiveUserNotification:(UNNotification *)notification;
//
- (void)playSoundAndVibration;
//
- (void)showNotificationWithMessage:(EMMessage *)message;
@end
