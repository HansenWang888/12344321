//
//  IMSessionModule.h
//  Project
//
//  Created by fangyuan on 2019/8/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSessionModule : NSObject
AS_SINGLETON(IMSessionModule)
/**
 * 所有的未读消息数
 */
@property (nonatomic, assign, readonly) NSInteger allUnreadMesagges;

/**
 * 获取所有的会话列表
 */
+ (NSArray<FYContacts *> *)getAllSessions;

/**
 * 获取群组会话列表
 */
+ (NSArray<FYContacts *> *)getGroupSessionList;
/**
 * 获取单聊会话列表
 */
+ (NSArray<FYContacts *> *)getSignleSessionList;


/**
 * 新增支持群组和单聊会话 最后一条消息 都放到数据库
 * 群组中消息体中  目前还没有群组名称、头像、
 */
- (void)insertFYContacts:(FYMessage *)message lastMessage:(NSString *)lastMessage;

- (FYContacts *)getSessionWithSessionId:(NSString *)sessionId;

+ (void)removeSession:(NSString *)sessionId;

+ (void)updateSeesion:(FYContacts *)session;

/**
 * 处理消息被删除或者被撤回后 会话中显示上一条消息的处理
 */
- (void)handleMessageForRecallOrDeletedWithSessionId:(NSString *)sessionId;
@end

NS_ASSUME_NONNULL_END
