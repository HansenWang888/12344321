//
//  IMUserEntity.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMUserEntity : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *chatId;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *userId;

/**
 * 0 == 客服  1 == 好友
 */
@property (nonatomic, assign) int type;

/**
 * 0 == 离线  1 == 在线
 */
@property (nonatomic, assign) int status;


@end

NS_ASSUME_NONNULL_END
