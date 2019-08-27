//
//  XDFNetworkConfig.h
//  ClassSignUp
//
//  Created by Hansen on 2018/11/12.
//  Copyright © 2018 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XDFNetworkTypeDev = 0,
    XDFNetworkTypeRelease
    
} XDFNetworkType;


#define kNetworkConfig [NetworkConfig shareConfig]
#define kEnvirmentDefaultType 1
#define kNewTenant [[NetworkConfig shareConfig] tenant]


/**
 * 网络相关配置类
 * 暂时只用到了 修改商户号的功能
 */
@interface NetworkConfig : NSObject
///全局baseURL 默认nil
@property (nonatomic, copy) NSString *networkBaseURL;
///全局CDNURL 默认nil
@property (nonatomic, copy) NSString *networkCDN;
///环境切换
@property (atomic, assign) XDFNetworkType environmentType;
///为了在测试环境下 部分接口可以使用正式环境 配合KBaseURL宏使用
@property (nonatomic, assign, readonly) BOOL isNormallySign;

+ (instancetype)shareConfig;

+ (void)initializeNetworkConfig;

+ (void)showChangeTenantVC;

- (NSString *)getBaseURLWithKey:(NSString *)key;
///如果用的是测试环境 在正式环境下，会自动切换到正式环境
- (NSString *)getBaseURLWithKey:(NSString *)key type:(XDFNetworkType)type;

/**
 * 商户号
 */
- (NSString *)tenant;

@end
