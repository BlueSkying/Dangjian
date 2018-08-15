/*!
 *  \~chinese
 *  @header IEMContactManager.h
 *  @abstract 此协议定义了好友相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMContactManager.h
 *  @abstract The protocol defines the operations of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMContactManagerDelegate.h"

@class EMError;

/*!
 *  \~chinese
 *  好友相关操作
 *
 *  \~english
 *  Contact Management
 */
@protocol IEMContactManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 */
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 
 */
- (void)removeDelegate:(id)aDelegate;

/*!
 *  \~chinese
 *  获取本地存储的所有好友
 *
 *  @result 好友列表<NSString>
 *

 */
- (NSArray *)getContacts;

/*!
 *  \~chinese
 *  从本地获取黑名单列表
 *
 *  @result 黑名单列表<NSString>
 *

 */
- (NSArray *)getBlackList;

#pragma mark - Sync method

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError 错误信息
 *
 *  @return 好友列表<NSString>
 *

 */
- (NSArray *)getContactsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  添加好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  要添加的用户
 *  @param aMessage   邀请信息
 *
 *  @return 错误信息
 *

 */
- (EMError *)addContact:(NSString *)aUsername
                message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  删除好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要删除的好友
 *  @param aIsDeleteConversation 是否删除会话
 *
 *  @return 错误信息
 *

 */
- (EMError *)deleteContact:(NSString *)aUsername
          isDeleteConversation:(BOOL)aIsDeleteConversation;

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError 错误信息
 *
 *  @return 黑名单列表<NSString>
 *

 */
- (NSArray *)getBlackListFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要加入黑命单的用户
 *  @param aBoth     是否同时屏蔽发给对方的消息
 *
 *  @return 错误信息
 *

 */
- (EMError *)addUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth;

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要移出黑命单的用户
 *
 *  @return 错误信息
 *

 */
- (EMError *)removeUserFromBlackList:(NSString *)aUsername;

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 申请者
 *
 *  @return 错误信息
 *

 */
- (EMError *)acceptInvitationForUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 申请者
 *
 *  @return 错误信息
 *
 
 */
- (EMError *)declineInvitationForUsername:(NSString *)aUsername;

#pragma mark - Async method

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  @param aCompletionBlock 完成的回调
 *
 
 */
- (void)getContactsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加好友
 *
 *  @param aUsername        要添加的用户
 *  @param aMessage         邀请信息
 *  @param aCompletionBlock 完成的回调
 *

 */
- (void)addContact:(NSString *)aUsername
           message:(NSString *)aMessage
        completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除好友
 *
 *  @param aUsername                要删除的好友
 *  @param aIsDeleteConversation    是否删除会话
 *  @param aCompletionBlock         完成的回调
 *

 */
- (void)deleteContact:(NSString *)aUsername
     isDeleteConversation:(BOOL)aIsDeleteConversation
           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  @param aCompletionBlock 完成的回调
 *

 */
- (void)getBlackListFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  @param aUsername        要加入黑命单的用户
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Add a user to blacklist
 *
 
 */
- (void)addUserToBlackList:(NSString *)aUsername
                completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  @param aUsername        要移出黑命单的用户
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)removeUserFromBlackList:(NSString *)aUsername
                     completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aCompletionBlock 完成的回调
 *

 */
- (void)approveFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aCompletionBlock 完成的回调
 *
 
 */
- (void)declineFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 */
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMContactManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  从数据库获取所有的好友
 *
 *  @return 好友列表<NSString>
 *

 */
- (NSArray *)getContactsFromDB __deprecated_msg("Use -getContacts");

/*!
 *  \~chinese
 *  从数据库获取黑名单列表
 *
 *  @return 黑名单列表<NSString>
 *

 */
- (NSArray *)getBlackListFromDB __deprecated_msg("Use -getBlackList");

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *

 */
- (void)asyncGetContactsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getContactsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  添加好友
 *
 *  @param aUsername        要添加的用户
 *  @param aMessage         邀请信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *

 */
- (void)asyncAddContact:(NSString *)aUsername
                message:(NSString *)aMessage
                success:(void (^)())aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addContact:message:completion:");

/*!
 *  \~chinese
 *  删除好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要删除的好友
 *
 *  @return 错误信息
 *

 */
- (EMError *)deleteContact:(NSString *)aUsername __deprecated_msg("Use -deleteContact:username:isDeleteConversation:");


/*!
 *  \~chinese
 *  删除好友
 *
 *  @param aUsername        要删除的好友
 *  @param aCompletionBlock 完成的回调
 *

 */
- (void)deleteContact:(NSString *)aUsername
           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock __deprecated_msg("Use -deleteContact:username:isDeleteConversation:");

/*!
 *  \~chinese
 *  删除好友
 *
 *  @param aUsername            要删除的好友
 *  @param aSuccessBlock        成功的回调
 *  @param aFailureBlock        失败的回调
 *
 
 */
- (void)asyncDeleteContact:(NSString *)aUsername
                   success:(void (^)())aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -deleteContact:completion:");

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 
 */
- (void)asyncGetBlackListFromServer:(void (^)(NSArray *aList))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getBlackListFromServerWithCompletion:");

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  @param aUsername        要加入黑命单的用户
 *  @param aBoth            是否同时屏蔽发给对方的消息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
- (void)asyncAddUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth
                        success:(void (^)())aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addUserToBlackList:completion:");

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  @param aUsername        要移出黑命单的用户
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Remove user from blacklist
 *
 */
- (void)asyncRemoveUserFromBlackList:(NSString *)aUsername
                             success:(void (^)())aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeUserFromBlackList:completion:");

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Agree invitation
 *
 */
- (void)asyncAcceptInvitationForUsername:(NSString *)aUsername
                                 success:(void (^)())aSuccessBlock
                                 failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveFriendRequestFromUser:completion:");

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
- (void)asyncDeclineInvitationForUsername:(NSString *)aUsername
                                  success:(void (^)())aSuccessBlock
                                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineFriendRequestFromUser:completion:");
@end
