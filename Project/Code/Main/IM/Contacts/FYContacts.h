//
//  Contacts.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FYStatusDefine.h"
/**
 * 会话entity
 */
@interface FYContacts : NSObject<NSCoding>

@property (nonatomic, copy) NSString     *sessionId;
@property (nonatomic, copy) NSString     *userId;
@property (nonatomic, copy) NSString     *nick;
@property (nonatomic, copy) NSString     *avatar;
@property (nonatomic, copy) NSString     *name;
@property (nonatomic, copy) NSString     *remarkName;
// 2 下级  3 客服  4 上级
@property (nonatomic, assign) NSInteger  contactsType;
@property (nonatomic, assign) NSInteger sectionNumber;



/**
 *  最后一条消息发送时间    时间戳
 */
@property (nonatomic, assign)           NSTimeInterval lastTimestamp;
@property (nonatomic, strong) NSDate    *lastCreate_time;
@property (nonatomic, copy) NSString    *lastMessageId;
@property (nonatomic, assign) BOOL    isNotDisturbSound;
@property (nonatomic, assign) BOOL    isTopChat;
@property (nonatomic, strong) NSDate    *isTopTime;


@property (nonatomic, copy) NSString     *accountUserId;

// 备用字段1
@property (nonatomic, copy)  NSString *FieldOne;
// 备用字段2
@property (nonatomic, copy)  NSString *FieldTwo;

///会话类型
@property (nonatomic, assign) FYChatConversationType sessionType;
/**群组id  用户id*/
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastMessage;
/**
 * 未读消息数
 */
@property (nonatomic, assign) NSInteger unReadMsgCount;




- (id)initWithPropertiesDictionary:(NSDictionary *)dic;


@end
