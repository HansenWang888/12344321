//
//  WXManage.m
//  Project
//
//  Created by mini on 2018/8/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "WXManage.h"
#import "CDBaseNet.h"
#import "WXShareModel.h"

#define WXAccessTokenAPI @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define WXUserInfoAPI @"https://api.weixin.qq.com/sns/userinfo"

typedef void (^SuccessBlock)(NSDictionary *success);
typedef void (^ShareBlock)(void);
typedef void (^FailureBlock)(NSError *error);
typedef void (^CodeBlock)(NSString *code);

@interface WXManage ()
@property (nonatomic, copy) ShareBlock share;
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailureBlock failure;
@property (nonatomic, copy) CodeBlock code;

@end

@implementation WXManage


+ (WXManage *)shareInstance{
    static WXManage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //wx
        [WXApi registerApp:kWXKey];
    }
    return self;
}

#pragma mark 微信授权
- (void)wxAuthCode:(void (^)(NSString *))code
           Failure:(void (^)(NSError *))failue{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    self.code = code;
    self.failure = failue;
    req.scope = @"snsapi_userinfo";
    req.state = @"xxxxxxx_xxxxx";
    [WXApi sendReq:req];
}

#pragma makr 微信登录
- (void)wxAuthSuccess:(void (^)(NSDictionary *))success
              Failure:(void (^)(NSError *))failue{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    self.success = success;
    self.failure = failue;
    req.scope = @"snsapi_userinfo";
    req.state = @"xxxxxxx_xxxxx";
    [WXApi sendReq:req];
}

#pragma mark 微信分享
- (void)wxShareObj:(WXShareModel *)obj
         mediaType:(MediaType)mediaType
           Success:(void (^)(void))success
           Failure:(void (^)(NSError *))failue{
    self.share = success;
    self.failure = failue;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = obj.title;
    message.description = obj.content;
    message.messageExt = obj.content;
    
    if (obj.imageIcon) {
        [message setThumbImage:obj.imageIcon];
    }
    if(mediaType == MediaType_url){
        
        if (obj.imageData) {
            message.thumbData = obj.imageData;
        }
        WXWebpageObject *webpage = [WXWebpageObject object];
        webpage.webpageUrl = obj.link;
        message.mediaObject = webpage;
    }else{
        WXImageObject *imageObj = [WXImageObject object];
        imageObj.imageData = obj.imageData;
        message.mediaObject = imageObj;

    }
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = (int)obj.WXShareType;
    [WXApi sendReq:req];
}

+ (BOOL) isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

+ (BOOL) handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[WXManage shareInstance]];
}

#pragma mark WXApiDelegate
-(void) onReq:(BaseReq*)req{
//    NSLog(@"%@",req);
}

-(void) onResp:(BaseResp*)resp{
//    NSLog(@"%@",resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sp = (SendAuthResp *)resp;
        if (sp.code != nil) {
            if (self.code) {
                self.code(sp.code);
            }
            else
                [self getWXAccessTokenByCode:sp.code];
        }
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *sp = (SendMessageToWXResp *)resp;
        if (sp.errCode == 0) {
            self.share();
        }else{
            self.failure(WXError(sp.errCode));
        }
    }
}

- (void)getWXAccessTokenByCode:(NSString *)code{
    CDBaseNet *net = [CDBaseNet normalNet];
    net.param = @{@"appid":kWXKey,@"secret":kWXSecret,@"code":code,@"grant_type":@"authorization_code"};
    net.path = WXAccessTokenAPI;
    [net doGetSuccess:^(NSDictionary *dic) {
        if (dic != NULL) {
            [self getWXUserInfoByObj:@{@"access_token":dic[@"access_token"],@"openid":dic[@"openid"],@"lang":@"zh_CN"}];
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",[error debugDescription]);
        self.failure(error);
    }];
}

- (void)getWXUserInfoByObj:(NSDictionary *)obj{
    CDBaseNet *net = [CDBaseNet normalNet];
    net.param = obj;
    net.path = WXUserInfoAPI;
    [net doGetSuccess:^(NSDictionary *dic) {
        if (dic != NULL) {
            self.success(dic);
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",[error debugDescription]);
        self.failure(error);
    }];
}


@end
