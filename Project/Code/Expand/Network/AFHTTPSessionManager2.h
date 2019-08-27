//
//  AFHTTPSessionManager2.h
//  WeiCaiProj
//
//  Created by fy on 2018/12/24.
//  Copyright © 2018 hzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Public.h"
#import "NetRequestManager.h"

@interface AFHTTPSessionManager2 : AFHTTPSessionManager
@property(nonatomic,copy)CallbackBlock successBlock;
@property(nonatomic,copy)CallbackBlock failBlock;
@property(nonatomic,assign)Act act;
@property(nonatomic,strong)id requestParameters;

-(void)clear;
@end
