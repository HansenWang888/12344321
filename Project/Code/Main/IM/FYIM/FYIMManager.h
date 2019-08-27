//
//  FYIMManager.h
//  Project
//
//  Created by Mike on 2019/4/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYIMManager : NSObject<FYReceiveMessageDelegate>

+ (FYIMManager *)shareInstance;

/**
 更新红包信息
 
 @param messageId 消息ID
 @param redEnvelopeMessage 更改后的红包模型
 */
- (void)setRedEnvelopeMessage:(NSString *)messageId redEnvelopeMessage:(EnvelopeMessage *)redEnvelopeMessage;


- (void)updateGroup:(NSString *)sessionId number:(NSInteger)number lastMessage:(NSString *)last messageCount:(NSInteger)messageCount left:(NSInteger)left chatType:(FYChatConversationType)chatType;


/**
 通知服务器 登录了
 */
- (void)notificationLogin;

/**
 用户主动退出登录
 */
- (void)userSignout;



@end

NS_ASSUME_NONNULL_END
