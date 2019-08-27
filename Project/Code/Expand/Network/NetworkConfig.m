//
//  XDFNetworkConfig.m
//  ClassSignUp
//
//  Created by Hansen on 2018/11/12.
//  Copyright © 2018 mac. All rights reserved.
//

#import "NetworkConfig.h"
#import <UIKit/UIKit.h>
#import "BANetManager.h"

#define kUserDefault_EnvirmentKey @"kUserDefault_EnvirmentKey"
#define kNewTenant_key @"kNewTenant_key"
@interface NetworkConfig ()<NSCopying, NSMutableCopying>
@property (nonatomic, copy) NSArray<NSDictionary *> *environments;

@end
@implementation NetworkConfig {
    dispatch_queue_t _envirmentQueue;
    
    NSString *_tenant;
}
@synthesize environmentType = _environmentType;

+ (instancetype)shareConfig {
    
    static NetworkConfig *obj = nil;
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

+ (void)showChangeTenantVC {
//    if (kNetworkConfig.environments.count == 0) {
//        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有其他环境可切换" preferredStyle:UIAlertControllerStyleAlert];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
//        return;
//    }
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"请选择商户号" message:@"您随意" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:cancle];
    NSArray *array = @[@"100000",@"fy_pig_test",@"pigss"];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:action.title forKey:kNewTenant_key];
            kNetworkConfig->_tenant = action.title;
            [BANetManagerShare.sessionManager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
            //            kNetworkConfig.environmentType = (XDFNetworkType)idx;
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
    
    NSString *target = @"";
#ifdef XZHB
    target = @"XZHB";
#endif
    
#ifdef BBHB
    target = @"BBHB";

#endif
    
#ifdef XLHB
    target = @"XLHB";

#endif
    
#ifdef BWHB
    target = @"BWHB";

#endif
    
#ifdef HBLHB //红包乐
    target = @"HBLHB";

#endif
    
#ifdef QWHB
    target = @"QWHB";

#endif
    
#ifdef RRHB
    target = @"RRHB";

#endif
    
#ifdef DFSHB
    target = @"DFSHB";

#endif
    
#ifdef WBHB
    target = @"WBHB";

#endif
    
#ifdef TTHB
    target = @"TTHB";

#endif
    
#ifdef WWHB
    target = @"WWHB";

#endif
    
#ifdef QQHB
    target = @"QQHB";

#endif
    
#ifdef QXHB
    target = @"QXHB";

#endif
    
#ifdef CSHB
    target = @"CSHB";

#endif
    
    self.environments = @[
                          @{//开发
                              @"Passport":@"http://passport.xdf.cn/",
                              //这个mycenter使用有个坑，在使用时j得拼接/upoc到相对路径
                              @"MyCenter":@"http://xytest.staff.xdf.cn/upoc/",
                              @"AddClassToBuyCart":@"http://bm.t.staff.xdf.cn/",
                              @"MyXdf":@"http://my.xdf.cn/",
                              @"IMServer":@"http://ims.xdf.cn/",
                              @"SpocBase":@"http://xytest.staff.xdf.cn/ixue/h5/toprecart.html",
                              @"Member":@"http://xytest.staff.xdf.cn/ApiMember/",
                              @"ClassICenter":@"http://xytest.staff.xdf.cn/ApiClass/",
                              },
                          @{//生产
                              @"Passport":@"http://passport.xdf.cn/",
                              @"MyCenter":@"http://upoc.xdf.cn/",
                              @"AddClassToBuyCart":@"http://bm.xdf.cn/",
                              @"MyXdf":@"http://my.xdf.cn/",
                              @"IMServer":@"http://ims.xdf.cn/",
                              @"SpocBase":@"http://spoc.xdf.cn/h5/toprecart.html",
                              @"Member":@"http://Member.i.xdf.cn/",
                              @"ClassICenter":@"http://class.i.xdf.cn/",
                              }
                          ];
}

- (NSString *)tenant {
    
    NSString *str = self->_tenant;
#if DEBUG
//    如果是测试  商户号从沙盒中取
    str = [[NSUserDefaults standardUserDefaults] objectForKey:kNewTenant_key];
#endif
    if (str.length == 0) {
        str = kTenant;
    }
    if (str.length == 0) {
        str = @"";
    }
    return str;
}

@end
