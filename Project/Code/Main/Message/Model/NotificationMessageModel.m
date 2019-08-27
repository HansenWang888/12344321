//
//  MessageModel.m
//  Project
//
//  Created by Mike on 2019/2/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "NotificationMessageModel.h"

@implementation NotificationMessageModel
MJExtensionCodingImplementation

///消息的类型名
+ (NSString *)getObjectName {
    return kRCNotificationMessage;
}

@end
