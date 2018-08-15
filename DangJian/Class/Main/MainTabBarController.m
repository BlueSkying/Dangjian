//
//  MainTabBarController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "MainNavigationController.h"
#import "UIImage+CornerRadius.h"
#import "HeartTalkListViewController.h"
#import "UserFmdbManager.h"


#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface MainTabBarController ()<MainTabBarDelegate> {

    NSInteger _selectIndex;
    HeartTalkListViewController *_chatListVC;

}
@property(nonatomic, weak)MainTabBar *mainTabBar;
//记录退出时间
@property (nonatomic , assign) CFAbsoluteTime recordLogoutTime;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    [self setupUnreadMessageCount];
}
-(id)initWithSelectIndex:(NSInteger)index {
    if (self = [super init]) {
        _selectIndex = index;
        
        [self SetupMainTabBar];
        [self SetupAllControllers];
        
        
        UIColor *shadowColor = [Color_systemNav_red_top colorWithAlphaComponent:0.1];
        [self.tabBar setShadowImage:[UIImage imageWithColor:shadowColor size:CGSizeMake(kScreen_Width,2)]];
                //去掉TabBar的分割线
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:shadowColor size:CGSizeMake(kScreen_Width,2)]];
        

    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
}

- (void)SetupMainTabBar {
    
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{
    
    _chatListVC = [[HeartTalkListViewController alloc] init];

    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"NewsViewController",
                                   kTitleKey  : @"党建要闻",
                                   kImgKey    : @"tabBar_newsOfTheParty_unSelected_icon",
                                   kSelImgKey : @"tabBar_newsOfTheParty_selected_icon"},
                                 
                                 @{kClassKey  : @"NoticeViewController",
                                   kTitleKey  : @"通知公告",
                                   kImgKey    : @"tabBar_announcements_unSelected_icon",
                                   kSelImgKey : @"tabBar_announcements_selected_icon"},
                                 
                                 @{kClassKey  : @"TheoryLearningViewController",
                                   kTitleKey  : @"理论学习",
                                   kImgKey    : @"tabBar_theTheoryOfLearning_unSelected_icon",
                                   kSelImgKey : @"tabBar_theTheoryOfLearning_selected_icon"},
                                 
                                 @{kClassKey  : @"OrganizationViewController",
                                   kTitleKey  : @"组织管理",
                                   kImgKey    : @"tabBar_organizationConstruction_unSelected_icon",
                                   kSelImgKey : @"tabBar_organizationConstruction_selected_icon"},
                                 
                                 @{kClassKey  : @"InteractionCenterViewController",
                                   kTitleKey  : @"互动中心",
                                   kImgKey    : @"tabBar_interactionCenter_unSelected_icon",
                                   kSelImgKey : @"tabBar_interactionCenter_selected_icon"}];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        UIViewController *childVC = [NSClassFromString(dict[kClassKey]) new];
        [self setupOneChildVcWithVc:childVC image:dict[kImgKey] selectedImage:dict[kSelImgKey] title:dict[kTitleKey]];
    }];
    
}


- (void)setupOneChildVcWithVc:(UIViewController *)childVc
                        image:(NSString *)image
                selectedImage:(NSString *)selectedImage
                        title:(NSString *)title {
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    childVc.tabBarItem.title = title;
    childVc.navigationItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem defaultSelectedIndex:_selectIndex];
    [self addChildViewController:nav];
}

#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    
    self.selectedIndex = toBtnTag;
}

#pragma mark --setter
- (void)setSelectTabIndex:(NSInteger)selectTabIndex {
    
    [self.mainTabBar tabBarSelectedIndex:selectTabIndex];
    
}


-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], NSFontAttributeName,
                                        [UIColor whiteColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}



// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}




- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        DDLogInfo(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSEaseLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSEaseLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSEaseLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSEaseLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [UserFmdbManager searchUserName:message.from].nickname;
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSEaseLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSEaseLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSEaseLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSEaseLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
//    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
//    }
//    else if(_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
//    else if (_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    if (!notification) return;
    
    //点击通知跳到聊天页面或者列表页面
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *conversationChatter = userInfo[kConversationChatter];
    EMChatType messageType = [userInfo[kMessageType] intValue];
    //群组不需要跳转
    if (messageType != EMChatTypeChat) return;
    
    //如果聊天对象存在
    if (conversationChatter) {
   
        if ([[Helper topViewController].navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            
            [[Helper topViewController].navigationController popViewControllerAnimated:YES];
        }
        UserContactModel *profileEntity = [UserFmdbManager searchUserName:conversationChatter];
        NSString *nickName = conversationChatter;
        if (profileEntity) {
            nickName = (profileEntity.nickname && profileEntity.nickname.length > 0) ? profileEntity.nickname : profileEntity.account;
        }
        
        NSArray *viewControllers = [Helper topViewController].navigationController.viewControllers;
        if (viewControllers.count > 0) {
            [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                //                    判断当前页面是不是首页
                if (idx > 0) {
                    //                        不是首页就一直pop回去
                    //                        判断当前页面是不是聊天页面
                    if (![obj isKindOfClass:[ChatViewController class]]) {
                        //如果不是聊天页面则向前返回一个页面
                        [[Helper topViewController].navigationController popViewControllerAnimated:NO];
                    } else {
                        
                        ChatViewController *chatViewController = (ChatViewController *)obj;
                        //                            当前页面时聊天页面
                        //                            如果id不一样  返回重新初始化 如果一样不执行操作
                        if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter]) {
                            
                            [[Helper topViewController].navigationController popViewControllerAnimated:NO];
                            
                            chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                            chatViewController.title = nickName;
                            [[Helper topViewController].navigationController pushViewController:chatViewController animated:NO];
                        }
                        *stop= YES;
                    }
                } else {
                    
                    //                        从首页跳转到聊天页面
                    [self pushToChatViewControllerChatter:conversationChatter messageType:messageType nickName:nickName];
                    
                }
            }];
        } else {
            //                从首页跳转到聊天页面
            [self pushToChatViewControllerChatter:conversationChatter messageType:messageType nickName:nickName];
        }
    }
//    else if (_chatListVC) {
//        //如果没有聊天对象就到聊天列表
//        [[Helper topViewController].navigationController pushViewController:_chatListVC animated:YES];
//    }
}

- (void)pushToChatViewControllerChatter:(NSString *)chatter messageType:(EMChatType)messageType nickName:(NSString *)nickName {
    
    
    //从首页跳到聊天页面
    HeartTalkListViewController *talkListView = [[HeartTalkListViewController alloc] init];
    [[Helper topViewController].navigationController pushViewController:talkListView animated:NO];
    
    ChatViewController *chatViewController = nil;
    chatViewController = [[ChatViewController alloc] initWithConversationChatter:chatter conversationType:[self conversationTypeFromMessageType:messageType]];
    chatViewController.title = nickName;
    [[Helper topViewController].navigationController pushViewController:chatViewController animated:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
