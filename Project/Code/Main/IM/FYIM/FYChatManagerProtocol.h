//
//  FYReceiveMessageDelegate.h
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天委托
 */
@protocol FYChatManagerDelegate <NSObject>
// 1 即将发送消息回调
// 2 发送消息完成回调
// 3 收到消息回调
// 4 收到消息被撤回的通知

@optional
/**
 *  即将发送消息回调
 *  @discussion 因为发消息之前可能会有个准备过程,所以需要在收到这个回调时才将消息加入到 Datasource 中
 *  @param message 当前发送的消息
 */
- (FYMessage *)willSendMessage:(FYMessage *)message;

/*!
 即将在会话页面插入消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
 */
- (FYMessage *)willAppendAndDisplayMessage:(FYMessage *)message;

/**
 即将撤回消息（服务器已经发送回来撤回命令 客服端还未处理时）

 @param messageId  消息ID
 */
- (void)willRecallMessage:(NSString *)messageId;


/**
 下拉获取服务器返回的消息

 @param messageArray 消息数组
 */
- (void)downPullGetMessageArray:(NSArray *)messageArray;

@end



/**
 *  聊天协议
 */
@protocol FYReceiveMessageDelegate <NSObject>

// 1 发送消息
// 2 异步发送消息
// 3 取消正在发送的消息
// 4 重发消息
// 5 刷新群组消息已读、未读数量
// 5 撤回消息

@optional
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param messageCount  未读消息总数  获取未读消息时有
 @param left        还剩余的未接收的消息数，left>=0      参考融云sdk
 */
- (void)onFYIMReceiveMessage:(FYMessage *)message messageCount:(NSInteger)messageCount left:(NSInteger)left;


//  默认 NO 播放  返回YES 不再播放声音
- (BOOL)onFYIMCustomAlertSound:(FYMessage *)message;















/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
//- (void)addDelegate:(id<NIMChatManagerDelegate>)delegate;
/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
//- (void)removeDelegate:(id<NIMChatManagerDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
