//
//  ChatHelper.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabBarController.h"
#import "ChatViewController.h"
#import "HeartTalkListViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

@interface ChatHelper : NSObject<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

@property (nonatomic, weak) MainTabBarController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

@property (nonatomic, weak) HeartTalkListViewController *conversationListVC;


+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

@end
