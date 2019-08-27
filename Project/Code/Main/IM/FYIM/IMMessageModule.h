//
//  IMMessageModule.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMMessageModule : NSObject
AS_SINGLETON(IMMessageModule)




/**
 * 删除一个会话的所有消息
 */
+ (void)removeLocalMessagesWithSessionId:(NSString *)sessionId;

/**
 * 删除某一条
 */
+ (void)removeLocalMessageWithMessageId:(NSString *)messageId;

/**
 * 获取会话的本地最后一条消息
 */
- (FYMessage *)getLocalLastMessage:(NSString *)sessionId;

/**
 * 获取会话中的一条消息 startIndex: 从第几条开始查询
 */
- (FYMessage *)getLocalMessage:(NSString *)sessionId  startIndex:(NSInteger)index;


/**
 * 根据消息id获取message
 */
- (FYMessage *)getMessageWithMessageId:(NSString *)messageId;

/**
 * 将收到的消息 变成session上需要显示的消息
 */
- (NSString *)filterMessageToShowMessage:(FYMessage *)message;
@end

NS_ASSUME_NONNULL_END
