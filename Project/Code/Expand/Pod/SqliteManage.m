//
//  SqliteManage.m
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "SqliteManage.h"
#import "WHC_ModelSqlite.h"
#import "PushMessageModel.h"
#import "FYMessage.h"

@implementation SqliteManage
+ (SqliteManage *)shareInstance {
    static SqliteManage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


+ (void)removeGroupSql:(NSString *)groupId {
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",groupId];
    [WHC_ModelSqlite delete:[FYMessage class] where:query];
    
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%@' AND userId='%@'",groupId,[AppModel shareInstance].userInfo.userId];
    [WHC_ModelSqlite delete:[PushMessageModel class] where:queryWhere];
}

+ (PushMessageModel *)queryById:(NSString *)groupId{
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%@' AND userId='%@'",groupId,[AppModel shareInstance].userInfo.userId];
    return [[WHC_ModelSqlite query:[PushMessageModel class] where:queryWhere] firstObject];
}

+ (void)clean{
    [WHC_ModelSqlite removeModel:[PushMessageModel class]];
}

@end
