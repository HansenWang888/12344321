//
//  PushMessageModel.h
//  Project
//
//  Created by Mike on 2019/1/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHC_ModelSqlite.h"


NS_ASSUME_NONNULL_BEGIN

@interface PushMessageModel : NSObject<NSCoding,WHC_SqliteInfo>

@property (nonatomic ,copy) NSString *userId; // 用户ID
/**
 *  会话ID
 */
@property (nonatomic, copy)         NSString *sessionId;
//本地
@property (nonatomic ,copy) NSString *lastMessage; ///<最后一条消息
@property (nonatomic ,assign) NSInteger number;      // 消息条数
// 未读消息总量剩余
@property (nonatomic ,assign) NSInteger messageCountLeft;

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
