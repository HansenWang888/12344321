//
//  WNBaseNetwork.m
//  项目常用设定
//
//  Created by Hansen on 2018/11/8.
//  Copyright © 2018 ma c. All rights reserved.
//

#import "DYBaseNetwork.h"
#import "DYNetworkConfig.h"
#import <AFNetworking.h>

@implementation DYBaseNetwork

- (instancetype)init {
    
    self = [super init];
    [self setDefaultParam];
    return self;
}
- (void)setDefaultParam {
    self.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    self.dy_responseSerializerType = YTKResponseSerializerTypeJSON;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只需要初始化一次的在这里设置
        [DYNetworkConfig initializeNetworkConfig];
    });
}

- (void)dy_startRequestWithSuccessful:(void (^)(id))successful {
    
    [self commonRequestWithSuccessful:^(id _Nullable response, DYNetworkError * _Nonnull error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
            successful(nil);
        }  else {
            successful(response);
        }
        
    } failing:^(DYNetworkError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.errorMessage];
        successful(nil);
    }];
}

- (void)dy_startRequestWithFinished:(void (^)(id , DYNetworkError *))finished {
    [self commonRequestWithSuccessful:^(id _Nullable response, DYNetworkError * _Nonnull error) {
        finished(response, error);
    } failing:^(DYNetworkError * _Nonnull error) {
        finished(nil, error);
    }];
}
- (void)dy_startRequestWithSuccessful:(void (^)(id , DYNetworkError * ))successful failing:(void (^)(DYNetworkError *))failing {
   
    [self commonRequestWithSuccessful:successful failing:failing];
  
}

- (void)dy_startRequestWithCompleted:(void (^)(YTKBaseRequest * _Nonnull))Completed {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Completed(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        Completed(request);
    }];
}
#pragma mark - 根方法
- (void)commonRequestWithSuccessful:(void (^)(id _Nullable, DYNetworkError * _Nullable))successful failing:(void (^)(DYNetworkError * _Nonnull))failing {
    if (![self isAvailableNetwork]) {
        [SVProgressHUD showInfoWithStatus:@"当前网络不可用！"];
        successful = nil;
        failing = nil;
        return;
    }
    if (self.dy_requestMethod == YTKRequestMethodPOST) {
        ///如果是post就对参数加密
        self.dy_requestArgument = [FunctionManager encryMethod:self.dy_requestArgument];
    }
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger status = [self getStatusCode:request.responseJSONObject];
        if (status == 0) {
            id data = [self getResponseJson:request.responseJSONObject];
            DYNetworkError *error = nil;
            @try {
                if ([data isKindOfClass:[NSString class]]) {
                    data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
                }
            } @catch (NSException *exception) {
                data = [self getResponseJson:request.responseJSONObject];
                error = [DYNetworkError new];
                error.errorCode = -20000;
                error.errorMessage = [NSString stringWithFormat:@"数据解析错误: %@",exception.reason];
            } @finally {
                if (data == nil && error == nil) {
                    data = [self getResponseJson:request.responseJSONObject];
                }
                if (data == nil) {
                    //                    请求成功 但是返回数据
                    successful(@"1", nil);
                } else {
                    successful(data, nil);
                }
            }
        } else {
            NSString *message = [self getErrorMessage:request.responseJSONObject];
            DYNetworkError *error = [DYNetworkError new];
            error.errorCode = status;
            error.errorMessage = message;
            successful(nil,error);
        }
        DYLog(@"✅✅✅✅✅✅请求地址和参数✅✅✅✅✅✅");
        DYLog(@"%@",request);
        DYLog(@"✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
        
        DYLog(@"✅✅✅✅✅✅请求结果✅✅✅✅✅✅");
        DYLog(@"the response string: \n%@",request.responseString);
        DYLog(@"✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DYNetworkError *error = [DYNetworkError errorWithDomain:NSCocoaErrorDomain code:-8888 userInfo:request.error.userInfo];
        error.errorCode = request.responseStatusCode;
        if (request.response == nil) {
            error.errorMessage = @"服务器无响应，请稍后再试！";
        } else {
            error.errorMessage = @"网络请求失败";
        }
        DYLog(@"❌❌❌❌❌❌❌请求地址和参数❌❌❌❌❌❌❌");
        DYLog(@"%@",request);
        DYLog(@"✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
        DYLog(@"❌❌❌❌❌❌❌请求结果❌❌❌❌❌❌❌");
        DYLog(@"%@",error);
        DYLog(@"✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
        failing(error);
    }];
    
}

- (BOOL)isAvailableNetwork {
   
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    return manager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
    
}


- (id)getResponseJson:(NSDictionary *)dict {
    __block id result = nil;
    NSArray *array = @[@"Data",@"data"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            result = dict[obj];
            *stop = YES;
        }
    }];
    
    return result;
}
- (NSInteger)getStatusCode:(NSDictionary *)dict {
    __block NSInteger code = 0;
    NSArray *array = @[@"code",@"Status",@"State",@"status",@"statusCode"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            code = [dict[obj] integerValue];
            *stop = YES;
        }
    }];
   
    return code;
}
- (NSString *)getErrorMessage:(NSDictionary *)dict {
    __block NSString *message = 0;
    NSArray *array = @[@"alterMsg",@"Error",@"Message",@"msg",@"message",@"alterMsg"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict allKeys] containsObject:obj]) {
            message = [dict objectForKey:obj];
            *stop = YES;
        }
    }];
    if (message.length == 0) {
        message = @"未知错误";
    }
    return message;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    
    NSString *iosVersion = [[FunctionManager sharedInstance] getIosVersion];
    NSString *model = [[FunctionManager sharedInstance] getDeviceModel];
    NSString *appVersion = [[FunctionManager sharedInstance] getApplicationVersion];
    if(iosVersion.length == 0)
        iosVersion = @"";
    if(model.length == 0)
        model = @"";
    if(appVersion.length == 0)
        appVersion = @"";
    self.dy_requestHeaderFieldValueDictionary = @{
//                                                  @"deviceType":@"3",
                                                  @"systemVersion": iosVersion,
                                                  @"deviceModel": model,
                                                  @"appVersion":appVersion,
                                                  @"tenant":kNewTenant,
                                                  @"type":@"APP",
                                                  @"Authorization":AppModel.shareInstance.userInfo.fullToken,
                                                  @"userName":GetUserDefaultWithKey(@"mobile")
                                                  };
    return self.dy_requestHeaderFieldValueDictionary;
}

- (NSString *)baseUrl {
    return self.dy_baseURL;
}

- (NSString *)requestUrl {
    return self.dy_requestUrl;
}

- (id)requestArgument {
    return self.dy_requestArgument;
}

- (YTKRequestMethod)requestMethod {
    return self.dy_requestMethod;
}

- (NSInteger)cacheTimeInSeconds {
    return self.dy_cacheTimeInSeconds;
}

- (id)jsonValidator {
    return self.dy_jsonValidator;
}

- (YTKRequestSerializerType)requestSerializerType {
    return self.dy_requestSerializerType;
}
- (YTKResponseSerializerType)responseSerializerType {
    return self.dy_responseSerializerType;
}
- (NSTimeInterval)requestTimeoutInterval {
    if (self.dy_requestTimeout > 0) {
        return self.dy_requestTimeout;
    }
    return 60;
}
- (AFConstructingBlock)constructingBodyBlock {
    return self.dy_constructingBodyBlock;
}
@end
