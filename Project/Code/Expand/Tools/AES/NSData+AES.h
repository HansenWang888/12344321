//
//  NSData+AES.h
//  WeiCaiProj
//
//  Created by fy on 2018/12/25.
//  Copyright © 2018 hzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;
@end
