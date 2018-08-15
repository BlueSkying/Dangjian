//
//  AppDelegate.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/21.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;

@property (strong, nonatomic) MainTabBarController *mainController;

@end

