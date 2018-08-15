//
//  HeartTalkListViewController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "HeartTalkListViewController.h"
#import "AddressBookTableViewController.h"
#import "UserFmdbManager.h"

@interface HeartTalkListViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@property (nonatomic, strong) UIView *networkStateView;

@end

@implementation HeartTalkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpNavigationBar];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = SystemGrayBackgroundColor;
    self.tableView.backgroundColor = SystemGrayBackgroundColor;
    
    [EaseConversationCell appearance].detailLabelColor = Color_6;
    [EaseConversationCell appearance].timeLabelColor = Color_6;
    [EaseConversationCell appearance].titleLabelColor = Color_3;
    [EaseImageView appearance].imageCornerRadius = 25;
    
    //nstification messagechange
    [MyNotification addObserver:self selector:@selector(messageListChange:) name:NotificationMessageListChange object:nil];
    
    
    [self tableViewDidTriggerHeaderRefresh];
    [self removeEmptyConversationsFromDB];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
    [self refresh];
}
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}
#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            
            UIViewController *chatController = nil;
            
            chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = (conversationModel.title && conversationModel.title.length > 0) ? conversationModel.title : conversation.conversationId;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
  
            UserContactModel *profileEntity = [UserFmdbManager searchUserName:conversation.conversationId];
            if (profileEntity) {
                model.title = profileEntity.nickname == nil ? profileEntity.account : profileEntity.nickname;
                model.avatarURLPath = profileEntity.image;
                model.avatarImage = [UIImage imageNamed:@"addressBook_placeholder_header_icon"];
            }
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"addressBook_placeholder_header_icon";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"addressBook_placeholder_header_icon" : @"addressBook_placeholder_header_icon";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserContactModel *profileEntity = [UserFmdbManager searchUserName:from];

            if (profileEntity) {
                from = (profileEntity.nickname && profileEntity.nickname.length > 0) ? profileEntity.nickname : profileEntity.account;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
    
}
#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}
#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}



- (void)setUpNavigationBar {
 
    self.navigationItem.title = @"交心谈心";
    [self setNavigationRightBarButtonWithImageNamed:@"navBar_chatRoom_icon"];

}


//设置右导航栏按钮
-(void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, +15, 0, -15);
    rightButton.imageView.contentMode = UIViewContentModeRight;
    
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setAdjustsImageWhenHighlighted:NO];
    rightButton.custom_acceptEventInterval = 1;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    self.navigationItem.rightBarButtonItems
    = @[rightBarButton];
}

#pragma mark - notification list
- (void)messageListChange:(NSNotification *)sender {
    
    //消息列表发生变化
 
}



#pragma mark - right action 通讯录
- (void)rightButtonTouchUpInside:(UIButton *)sender {
    
    AddressBookTableViewController *addressBookView = [[AddressBookTableViewController alloc] init];
    
    [self.navigationController pushViewController:addressBookView animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
