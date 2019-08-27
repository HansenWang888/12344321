//
//  XDFNetworkError.h
//  ClassSignUp
//
//  Created by Hansen on 2018/11/12.
//  Copyright © 2018 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KBasseerrorMessage @"数据错误"
@interface DYNetworkError : NSError
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, copy) NSString *errorMessage;

@end
