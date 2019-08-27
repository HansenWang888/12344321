//
//  IMSessionModule.m
//  Project
//
//  Created by fangyuan on 2019/8/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMSessionModule.h"
#import <WHC_ModelSqlite.h>
#import "IMMessageModule.h"

@interface IMSessionModule ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, FYContacts *> *sessions;


@end

@implementation IMSessionModule {
    ///查询本地消息的页面数
    NSInteger _dbIndex;
    
}

DEF_SINGLETON(IMSessionModule)

- (instancetype)init {
    self = [super init];
    
    self.sessions = @{}.mutableCopy;
//    [IMSessionModule getAllSessions];
    
    return self;
}

+ (NSArray<FYContacts *> *)getAllSessions {
    
    NSString *query = [NSString stringWithFormat:@"select * from FYContacts where contactsType = 2 and accountUserId='%@' order by isTopTime desc,lastTimestamp desc,lastCreate_time desc limit 999999",[AppModel shareInstance].userInfo.userId];
    NSArray *whereMyFriendByArray = [WHC_ModelSqlite query:[FYContacts class] sql:query];
    NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:whereMyFriendByArray.count];
    for (NSInteger index = 0; index < whereMyFriendByArray.count; index++) {
        FYContacts *model = (FYContacts *)whereMyFriendByArray[index];
        [arrayM addObject:model];
        IMSessionModule.sharedInstance.sessions[model.sessionId] = model;
    }
    return arrayM.copy;
}

///如果出现 有的群组没有收到离线消息， 需要改成从数据库中读取 ， 有可能会漏掉 刚好新加入得群组
+ (NSArray<FYContacts *> *)getGroupSessionList {
    NSMutableArray *array = @[].mutableCopy;
    
    [IMSessionModule.sharedInstance.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sessionType == FYConversationType_GROUP) {
            [array addObject:obj];
        }
    }];
    
    return array.copy;
}

+ (NSArray<FYContacts *> *)getSignleSessionList {
    NSMutableArray *array = @[].mutableCopy;
    [IMSessionModule.sharedInstance.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sessionType == FYConversationType_PRIVATE) {
            [array addObject:obj];
        }
    }];
    
    return array.copy;
}
+ (void)removeSession:(NSString *)sessionId {
    [IMSessionModule.sharedInstance.sessions removeObjectForKey:sessionId];
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'",sessionId,[AppModel shareInstance].userInfo.userId];
    FYContacts *oldModel = [[WHC_ModelSqlite query:[FYContacts class] where:query] firstObject];

    if (oldModel) {
        //同时删除 本地消息
        [WHC_ModelSqlite delete:FYContacts.class where:query];
        [IMMessageModule removeLocalMessagesWithSessionId:sessionId];
    }
}

+ (void)updateSeesion:(FYContacts *)session {
    IMSessionModule.sharedInstance.sessions[session.sessionId] = session;
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'",session.sessionId,[AppModel shareInstance].userInfo.userId];
    [WHC_ModelSqlite update:session where:query];
    
}
- (FYContacts *)getSessionWithSessionId:(NSString *)sessionId {
    
    return self.sessions[sessionId];
    
}
- (void)insertFYContacts:(FYMessage *)message lastMessage:(NSString *)lastMessage {
    
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'",message.sessionId,[AppModel shareInstance].userInfo.userId];
    FYContacts *oldModel = [[WHC_ModelSqlite query:[FYContacts class] where:query] firstObject];
    
    if (oldModel) {
        oldModel.lastTimestamp = message.timestamp;
        oldModel.lastMessage = lastMessage;
        if (message.chatType == FYConversationType_PRIVATE) {
            if (message.messageFrom == FYMessageDirection_SEND) {
                oldModel.name = message.receiver[@"nick"];
                oldModel.avatar = message.receiver[@"avatar"];
            } else {
                oldModel.name = message.user.nick;
                oldModel.avatar = message.user.avatar;
            }
        }
        if (message.messageFrom == FYMessageDirection_RECEIVE) {
            ///只处理收到的消息
            oldModel.unReadMsgCount += 1;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite update:oldModel where:query];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[FYContacts class]];
                [self insertFYContacts:message lastMessage:lastMessage];
            }
        });
        
    } else {
        oldModel = [FYContacts new];
        
        if (message.chatType == FYConversationType_GROUP) {
            //群组没有图像和
            oldModel.id = message.sessionId;
        } else if (message.chatType == FYConversationType_PRIVATE) {
            oldModel.id = oldModel.userId;
            if (message.messageFrom == FYMessageDirection_SEND) {
                oldModel.userId = message.receiver[@"userId"];
                oldModel.nick = message.receiver[@"nick"];
                oldModel.name = message.receiver[@"nick"];
                oldModel.avatar = message.receiver[@"avatar"];
            } else {
                oldModel.userId = message.user.userId;
                oldModel.nick = message.user.nick;
                oldModel.name = message.user.nick;
                oldModel.avatar = message.user.avatar;
            }
        }
        if (message.messageFrom == FYMessageDirection_RECEIVE) {
            ///只处理收到的消息
            oldModel.unReadMsgCount += 1;
        }
        oldModel.sessionId = message.sessionId;
        oldModel.sessionType = message.chatType;
        oldModel.contactsType = message.chatType == FYConversationType_CUSTOMERSERVICE ? 3 : 2;
        oldModel.lastTimestamp = message.timestamp;
        oldModel.lastCreate_time = message.create_time;
        oldModel.lastMessageId = message.messageId;
        oldModel.lastMessage = lastMessage;
        oldModel.accountUserId = [AppModel shareInstance].userInfo.userId;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite insert:oldModel];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[FYContacts class]];
                [WHC_ModelSqlite insert:oldModel];
            }
        });
    }
}

- (void)handleMessageForRecallOrDeletedWithSessionId:(NSString *)sessionId {
    FYMessage *message = [IMMessageModule.sharedInstance getLocalMessage:sessionId startIndex:_dbIndex];
    if (message == nil) {
        //退出递归
        _dbIndex = 0;
        return;
    }
    if (message.isDeleted || message.isRecallMessage) {
        _dbIndex ++;
        //判断上一条消息也是被删除或者撤回
        [self handleMessageForRecallOrDeletedWithSessionId:sessionId];
        return;
    }
    FYContacts *contacts = [self getSessionWithSessionId:sessionId];
    contacts.lastMessage = [IMMessageModule.sharedInstance filterMessageToShowMessage:message];
    [IMSessionModule updateSeesion:contacts];
    _dbIndex = 0;
}

- (NSInteger)allUnreadMesagges {
    __block NSInteger count = 0;
    [self.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.unReadMsgCount;
    }];
    return count;
}
@end
