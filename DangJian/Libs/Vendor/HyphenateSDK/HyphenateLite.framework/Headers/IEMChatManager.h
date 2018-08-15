/*!
 *  \~chinese
 *  @header IEMChatManager.h
 *  @abstract 此协议定义了聊天相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatManager.h
 *  @abstract This protocol defines the operations of chat
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatManagerDelegate.h"
#import "EMConversation.h"

#import "EMMessage.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMCmdMessageBody.h"
#import "EMFileMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天相关操作
 *
 *  \~english
 *  Operations of chat
 */
@protocol IEMChatManager <NSObject>

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
- (void)addDelegate:(id<EMChatManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 
 */
- (void)removeDelegate:(id<EMChatManagerDelegate>)aDelegate;

#pragma mark - Conversation

/*!
 *  \~chinese
 *  获取所有会话，如果内存中不存在会从DB中加载
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Get all conversations, by loading conversations from DB if not exist in memory
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)getAllConversations;

/*!
 *  \~chinese
 *  获取一个会话
 *
 *  @param aConversationId  会话ID
 *  @param aType            会话类型
 *  @param aIfCreate        如果不存在是否创建
 *
 *  @result 会话对象
 *
 *  \~english
 *  Get a conversation
 *

 *
 *  @result Conversation
 */
- (EMConversation *)getConversation:(NSString *)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId      会话ID
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *

 *
 */
- (void)deleteConversation:(NSString *)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^)(NSString *aConversationId, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations       会话列表<EMConversation>
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *

 *
 */
- (void)deleteConversations:(NSArray *)aConversations
           isDeleteMessages:(BOOL)aIsDeleteMessages
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations   会话列表<EMConversation>
 *  @param aCompletionBlock 完成的回调
 *
 *

 *
 */
- (void)importConversations:(NSArray *)aConversations
                 completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Message

/*!
 *  \~chinese
 *  获取消息附件路径, 存在这个路径的文件，删除会话时会被删除
 *
 *  @param aConversationId  会话ID
 *
 *  @result 附件路径
 *
 
 */
- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages        消息列表<EMMessage>
 *  @param aCompletionBlock 完成的回调
 *
 
 *
 */
- (void)importMessages:(NSArray *)aMessages
            completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage         消息
 *  @param aCompletionBlock 完成的回调
 *

 *
 */
- (void)updateMessage:(EMMessage *)aMessage
           completion:(void (^)(EMMessage *aMessage, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage             消息
 *  @param aCompletionBlock     完成的回调
 *
 
 *
 */
- (void)sendMessageReadAck:(EMMessage *)aMessage
                     completion:(void (^)(EMMessage *aMessage, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *
 
 */
- (void)sendMessage:(EMMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  重发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *

 */
- (void)resendMessage:(EMMessage *)aMessage
                  progress:(void (^)(int progress))aProgressBlock
                completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *

 */
- (void)downloadMessageThumbnail:(EMMessage *)aMessage
                        progress:(void (^)(int progress))aProgressBlock
                      completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *

 */
- (void)downloadMessageAttachment:(EMMessage *)aMessage
                         progress:(void (^)(int progress))aProgressBlock
                       completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *

 *
 */
- (void)addDelegate:(id<EMChatManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMChatManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  从数据库中获取所有的会话，执行后会更新内存中的会话列表
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Load all conversations from DB, will update conversation list in memory after this method is called
 *
 *  Synchronization method will block the current thread
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)loadAllConversationsFromDB __deprecated_msg("Use -getAllConversations");

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId  会话ID
 *  @param aDeleteMessage   是否删除会话中的消息
 *
 *  @result 是否成功
 *

 */
- (BOOL)deleteConversation:(NSString *)aConversationId
            deleteMessages:(BOOL)aDeleteMessage __deprecated_msg("Use -deleteConversation:isDeleteMessages:completion:");

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations  会话列表<EMConversation>
 *  @param aDeleteMessage  是否删除会话中的消息
 *
 *  @result 是否成功
 *
 
 */
- (BOOL)deleteConversations:(NSArray *)aConversations
             deleteMessages:(BOOL)aDeleteMessage __deprecated_msg("Use -deleteConversations:isDeleteMessages:completion:");

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations  会话列表<EMConversation>
 *
 *  @result 是否成功
 *
 
 */
- (BOOL)importConversations:(NSArray *)aConversations __deprecated_msg("Use -importConversations:completion:");

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  @result 是否成功
 *

 */
- (BOOL)importMessages:(NSArray *)aMessages __deprecated_msg("Use -importMessages:completion:");

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage  消息
 *
 *  @result 是否成功
 *

 */
- (BOOL)updateMessage:(EMMessage *)aMessage __deprecated_msg("Use -updateMessage:completion:");

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage  消息
 *

 */
- (void)asyncSendReadAckForMessage:(EMMessage *)aMessage __deprecated_msg("Use -sendMessageReadAck:completion:");

/*!
 *  \~chinese
 *  发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *

 */
- (void)asyncSendMessage:(EMMessage *)aMessage
                progress:(void (^)(int progress))aProgressCompletion
              completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -sendMessage:progress:completion:");

/*!
 *  \~chinese
 *  重发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *

 */
- (void)asyncResendMessage:(EMMessage *)aMessage
                  progress:(void (^)(int progress))aProgressCompletion
                completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -resendMessage:progress:completion:");

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *

 */
- (void)asyncDownloadMessageThumbnail:(EMMessage *)aMessage
                             progress:(void (^)(int progress))aProgressCompletion
                           completion:(void (^)(EMMessage * message, EMError *error))aCompletion __deprecated_msg("Use -downloadMessageThumbnail:progress:completion:");

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *

 */
- (void)asyncDownloadMessageAttachments:(EMMessage *)aMessage
                               progress:(void (^)(int progress))aProgressCompletion
                             completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -downloadMessageAttachment:progress:completion");

@end
