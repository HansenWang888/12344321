//
//  AFHTTPSessionManager2.m
//  WeiCaiProj
//
//  Created by fy on 2018/12/24.
//  Copyright © 2018 hzx. All rights reserved.
//

#import "AFHTTPSessionManager2.h"

@implementation AFHTTPSessionManager2
-(void)clear{
    self.act = ActNil;
    self.requestParameters = nil;
    self.successBlock = nil;
    self.failBlock = nil;
}
@end
