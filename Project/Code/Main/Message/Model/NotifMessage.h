//
//  NotifMessage.h
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifMessage : NSObject

@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,assign) NSInteger dateline;
@property (nonatomic ,assign) BOOL is_read;
@property (nonatomic ,copy) NSString *message_id;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,assign) NSInteger type;

@end
