//
//  ChatViewController.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

//#import <RongIMKit/RongIMKit.h>
#import "FYIMSessionViewController.h"
#import "BaseNavigationViewController.h"
#import "MessageItem.h"
#import "FYContacts.h"
//@class MessageItem;
//@class FYContacts;

@interface ChatViewController : FYIMSessionViewController

// 群聊
+ (ChatViewController *)groupChatWithObj:(MessageItem *)obj;
// 单聊
+ (ChatViewController *)privateChatWithModel:(FYContacts *)model;

//
+ (ChatViewController *)currentChat;

// 是否新成员
@property (nonatomic,assign) BOOL isNewMember;


//+ (void)sendCustomMessage:(id)message;

@end
