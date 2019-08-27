//
//  MessageItem.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MessageItem.h"



@implementation MessageItem



+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"groupId": @"id"};
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString *)whc_SqliteVersion {
    return @"1.0.2";
}


@end
