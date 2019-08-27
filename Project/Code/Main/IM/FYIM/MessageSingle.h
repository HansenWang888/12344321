//
//  MessageSingle.h
//  Project
//
//  Created by Mike on 2019/5/7.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageSingle : NSObject

+ (MessageSingle *)shareInstance;
//
@property (nonatomic ,strong) NSMutableDictionary *allUnreadMessagesDict; // 所有群的ID

@end

NS_ASSUME_NONNULL_END



