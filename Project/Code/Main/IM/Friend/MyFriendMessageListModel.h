//
//  MyFriendMessageListModel.h
//  Project
//
//  Created by Mike on 2019/6/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyFriendMessageListModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString     *sessionId;
@property (nonatomic, copy) NSString     *userId;
@property (nonatomic, copy) NSString     *nick;
@property (nonatomic, copy) NSString     *avatar;
@property (nonatomic, copy) NSString     *remarkName;
/**
 *  最后一条消息发送时间    时间戳
 */
@property (nonatomic, assign)           NSTimeInterval lastTimestamp;
@property (nonatomic, strong) NSDate    *lastCreate_time;
@property (nonatomic, copy) NSString    *lastMessageId;

@property (nonatomic, assign) BOOL    isTopChat;
@property (nonatomic, strong) NSDate    *isTopTime;

// 备用字段1
@property (nonatomic, copy)  NSString *FieldOne;
// 备用字段2
@property (nonatomic, copy)  NSString *FieldTwo;

@end

NS_ASSUME_NONNULL_END
