//
//  YEBNetwork.m
//  Project
//
//  Created by fangyuan on 2019/8/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBNetwork.h"
#import <MJExtension.h>

@implementation YEBNetwork

+ (instancetype)getAccountInfo {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/getBalanceDetails";
    obj.dy_requestArgument = @{};
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
}

+ (instancetype)getProfitList {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/earningsReport";
    obj.dy_requestArgument = @{};
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
    
    
}

+ (instancetype)getFinancialInfoWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSInteger)type isASC:(BOOL)isASC {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/getMoneyDetail";
    obj.dy_requestArgument = @{
                               @"current":@(pageIndex),
                               @"isAsc":@(isASC),
                               @"queryParam":@{
                                       @"type":@(type)
                                       },
                               @"size":@(pageSize)
                               
                               };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
    
}

+ (instancetype)shiftInWithMoney:(double)money password:(NSString *)password {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/intoMoney";
    obj.dy_requestArgument = @{
                               @"money":@(money),
                               @"password":password
                               };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
    
}

+ (instancetype)shiftOutWithMoney:(double)money password:(NSString *)password {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/rollOutMoneys";
    obj.dy_requestArgument = @{
                               @"money":@(money),
                               @"password":password
                               };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
    
}

+ (instancetype)setOrModifyPassword:(NSString *)psw mobile:(NSString *)mobile code:(NSString *)code {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"social/skBalanceDailyEarnings/upPayPasswd";
    obj.dy_requestArgument = @{
                               @"user":@{@"code":code,
                               @"password":psw,
                                         @"mobile": mobile}
                               };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeJSON;
    return obj;
}

+ (instancetype)common {
    
    YEBNetwork *obj = [YEBNetwork new];
    obj.dy_baseURL = [AppModel shareInstance].serverUrl;
    obj.dy_requestUrl = @"/auth/common/captcha";
    obj.dy_requestArgument = @{
                               @"bizCode":@"login",
                               @"uuid":@"x1pbgg7bwr41et0b"
                               };
    obj.dy_requestMethod = YTKRequestMethodPOST;
    obj.dy_requestSerializerType = YTKRequestSerializerTypeHTTP;
    return obj;
    
}
@end
