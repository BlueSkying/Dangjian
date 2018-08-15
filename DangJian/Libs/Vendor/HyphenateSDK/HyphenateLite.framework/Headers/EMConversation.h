/*!
 *  \~chinese
 *  @header EMConversation.h
 *  @abstract 聊天会话
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMConversation.h
 *  @abstract Chat conversation
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
typedef enum{
    EMConversationTypeChat  = 0,    /*! \~chinese 单聊会话 \~english one to one chat room type */
    EMConversationTypeGroupChat,    /*! \~chinese 群聊会话 \~english Group chat room type */
    EMConversationTypeChatRoom      /*! \~chinese 聊天室会话 \~english Chatroom chat room type */
} EMConversationType;

/*
 *  \~chinese
 *  消息搜索方向
 *
 *  \~english
 *  Message search direction
 */
typedef enum{
    EMMessageSearchDirectionUp  = 0,    /*! \~chinese 向上搜索 \~english Search older messages */
    EMMessageSearchDirectionDown        /*! \~chinese 向下搜索 \~english Search newer messages */
} EMMessageSearchDirection;

@class EMMessage;
@class EMError;

/*!
 *  \~chinese
 *  聊天会话
 *
 *  \~english
 *  Chat conversation
 */
@interface EMConversation : NSObject

/*!
 *  \~chinese
 *  会话唯一标识
 *
 *  \~english
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/*!
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
@property (nonatomic, assign, readonly) EMConversationType type;

/*!
 *  \~chinese
 *   会话未读消息数量
 *
 *  \~english
 *  Count of unread messages
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/*!
 *  \~chinese
 *  会话扩展属性
 *
 *  \~english
 *  Conversation extension property
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  \~chinese
 *  会话最新一条消息
 *
 *  \~english
 *  Conversation latest message
 */
@property (nonatomic, strong, readonly) EMMessage *latestMessage;

/*!
 *  \~chinese
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 *  \~english
 *  Insert a message to a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *

 */
- (void)insertMessage:(EMMessage *)aMessage
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  插入一条消息到会话尾部，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 *  \~english
 *  Insert a message to the end of a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *

 *
 */
- (void)appendMessage:(EMMessage *)aMessage
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  删除一条消息
 *
 *  @param aMessageId   要删除消失的ID
 *  @param pError       错误信息
 *
 *  \~english
 *  Delete a message
 *

 *
 */
- (void)deleteMessageWithId:(NSString *)aMessageId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  删除该会话所有消息
 *  @param pError       错误信息

 */
- (void)deleteAllMessages:(EMError **)pError;

/*!
 *  \~chinese
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage 要更新的消息
 *  @param pError   错误信息

 *
 */
- (void)updateMessageChange:(EMMessage *)aMessage
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  将消息设置为已读
 *
 *  @param aMessageId   要设置消息的ID
 *  @param pError       错误信息
 *

 *
 */
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  将所有未读消息设置为已读
 *
 *  @param pError   错误信息
 *

 *
 */
- (void)markAllMessagesAsRead:(EMError **)pError;

/*!
 *  \~chinese
 *  获取指定ID的消息
 *
 *  @param aMessageId       消息ID
 *  @param pError           错误信息
 *
 
 */
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId
                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 *

 */
- (EMMessage *)lastReceivedMessage;

#pragma mark - Async method

/*!
 *  \~chinese
 *  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
 *
 *  @param aMessageId       参考消息的ID
 *  @param aCount            获取的条数
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *

 *
 */
- (void)loadMessagesStartFromId:(NSString *)aMessageId
                          count:(int)aCount
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息取，如果aCount小于等于0当作1处理
 *
 *  @param aType            消息类型
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aUsername        消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)loadMessagesWithType:(EMMessageBodyType)aType
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString*)aUsername
             searchDirection:(EMMessageSearchDirection)aDirection
                  completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取包含指定内容的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aCount小于等于0当作1处理
 *
 *  @param aKeyword        搜索关键字，如果为空则忽略
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aSender          消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
  *
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeyword
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定时间段内的消息，取到的消息按时间排序，为了防止占用太多内存，用户应当制定加载消息的最大数
 *
 *  @param aStartTimestamp  毫秒级开始时间
 *  @param aEndTimestamp    结束时间
 *  @param aCount           加载消息最大数
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount
              completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage  消息实例
 *
 *  @result 是否成功
 *
 */
- (BOOL)insertMessage:(EMMessage *)aMessage __deprecated_msg("Use -insertMessage:error:");

/*!
 *  \~chinese
 *  插入一条消息到会话尾部，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage  消息实例
 *
 *  @result 是否成功
 *
 
 */
- (BOOL)appendMessage:(EMMessage *)aMessage __deprecated_msg("Use -appendMessage:error:");

/*!
 *  \~chinese
 *  删除一条消息
 *
 *  @param aMessageId  要删除消失的ID
 *
 *  @result 是否成功
 *
  */
- (BOOL)deleteMessageWithId:(NSString *)aMessageId __deprecated_msg("Use -deleteMessageWithId:error:");

/*!
 *  \~chinese
 *  删除该会话所有消息
 *
 *  @result 是否成功
 *
  */
- (BOOL)deleteAllMessages __deprecated_msg("Use -deleteAllMessages:");

/*!
 *  \~chinese
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage  要更新的消息
 *
 *  @result 是否成功
 *
  */
- (BOOL)updateMessage:(EMMessage *)aMessage __deprecated_msg("Use -updateMessageChange:error:");

/*!
 *  \~chinese
 *  将消息设置为已读
 *
 *  @param aMessageId  要设置消息的ID
 *
 *  @result 是否成功
 *
 */
- (BOOL)markMessageAsReadWithId:(NSString *)aMessageId __deprecated_msg("Use -markMessageAsReadWithId:error:");

/*!
 *  \~chinese
 *  将所有未读消息设置为已读
 *
 *  @result 是否成功
 *
 */
- (BOOL)markAllMessagesAsRead __deprecated_msg("Use -markAllMessagesAsRead:");

/*!
 *  \~chinese
 *  更新会话扩展属性到DB
 *
 *  @result 是否成功
 *
 */
- (BOOL)updateConversationExtToDB __deprecated_msg("setExt: will update extend properties to DB");

/*!
 *  \~chinese
 *  获取指定ID的消息
 *
 *  @param aMessageId  消息ID
 *
 *  @result 消息
 *
 */
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId __deprecated_msg("Use -loadMessageWithId:error:");

/*!
 *  \~chinese
 *  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息向前取
 *
 *  @param aMessageId  参考消息的ID
 *  @param aLimit      获取的条数
 *  @param aDirection  消息搜索方向
 *
 *  @result 消息列表<EMMessage>
 *
 
 */
- (NSArray *)loadMoreMessagesFromId:(NSString *)aMessageId
                              limit:(int)aLimit
                          direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesStartFromId:count:searchDirection:completion:");

/*!
 *  \~chinese
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aLimit是负数，则获取所有符合条件的消息
 *
 *  @param aType        消息类型
 *  @param aTimestamp   参考时间戳
 *  @param aLimit       获取的条数
 *  @param aSender      消息发送方，如果为空则忽略
 *  @param aDirection   消息搜索方向
 *
 *  @result 消息列表<EMMessage>
 *
 */
- (NSArray *)loadMoreMessagesWithType:(EMMessageBodyType)aType
                               before:(long long)aTimestamp
                                limit:(int)aLimit
                                 from:(NSString*)aSender
                            direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesWithType:timestamp:count:fromUser:searchDirection:completion:");

/*!
 *  \~chinese
 *  从数据库获取包含指定内容的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aLimit是负数，则获取所有符合条件的消息
 *
 *  @param aKeywords    搜索关键字，如果为空则忽略
 *  @param aTimestamp   参考时间戳
 *  @param aLimit       获取的条数
 *  @param aSender      消息发送方，如果为空则忽略
 *  @param aDirection   消息搜索方向
 *
 *  @result 消息列表<EMMessage>
 *
 */
- (NSArray *)loadMoreMessagesContain:(NSString*)aKeywords
                              before:(long long)aTimestamp
                               limit:(int)aLimit
                                from:(NSString*)aSender
                           direction:(EMMessageSearchDirection)aDirection __deprecated_msg("Use -loadMessagesContainKeywords:timestamp:count:fromUser:searchDirection:completion:");

/*!
 *  \~chinese
 *  从数据库获取指定时间段内的消息，取到的消息按时间排序，为了防止占用太多内存，用户应当制定加载消息的最大数
 *
 *  @param aStartTimestamp  毫秒级开始时间
 *  @param aEndTimestamp    结束时间
 *  @param aMaxCount        加载消息最大数
 *
 *  @result 消息列表<EMMessage>
 *
 */
- (NSArray *)loadMoreMessagesFrom:(long long)aStartTimestamp
                               to:(long long)aEndTimestamp
                         maxCount:(int)aMaxCount __deprecated_msg("Use -loadMessagesFrom:to:count:completion:");

/*!
 *  \~chinese
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 *
 */
- (EMMessage *)latestMessageFromOthers __deprecated_msg("Use -lastReceivedMessage");

@end
