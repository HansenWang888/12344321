//
//  FYSocketMessageManager.h
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^messageBlock)(NSDictionary *messageDict);

@interface FYIMMessageManager : NSObject

// 设置代理

@property (weak, nonatomic)id <FYChatManagerDelegate> delegate;
@property (weak, nonatomic)id <FYReceiveMessageDelegate> receiveMessageDelegate;
// 设置代理




// 是否连接Socket  IM
@property (nonatomic,assign) BOOL isConnectFY;

+ (FYIMMessageManager *)shareInstance;

- (void)initWithAppKey:(NSString *)appKey;


/**
 发送消息
 
 @param parameters 参数
 */
- (void)sendMessageServer:(NSDictionary *)parameters;

/**
 更新红包信息

 @param messageId 消息ID
 @param redEnvelopeMessage 更改后的红包模型
 */
- (void)setRedEnvelopeMessage:(NSString *)messageId redEnvelopeMessage:(EnvelopeMessage *)redEnvelopeMessage;

- (void)updateMessage:(NSString *)messageId;

/**
 聊天界面下拉请求数据
 */
- (void)sendDropdownRequest:(NSString *)sessionId endTime:(NSTimeInterval)endTime chartType:(FYChatConversationType)type;

/**
 用户主动退出登录
 */
- (void)userSignout;

/**  单聊消息*/
@property (nonatomic, copy) messageBlock mBlock;
@end

NS_ASSUME_NONNULL_END
