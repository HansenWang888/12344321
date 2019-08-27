//
//  NetResponseManager.h
//  XM_12580
//
//  Created by mac on 12-7-10.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager2.h"
//#import "SecurityUtil.h"

#define NET_RESPONSE_MANAGER [NetResponseManager sharedInstance]

//通知字符串定义

@interface NetResponseManager : NSObject<UIAlertViewDelegate>
{
    NSString *_updateURL;//更新地址
}

+ (NetResponseManager *)sharedInstance;

-(void)responseWithHttpManager:(AFHTTPSessionManager2 *)httpManager responseData:(id)data;

@end
