//
//  FYSocketManager.h
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  socket状态
 */
typedef NS_ENUM(NSInteger,FYSocketStatus){
    FYSocketStatusConnected,// 已连接
    FYSocketStatusFailed,// 失败
    FYSocketStatusClosedByServer,// 系统关闭
    FYSocketStatusClosedByUser,// 用户关闭
    FYSocketStatusReceived// 接收消息
};
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,FYSocketReceiveType){
    FYSocketReceiveTypeForMessage,
    FYSocketReceiveTypeForPong
};

typedef void(^FYSocketDidConnectBlock)();
typedef void(^FYSocketDidFailBlock)(NSError *error);
typedef void(^FYSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
typedef void(^FYSocketDidReceiveBlock)(id message ,FYSocketReceiveType type);




@interface FYSocketManager : NSObject

@property (nonatomic,copy)FYSocketDidConnectBlock connect;
@property (nonatomic,copy)FYSocketDidReceiveBlock receive;
@property (nonatomic,copy)FYSocketDidFailBlock failure;
@property (nonatomic,copy)FYSocketDidCloseBlock close;


/**
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;
/**
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
// 视图加载是否完成  messageController
@property (nonatomic,assign) BOOL isViewLoad;
// 是否无效token
@property (nonatomic,assign) BOOL isInvalidToken;


+ (instancetype)shareManager;
/**
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)fy_open:(NSString *)urlStr connect:(FYSocketDidConnectBlock)connect receive:(FYSocketDidReceiveBlock)receive failure:(FYSocketDidFailBlock)failure;
/**
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)fy_close:(FYSocketDidCloseBlock)close;
/**
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)fy_sendData:(id)data;

@end
