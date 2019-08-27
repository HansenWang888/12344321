//
//  NetRequestManager.m
//  XM_12580
//
//  Created by mac on 12-7-9.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import "NetRequestManager.h"
#import "NetResponseManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager2.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "FunctionManager.h"
#import "SAMKeychain.h"

@implementation RequestInfo
-(id)init{
    if(self = [super init]){
        self.act = ActAll;
    }
    return self;
}

-(id)initWithType:(RequestType)type{
    if(self = [super init]){
        self.act = ActAll;
        self.requestType = type;
    }
    return self;
}
@end

@implementation NetRequestManager

+ (NetRequestManager *)sharedInstance{
    static dispatch_once_t onceNetReq;
    static NetRequestManager *instance = nil;
    dispatch_once(&onceNetReq, ^{
        if(instance == nil)
            instance = [[NetRequestManager alloc] init];
    });
    return instance;
}

-(id)init{
    self=[super init];
    if (self){
        _httpManagerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
}

#pragma mark    - 公共部分

-(void)requestWithData:(NSDictionary *)dict requestInfo:(RequestInfo *)requestInfo success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    NSString *auth = nil;
    NSDictionary* encryDic = @{
                               };
    
    if(requestInfo.act == ActRequestCommonInfo||
       requestInfo.act == ActRequestToken ||
       requestInfo.act == ActCheckLogin ||
       requestInfo.act == ActRequestCaptcha ||
       requestInfo.act == ActRegister ||
       requestInfo.act == ActCheckRegister||
       requestInfo.act == ActResetPassword||
       requestInfo.act == ActRequestVerifyCode ||
       requestInfo.act == ActRequestTokenBySMS ||
       requestInfo.act == ActRemoveToken||
       requestInfo.act == ActRequestMsgBanner||
       requestInfo.act == ActRequestClickBanner){
        
        auth = [AppModel shareInstance].authKey;
        //getCommonInfoBack//config
        if(dict){
            NSLog(@"=================auth 接口地址:%@ ===参数:%@",requestInfo.url,[dict mj_JSONString]);
            encryDic = dict;
        }
        else{
            NSLog(@"=================auth 接口地址:%@ ===参数:nil",requestInfo.url);
        }
        
        [httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[FunctionManager isEmpty:GetUserDefaultWithKey(@"mobile")]? @"":GetUserDefaultWithKey(@"mobile")] forHTTPHeaderField:@"userName"];//@"10026212691"
    }else{
        auth = [AppModel shareInstance].userInfo.fullToken;
        //getTokenBack
        if(dict){
            NSLog(@"=================net 接口地址:%@ ===参数:%@",requestInfo.url,[dict mj_JSONString]);
            encryDic = [FunctionManager encryMethod:dict];
        }
        else{
            NSLog(@"=================net 接口地址:%@ ===参数:nil",requestInfo.url);
        }
        NSString *mobile = GetUserDefaultWithKey(@"mobile");
        
        [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
        
        [httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",mobile] forHTTPHeaderField:@"userName"];//@"10026212691"
    }
    if(requestInfo.act != ActRequestCommonInfo){
        if(auth == nil){
            NSLog(@"auth 为空");
            if([AppModel shareInstance].userInfo.isLogined == YES) {
                [[AppModel shareInstance] logout];
            }
            if(failBlock)
                failBlock(@"系统错误，请退出重新登录");
            return;
        }
    }
//    requestInfo.startTime = [[NSDate date] timeIntervalSince1970];
    requestInfo.url = [requestInfo.url stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    
    WEAK_OBJ(weakManager, httpSessionManager);
    if(requestInfo.requestType == RequestType_post){
        [httpSessionManager POST:requestInfo.url parameters:encryDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
            [weakManager clear];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
            [weakManager clear];
        }];
    }else if(requestInfo.requestType == RequestType_get){
        [httpSessionManager GET:requestInfo.url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
            [weakManager clear];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
            [weakManager clear];
        }];
    }
}

-(AFHTTPSessionManager2 *)createHttpSessionManager{
    for (AFHTTPSessionManager2 *manager in _httpManagerArray) {
        if(manager.act == ActNil) {
            [manager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
            return manager;
        }
    }
    AFHTTPSessionManager2 *manager = [AFHTTPSessionManager2 manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
    
    [_httpManagerArray addObject:manager];
    
    NSString *iosVersion = [[FunctionManager sharedInstance] getIosVersion];
    NSString *model = [[FunctionManager sharedInstance] getDeviceModel];
    NSString *appVersion = [[FunctionManager sharedInstance] getApplicationVersion];
    if(iosVersion)
        [manager.requestSerializer setValue:iosVersion forHTTPHeaderField:@"systemVersion"];
    if(model)
        [manager.requestSerializer setValue:model forHTTPHeaderField:@"deviceModel"];
    if(appVersion)
        [manager.requestSerializer setValue:appVersion forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
    [manager.requestSerializer setValue:@"APP" forHTTPHeaderField:@"type"];
    [manager.requestSerializer setValue:@"3" forHTTPHeaderField:@"deviceType"];
    return manager;
}

#pragma mark -
#pragma mark 接口部分
-(NSMutableDictionary *)createDicWithHead{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

#pragma mark 密码请求tocken
-(void)requestTokenWithDic:(NSMutableDictionary*)dic
                   success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestToken];
    
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    //    [bodyDic setObject:account forKey:@"username"];
    //    [bodyDic setObject:s forKey:@"password"];
    
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
-(void)checkLoginWithDic:(NSMutableDictionary*)dic
                    success:(CallbackBlock)successBlock
                       fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckLogin];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark 短信验证码获取tocken
-(void)requestTockenWithPhone:(NSString *)phone
                      smsCode:(NSString *)smsCode
                      success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestTokenBySMS];
    NSString *par = [NSString stringWithFormat:@"mobile=%@&code=%@&grant_type=mobile&scope=server",phone,smsCode];
    NSString *url = [NSString stringWithFormat:@"%@?%@",info.url,par];
    info.url = url;
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 重置密码（找回密码）
-(void)findPasswordWithPhone:(NSString *)phone
                     smsCode:(NSString *)smsCode
                    password:(NSString *)password
                     success:(CallbackBlock)successBlock
                        fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActResetPassword];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    [bodyDic setObject:smsCode forKey:@"code"];
    [bodyDic setObject:password forKey:@"password"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark 重设支付密码

-(void)setPayPasswordWithPhone:(NSString *)phone
                       smsCode:(NSString *)smsCode
                      password:(NSString *)password
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActUpPayPasswd];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    [bodyDic setObject:smsCode forKey:@"code"];
    [bodyDic setObject:password forKey:@"password"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark 手机注册
-(void)registerWithDic:(NSMutableDictionary*)dic
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRegister];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
-(void)checkRegisterWithDic:(NSMutableDictionary*)dic
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckRegister];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark 请求用户信息
-(void)requestUserInfoWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestUserInfo];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 请求验证码
-(void)requestSmsCodeWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock) failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestVerifyCode];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    switch (type) {
        case GetSmsCodeFromVCRegister:
            [bodyDic setObject:@"reg" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCResetPW:
            [bodyDic setObject:@"reset_passwd" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCLoginBySMS:
            [bodyDic setObject:@"login" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCPayPW:
            [bodyDic setObject:@"pay_passwd" forKey:@"bizCode"];
            break;
        default:
            break;
    }
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
-(void)requestImageCaptchaWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestCaptcha];
    NSString* bizcode = @"";
    switch (type) {
        case GetSmsCodeFromVCRegister:
            bizcode = @"reg";
            break;
        case GetSmsCodeFromVCResetPW:
            bizcode = @"reset_passwd";
            break;
        case GetSmsCodeFromVCLoginBySMS:
            bizcode = @"login";
            break;
        case GetSmsCodeFromVCPayPW:
            bizcode = @"pay_passwd";
            break;
        default:
            break;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?bizCode=%@&uuid=%@",info.url,bizcode,phone];
    info.requestType = RequestType_post;
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [httpSessionManager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
        failBlock(error);
    }];
}

#pragma mark 获取银行列表
-(void)requestBankListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBankList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

-(void)requestDrawRecordListWithPage:(NSInteger)page success:(CallbackBlock)successBlock
                                fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestWithdrawHistory];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:@"50" forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 提现
-(void)withDrawWithAmount:(NSString *)amount//金额
                 userName:(NSString *)name//名字
                 bankName:(NSString *)backName//银行名
                   bankId:(NSString *)bankId//银行id
                  address:(NSString *)address//地址
                  uppayNO:(NSString *)uppayNO //卡号
                   remark:(NSString *)remark//备注
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActDraw];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:amount forKey:@"amount"];
    [bodyDic setObject:bankId forKey:@"userPaymentId"];
    [bodyDic setObject:name forKey:@"uppPayName"];
    [bodyDic setObject:backName forKey:@"uppayBank"];
    [bodyDic setObject:address forKey:@"uppayAddress"];
    [bodyDic setObject:uppayNO forKey:@"uppayNo"];
    [bodyDic setObject:remark forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

-(void)withDrawWithAmount:(NSString *)amount//金额
                   bankId:(NSString *)bankId//银行id
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActDraw];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:amount forKey:@"amount"];
    [bodyDic setObject:bankId forKey:@"userPaymentId"];
    [bodyDic setObject:@"无" forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取账单列表
-(void)requestBillListWithName:(NSString *)billName
                   categoryStr:(NSString *)categoryStr
                     beginTime:(NSString *)beginTime
                       endTime:(NSString *)endTime
                          page:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBillList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    NSDictionary* dic = @{
                          @"billtName":[NSString stringWithFormat:@"%@",![FunctionManager isEmpty:billName]?billName:@""],
                          @"category":[NSString stringWithFormat:@"%@",categoryStr],
                          @"endTime":[NSString stringWithFormat:@"%@",endTime],
                          @"startTime":[NSString stringWithFormat:@"%@",beginTime]
                          };
    [bodyDic setObject:dic forKey:@"queryParam"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 账单类型   线上充值 人工充值 抢包 踩雷...
-(void)requestBillTypeWithType:(NSString *)type success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBillTypeList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",type] forKey:@"category"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 上传图片
-(void)upLoadImageObj:(UIImage *)image
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *requestInfo = [self requestInfoWithAct:ActUploadImg];
    NSData *data = UIImagePNGRepresentation(image);
    
    NSString *auth = [AppModel shareInstance].userInfo.fullToken;
    if(auth == nil)
        return;
//    NSLog(@"%@",requestInfo.url);
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    NSString *mobile = GetUserDefaultWithKey(@"mobile");
    [httpSessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    WEAK_OBJ(weakManager, httpSessionManager);
    
    [httpSessionManager POST:requestInfo.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
        [weakManager clear];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
        [weakManager clear];
    }];
}

#pragma mark 编辑用户信息
-(void)editUserInfoWithUserAvatar:(NSString *)url
                         userNick:(NSString *)nickName
                           gender:(NSInteger)gender
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActModifyUserInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:url forKey:@"userAvatar"];
    [bodyDic setObject:nickName forKey:@"userNick"];
    [bodyDic setObject:INT_TO_STR(gender) forKey:@"userGender"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取app配置
-(void)requestAppConfigWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestCommonInfo];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 我的下线列表
-(void)requestMyPlayerWithPage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                    userString:(NSString *)userString
                          type:(NSInteger)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActMyPlayer];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    if(userString.length > 0){
        [bodyDic setObject:[NSString stringWithFormat:@"%@",userString] forKey:@"userId"];
    }
    if(type >= 0){
        [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"];
    }
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取通知列表
-(void)requestSystemNoticeWithSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSystemNotice];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"1"] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"20"] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取消息头部banner
-(void)requestMsgBannerWithId:(NSInteger)adId WithPictureSpe:(NSInteger)pictureSpe success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMsgBanner];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",[FunctionManager getAppSource]] forKey:@"clientType"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",adId] forKey:@"id"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",pictureSpe] forKey:@"pictureSpe"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
    
}
-(void)requestClickBannerWithAdvSpaceId:(NSString *)advSpaceId Id:(NSString*)adId success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestClickBanner];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",[FunctionManager getAppSource]] forKey:@"clientType"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",advSpaceId] forKey:@"advSpaceId"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",adId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 请求分享列表
-(void)requestShareListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestShareList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:@"1" forKey:@"current"];
    [bodyDic setObject:@"50" forKey:@"size"];
    [bodyDic setObject:@"true" forKey:@"isAsc"];
    [bodyDic setObject:@"id" forKey:@"sort"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 增加分享页的访问量
-(void)addShareCountWithId:(NSInteger)shareId success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActAddShareCount];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)shareId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 充值列表
-(void)requestRechargeListWithSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 报表
-(void)requestReportFormsWithUserId:(NSString *)userId beginTime:(NSString *)beginTime endTime:(NSString *)endTime success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestReportForms];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:beginTime forKey:@"startTime"];
    [bodyDic setObject:endTime forKey:@"endTime"];
    [bodyDic setObject:userId forKey:@"loginUserId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 删除token
-(void)removeTokenWithSuccess:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRemoveToken];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取活动列表
-(void)requestActivityListWithUserId:(NSString *)userId success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestActivityList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 领取奖励
-(void)getRewardWithActivityType:(NSString *)type userId:(NSString *)userId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetReward];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:type forKey:@"promotType"];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 领取首充 二充奖励
-(void)getFirstRewardWithUserId:(NSString *)userId rewardType:(NSInteger)rewardType success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetFirstRewardInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:INT_TO_STR(rewardType) forKey:@"promotType"];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 申请成为代理
-(void)askForToBeAgentWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActToBeAgent];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 查询可抽奖列表
-(void)getLotteryListWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetLotteryList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 查询可抽奖具体信息
-(void)getLotteryDetailWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetLotterys];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)lId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 抽奖
-(void)lotteryWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActLottery];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)lId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 添加银行卡
-(void)addBankCardWithUserName:(NSString *)userName cardNO:(NSString *)cardNO bankId:(NSString *)bankId bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActAddBankCard];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userName forKey:@"user"];
    [bodyDic setObject:bankId forKey:@"upaytId"];
    [bodyDic setObject:cardNO forKey:@"upayNo"];
    [bodyDic setObject:bankCode forKey:@"code"];
    [bodyDic setObject:address forKey:@"bankRegion"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 我的银行卡
-(void)getMyBankCardListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMyBankList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取首先支付通道列表
-(void)requestFirstRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeListFirst];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取所有支付通道列表
-(void)requestAllRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeListAll];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 提交支付资料
-(void)submitRechargeInfoWithBankId:(NSString *)bankId
                           bankName:(NSString *)bankName
                             bankNo:(NSString *)bankNo
                                tId:(NSString *)tId
                              money:(NSString *)money
                               name:(NSString *)name
                            orderId:(NSString *)orderId
                               type:(NSInteger)type
                           typeCode:(NSInteger)typeCode
                             userId:(NSString *)userId
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActSubmitRechargeInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    if(bankId)
        [bodyDic setObject:bankId forKey:@"bankId"];
    if(bankName)
        [bodyDic setObject:bankName forKey:@"bankName"];
    [bodyDic setObject:bankNo forKey:@"bankNo"];
    [bodyDic setObject:tId forKey:@"id"];
    [bodyDic setObject:money forKey:@"money"];
    [bodyDic setObject:name forKey:@"name"];
//    [bodyDic setObject:INT_TO_STR(type) forKey:@"type"];
    [bodyDic setObject:userId forKey:@"userId"];
//    [bodyDic setObject:INT_TO_STR(typeCode) forKey:@"typeCode"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 提交订单
-(void)submitOrderRechargeInfoWithId:(NSString *)orderId money:(NSString *)money
                                name:(NSString *)name success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActOrderRecharge];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:orderId forKey:@"id"];
    [bodyDic setObject:money forKey:@"money"];
    [bodyDic setObject:name forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取分享url
-(void)getShareUrlWithCode:(NSString *)code success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestShareUrl];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:code forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取新手引导图片列表
-(void)getGuideImageListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGuideImageList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:@"6" forKey:@"helpType"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 活动奖励列表
-(void)getActivityListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestActivityList2];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"1"] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"20"] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取jjj活动阶段
-(void)getActivityJiujiJingListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestJiujiJingList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark 获取抢包活动阶段
-(void)getActivityQiaoBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestQiaoBaoList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取发包活动阶段
-(void)getActivityFaBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestFaBaoList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取活动详情
-(void)getActivityDetailWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    NSString *urlTail = nil;
    //6000豹子顺子奖励 5000直推流水佣金 2000邀请好友充值 1100充值奖励  3000发包奖励 4000抢包奖励
    if(type == RewardType_bzsz)
        urlTail = @"social/promotReward/bzsz/detail";
    else if(type == RewardType_ztlsyj)
        urlTail = @"social/promotReward/commission/detail";
    else if(type == RewardType_yqhycz)
        urlTail = @"social/promotReward/invite/detail";
    else if(type == RewardType_czjl)
        urlTail = @"social/promotReward/recharge/detail";
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取发包抢包奖励
-(void)getRewardWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    NSString *urlTail = nil;
    if(type == RewardType_qbjl)//4000抢包奖励 3000发包奖励
        urlTail = @"social/promotReward/get/rob/reward/money";
    else if(type == RewardType_fbjl){
        urlTail = @"social/promotReward/get/send/reward/money";
    }else{
        urlTail = @"social/promotReward/get/relief/money";
    }
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取下线基础信息
-(void)requestMyPlayerCommonInfoWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckMyPlayers];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 个人报表信息
-(void)requestUserReportInfoWithId:(NSString *)userId success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestAgentReportInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userId forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 查询所有推广教程
-(void)requestCopyListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestPromotionCourse];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 查询所有支付通道
-(void)requestAllRechargeChannelWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeChannel];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark act
-(RequestInfo *)requestInfoWithAct:(Act)act{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    info.act = act;
    NSString *urlTail = nil;
    switch (act) {
        case ActRequestMsgBanner:
            urlTail = @"auth/basic/getAdv";
            break;
        case ActRequestClickBanner:
            urlTail = @"auth/basic/addAdvCnt";
            break;
        case ActRequestToken:
            urlTail = @"auth/nauth/mobile/token";
            break;
        case ActCheckLogin:
            urlTail = @"auth/nauth/regform/loginShowList";
            break;
        case ActRequestCaptcha:
            urlTail = @"auth/common/captcha";
            break;
        case ActRequestTokenBySMS:
            urlTail = @"auth/mobile/token";
            break;
        case ActCheckRegister:
            urlTail = @"auth/nauth/regform/regShowList";
            break;
        case ActRegister:
            urlTail = @"auth/nauth/mobile/token/reg";
            break;
        case ActRequestUserInfo:
            urlTail = @"admin/user/baseInfo";
            break;
        case ActResetPassword:
            urlTail = @"auth/user/mobile/token/resetPasswd";
            break;
        case ActUpPayPasswd:
            urlTail = @"social/skBalanceDailyEarnings/upPayPasswd";
            break;
        case ActRequestVerifyCode:
            urlTail = @"auth/common/smsCode";
            break;
        case ActRequestBankList:
            urlTail = @"pay/cashDraws/getSysBankcard";
            break;
        case ActDraw:
            urlTail = @"pay/cashDraws/cash";
            break;
        case ActRequestBillList:
            urlTail = @"pay/bill/page";
            break;
        case ActRequestBillTypeList:
            urlTail = @"pay/bill/list";
            break;
        case ActUploadImg:
            urlTail = @"admin/user/upload";
            break;
        case ActModifyUserInfo:
            urlTail = @"admin/user/updateAvatarNickName";
            break;
        case ActRequestCommonInfo:
            urlTail = @"auth/basic/getAppConfig";
            break;
        case ActMyPlayer:
            urlTail = @"social/proxy/myUserPage";
            break;
        case ActCheckMyPlayers:
            urlTail = @"social/proxy/team/count";
            break;
        case ActRequestAgentReportInfo:
            urlTail = @"social/proxy/team/user/report";
            break;
        case ActRequestPromotionCourse:
            urlTail = @"social/proxy/queryPromoteCourse";
            break;
        case ActRequestSystemNotice:
            urlTail = @"social/basic/noticePage";
            break;
        case ActRequestShareList:
            urlTail = @"social/promotionShare/page";
            break;
        case ActAddShareCount:
            urlTail = @"social/promotionShare/addCount";
            break;
        case ActRequestRechargeList:
            urlTail = @"finance/skPayChannel/page";
            break;
        case ActRequestReportForms:
            urlTail = @"social/proxy/allData";
            break;
        case ActRemoveToken:
            urlTail = @"auth/authentication/removeToken";
            break;
        case ActRequestActivityList:
            urlTail = @"social/promotReward/list";
            break;
        case ActGetReward:
            urlTail = @"social/promotReward/receive";
            break;
        case ActGetFirstRewardInfo:
            urlTail = @"social/promotReward/getRechargeReward";
            break;
        case ActToBeAgent:
            urlTail = @"social/proxy/applyAgent";
            break;
        case ActGetLotterys:
            urlTail = @"microgame/userLottery/lotteryItems";
            break;
        case ActGetLotteryList:
            urlTail = @"microgame/userLottery/lotteryUserList";
            break;
        case ActLottery:
            urlTail = @"microgame/userLottery/startLottery";
            break;
        case ActAddBankCard:
            urlTail = @"pay/cashDraws/addBankcard";
            break;
        case ActRequestMyBankList:
            urlTail = @"pay/cashDraws/getMyBankcard";
            break;
        case ActRequestWithdrawHistory:
            urlTail = @"pay/cashDraws/page";
            break;
        case ActRequestRechargeListFirst:
            urlTail = @"finance/skPayChannel/page";
            break;
        case ActRequestRechargeListAll:
            urlTail = @"finance/skPayChannel/querPromotionShares";
            break;
        case ActRequestRechargeChannel:
            urlTail = @"pay/recharge/getChanel";
            break;
        case ActOrderRecharge:
            urlTail = @"pay/recharge/submit";
            break;
        case ActRequestShareUrl:
            urlTail = @"social/promotionShare/getDomain";
            break;
        case ActRequestGuideImageList:
            urlTail = @"social/basic/querySkHelpCenter";
            break;
        case ActRequestActivityList2:
            urlTail = @"social/promotReward/promotPage";
            break;
        case ActRequestFaBaoList:
            urlTail = @"social/promotReward/send/detail";
            break;
        case ActRequestQiaoBaoList:
            urlTail = @"social/promotReward/rob/detail";
            break;
        case ActRequestJiujiJingList:
            urlTail = @"social/promotReward/relief";
            break;
        case ActNil:
            urlTail = @"";
            break;
        default:
            break;
    }
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    return info;
}

@end
