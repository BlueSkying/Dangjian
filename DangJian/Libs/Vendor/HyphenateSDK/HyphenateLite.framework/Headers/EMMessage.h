/*!
 *  \~chinese
 *  @header EMMessage.h
 *  @abstract 聊天消息
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMMessage.h
 *  @abstract Chat message
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese
 *  聊天类型
 *
 *  \~english
 *  Chat type
 */
typedef enum{
    EMChatTypeChat   = 0,   /*! \~chinese 单聊消息 \~english one to one chat type */
    EMChatTypeGroupChat,    /*! \~chinese 群聊消息 \~english Group chat type */
    EMChatTypeChatRoom,     /*! \~chinese 聊天室消息 \~english Chatroom chat type */
}EMChatType;

/*!
 *  \~chinese
 *  消息发送状态
 *
 *  \~english
 *   Message Status
 */
typedef enum{
    EMMessageStatusPending  = 0,    /*! \~chinese 发送未开始 \~english Pending */
    EMMessageStatusDelivering,      /*! \~chinese 正在发送 \~english Delivering */
    EMMessageStatusSuccessed,       /*! \~chinese 发送成功 \~english Successed */
    EMMessageStatusFailed,          /*! \~chinese 发送失败 \~english Failed */
}EMMessageStatus;

/*!
 *  \~chinese
 *  消息方向
 *
 *  \~english
 *  Message direction
 */
typedef enum{
    EMMessageDirectionSend = 0,    /*! \~chinese 发送的消息 \~english Send */
    EMMessageDirectionReceive,     /*! \~chinese 接收的消息 \~english Receive */
}EMMessageDirection;

/*!
 *  \~chinese
 *  聊天消息
 *
 *  \~english
 *  Chat message
 */
@interface EMMessage : NSObject

/*!
 *  \~chinese
 *  消息的唯一标识符
 *
 *  \~english
 *  Unique identifier of message
 */
@property (nonatomic, copy) NSString *messageId;

/*!
 *  \~chinese
 *  所属会话的唯一标识符
 *
 *  \~english
 *  Unique identifier of message's conversation
 */
@property (nonatomic, copy) NSString *conversationId;

/*!
 *  \~chinese
 *  消息的方向
 *
 *  \~english
 *  Message direction
 */
@property (nonatomic) EMMessageDirection direction;

/*!
 *  \~chinese
 *  发送方
 *
 *  \~english
 *  Message sender
 */
@property (nonatomic, copy) NSString *from;

/*!
 *  \~chinese
 *  接收方
 *
 *  \~english
 *  Message receiver
 */
@property (nonatomic, copy) NSString *to;

/*!
 *  \~chinese
 *  时间戳，服务器收到此消息的时间
 *
 *  \~english
 *  Timestamp, the time of server received this message
 */
@property (nonatomic) long long timestamp;

/*!
 *  \~chinese
 *  客户端发送/收到此消息的时间
 *
 *  \~english
 *  The time of client send/receive the message
 */
@property (nonatomic) long long localTime;

/*!
 *  \~chinese
 *  消息类型
 *
 *  \~english
 *  Chat type
 */
@property (nonatomic) EMChatType chatType;

/*!
 *  \~chinese
 *  消息状态
 *
 */
@property (nonatomic) EMMessageStatus status;

/*!
 *  \~chinese
 *  已读回执是否已发送/收到, 对于发送方表示是否已经收到已读回执，对于接收方表示是否已经发送已读回执
 *
 */
@property (nonatomic) BOOL isReadAcked;

/*!
 *  \~chinese
 *  送达回执是否已发送/收到，对于发送方表示是否已经收到送达回执，对于接收方表示是否已经发送送达回执，如果EMOptions设置了enableDeliveryAck，SDK收到消息后会自动发送送达回执
 *
 */
@property (nonatomic) BOOL isDeliverAcked;

/*!
 *  \~chinese
 *  是否已读
 *
 */
@property (nonatomic) BOOL isRead;

/*!
 *  \~chinese
 *  消息体
 *
 */
@property (nonatomic, strong) EMMessageBody *body;

/*!
 *  \~chinese
 *  消息扩展
 *
 *  Key值类型必须是NSString, Value值类型必须是NSString或者 NSNumber类型的 BOOL, int, unsigned in, long long, double.
 *
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  \~chinese
 *  初始化消息实例
 *
 *  @param aConversationId  会话ID
 *  @param aFrom            发送方
 *  @param aTo              接收方
 *  @param aBody            消息体实例
 *  @param aExt             扩展信息
 *
 *  @result 消息实例
 *
 *  @result Message instance
 */
- (id)initWithConversationID:(NSString *)aConversationId
                        from:(NSString *)aFrom
                          to:(NSString *)aTo
                        body:(EMMessageBody *)aBody
                         ext:(NSDictionary *)aExt;


@end
