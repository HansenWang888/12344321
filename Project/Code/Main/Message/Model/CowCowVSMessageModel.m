//
//  CowCowVSMessageModel.m
//  Project
//
//  Created by Mike on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CowCowVSMessageModel.h"

@implementation CowCowVSMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"messageId": @"id"
              };
}




- (instancetype)initWithObj:(id)obj{
    self = [super init];
    if (self) {
        NSMutableDictionary *dic9 = [NSMutableDictionary dictionary];
        dic9 = obj;
        self.content = dic9.mj_JSONString;
    }
    return self;
}

@end
