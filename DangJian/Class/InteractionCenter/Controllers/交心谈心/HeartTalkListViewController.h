//
//  HeartTalkListViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface HeartTalkListViewController : EaseConversationListViewController
@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end
