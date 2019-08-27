//
//  SqliteManage.h
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PushMessageModel;
@interface SqliteManage : NSObject

+ (SqliteManage *)shareInstance;


+ (void)removeGroupSql:(NSString *)groupId;
+ (PushMessageModel *)queryById:(NSString *)groupId;

+ (void)clean;


@end
