//
//  IMMessageModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMMessageModule.h"
#import <WHC_ModelSqlite.h>
@implementation IMMessageModule
DEF_SINGLETON(IMMessageModule)

- (instancetype)init {
    self = [super init];
    
    
    return self;
}

+ (void)removeLocalMessagesWithSessionId:(NSString *)sessionId {
    
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];

    [WHC_ModelSqlite delete:FYMessage.class where:query];
    
}

+ (void)removeLocalMessageWithMessageId:(NSString *)messageId {
    NSString *query = [NSString stringWithFormat:@"messageId='%@'",messageId];
    
    [WHC_ModelSqlite delete:FYMessage.class where:query];
}

- (FYMessage *)getLocalLastMessage:(NSString *)sessionId {
    
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];

    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:query order:@"by timestamp desc" limit:@"0,1"].firstObject;
}
- (FYMessage *)getLocalMessage:(NSString *)sessionId startIndex:(NSInteger)index {
    
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
    
    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:query order:@"by timestamp desc" limit:[NSString stringWithFormat:@"%ld,1",index]].firstObject;
    
    
}

- (NSString *)filterMessageToShowMessage:(FYMessage *)message {
    
    NSString *lastMessage = nil;
    if (message.messageType == FYMessageTypeRedEnvelope) {
        lastMessage = @"【红包】";
    } else if (message.messageType == FYMessageTypeNoticeRewardInfo) {
        lastMessage = @"【报奖结果】";
    } else if (message.messageType == FYMessageTypeImage && message.messageFrom != FYChatMessageFromSystem) {
        lastMessage = @"【图片】";
    } else {
        lastMessage = message.text;
        if (message.chatType == FYConversationType_GROUP) {
            lastMessage = [NSString stringWithFormat:@"%@：%@",message.user.nick, message.text];
        }
    }
    return lastMessage;
}

- (FYMessage *)getMessageWithMessageId:(NSString *)messageId {
    
    NSString *query = [NSString stringWithFormat:@"messageId='%@'",messageId];
    ;
    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:query].firstObject;
}
@end
