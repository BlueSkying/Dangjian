/*!
 *  \~chinese
 *  @header EMContactManagerDelegate.h
 *  @abstract 此协议定义了好友相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMContactManagerDelegate.h
 *  @abstract This protocol defined the callbacks of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class EMError;

/*!
 *  \~chinese
 *  好友相关的回调
 *
 *  \~english
 *  Callbacks of contact
 */
@protocol EMContactManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *

 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A，B会收到这个回调
 *
 *  @param aUsername   用户B
 *
 
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *

 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *

 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidApproveByUser:");

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *

 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidDeclineByUser:");

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *

 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidRemoveByUser:");

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidAddByUser:");

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *

 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage __deprecated_msg("Use -friendRequestDidReceiveFromUser:message:");


@end
