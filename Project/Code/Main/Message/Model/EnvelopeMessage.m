//
//  EnvelopeMessage.m
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "EnvelopeMessage.h"


@implementation EnvelopeMessage

MJCodingImplementation


///消息的类型名
+ (NSString *)getObjectName {
    return @"RC:EVMessage";
}

- (instancetype)initWithObj:(id)obj{
    self = [super init];
    if (self) {
        NSMutableDictionary *extra = [[NSMutableDictionary alloc]init];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"redpacketId"] forKey:@"redpacketId"];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"count"] forKey:@"count"];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"money"] forKey:@"money"];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"num"] forKey:@"num"];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"type"] forKey:@"type"];
        [extra CDSetNOTNULLObject:[obj objectForKey:@"username"] forKey:@"username"];
        [extra CDSetNOTNULLObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];
        
        [extra CDSetNOTNULLObject:[obj objectForKey:@"nograbContent"] forKey:@"nograbContent"]; // 禁抢红包属性
        [extra CDSetNOTNULLObject:[NSString cdImageLink:obj[@"headImg"]] forKey:@"headImg"];

        self.content = extra.mj_JSONString;
        NSDictionary *dic = @{@"content":self.content};
//        NSLog(@"%@",[dic mj_JSONString]);
    }
    return self;
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    if (self.content) {
//        [dataDict setObject:self.content forKey:@"content"];
//    }
//    if (self.senderUserInfo) {
//        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
//        if (self.senderUserInfo.name) {
//            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
//        }
//        if (self.senderUserInfo.portraitUri) {
//            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
//        }
//        if (self.senderUserInfo.userId) {
//            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
//        }
//        [dataDict setObject:userInfoDic forKey:@"user"];
//    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.content = dictionary[@"content"];
            NSDictionary *userinfoDic = dictionary[@"user"];
//            [self decodeUserInfo:userinfoDic];
        }
    }
}


@end
