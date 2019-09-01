//
//  XDFNetworkConfig.m
//  ClassSignUp
//
//  Created by Hansen on 2018/11/12.
//  Copyright © 2018 mac. All rights reserved.
//

#import "DYNetworkConfig.h"
#import "YTKNetworkAgent.h"
#import "YTKNetworkConfig.h"
#import <UIKit/UIKit.h>
#import <AFSecurityPolicy.h>

#define kUserDefault_EnvirmentKey @"kUserDefault_EnvirmentKey"
@interface DYNetworkConfig ()<NSCopying, NSMutableCopying>
@property (nonatomic, copy) NSArray<NSDictionary *> *environments;

@end
@implementation DYNetworkConfig {
    dispatch_queue_t _envirmentQueue;
}
@synthesize environmentType = _environmentType;

+ (instancetype)shareConfig {
    
    static DYNetworkConfig *obj = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        obj = [[super allocWithZone:NULL] init];
        [obj setupDefaultData];
        obj->_envirmentQueue = dispatch_queue_create("envirmentQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return obj;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    //为了保证在外部调用alloc init或者new创建的对象也是这个单例
    return [self shareConfig];
}

- (id)copyWithZone:(NSZone *)zone {
    //保证在对单例进行copy操作的时候也是返回这个对象
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    //保证在对单例进行mutableCopy操作的时候也是返回这个对象
    return self;
}



+ (void)initializeNetworkConfig {
    [DYNetworkConfig.shareConfig skipCertificationVerify];
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"image/gif", nil] forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    //    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_EnvirmentKey];
    //    if (value) {
    //        kNetworkConfig.environmentType = (XDFNetworkType)value.integerValue;
    //    } else {
    //
    //    }
#if DEBUG
    kNetworkConfig.environmentType = kEnvirmentDefaultType;
#else
    kNetworkConfig.environmentType = 1;
#endif
}
/**
 * 跳过证书验证
 */
- (void)skipCertificationVerify{
    YTKNetworkConfig.sharedConfig.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    YTKNetworkConfig.sharedConfig.securityPolicy.allowInvalidCertificates = YES;
    [YTKNetworkConfig.sharedConfig.securityPolicy setValidatesDomainName:NO];
}

- (void)setNetworkCDN:(NSString *)networkCDN {
    _networkCDN = networkCDN;
    [YTKNetworkConfig sharedConfig].cdnUrl = networkCDN;
}

- (void)setNetworkBaseURL:(NSString *)networkBaseURL {
    _networkBaseURL = networkBaseURL;
    [YTKNetworkConfig sharedConfig].baseUrl = networkBaseURL;
}
+ (void)showChangeEnvirmentVC {
    if (kNetworkConfig.environments.count == 0) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有其他环境可切换" preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        return;
    }
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"请选择环境" message:@"您随意" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:cancle];
    NSArray *array = @[@"开发",@"生产"];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            kNetworkConfig.environmentType = (XDFNetworkType)idx;
        }];
        [vc addAction:action];
    }];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (NSString *)getBaseURLWithKey:(NSString *)key {
    _isNormallySign = YES;
    return self.environments[self.environmentType][key];
}
- (NSString *)getBaseURLWithKey:(NSString *)key type:(XDFNetworkType)type {
    _isNormallySign = YES;
    if (self.environmentType == XDFNetworkTypeRelease) {
        return self.environments[XDFNetworkTypeRelease][key];
    }
    if (type == 1) {
        _isNormallySign = NO;
    }
    return self.environments[type][key];
}
- (void)setEnvironmentType:(XDFNetworkType)environmentType {
    
    dispatch_barrier_sync(_envirmentQueue, ^{
        
        self->_environmentType = environmentType;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(environmentType) forKey:kUserDefault_EnvirmentKey];
        
    });
    
}

- (XDFNetworkType)environmentType {
    
    __block int i;
    dispatch_sync(_envirmentQueue, ^{
        i = self->_environmentType;
    });
    return i;
}

- (void)setupDefaultData {
    self.environments = @[
                          @{//开发
                              @"baseURL":@"http://148.70.103.162:8002",
                              },
                          @{//生产
                              @"baseURL":@"http://api.pikavay.com",
                              }
                          ];
}

@end
