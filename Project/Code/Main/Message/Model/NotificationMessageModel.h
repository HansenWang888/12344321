//
//  MessageModel.h
//  Project
//
//  Created by Mike on 2019/2/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

//#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

//@interface NotificationMessageModel : RCMessageContent<MJCoding>
@interface NotificationMessageModel : NSObject
    
    // 0 默认:系统历史消息  1 发送的消息已超过规定长度  2 发送时间间隔  3 服务器连接错误(IM连接不上)
@property (nonatomic,assign) NSInteger messagetype;
@property (nonatomic,assign) NSInteger talkTime;


@end

NS_ASSUME_NONNULL_END
