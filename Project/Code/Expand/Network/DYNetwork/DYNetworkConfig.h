//
//  XDFNetworkConfig.h
//  ClassSignUp
//
//  Created by Hansen on 2018/11/12.
//  Copyright © 2018 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DYNetworkTypeDev = 0,
    DYNetworkTypeRelease
    
} DYNetworkType;

#define kBaseURL_Passport                [kNetworkConfig getBaseURLWithKey:@"Passport"]
#define kBaseURL_MyCenter                [kNetworkConfig getBaseURLWithKey:@"MyCenter"]
#define kBaseURL_AddClassToBuyCart       [kNetworkConfig getBaseURLWithKey:@"AddClassToBuyCart"]
#define kBaseURL_MyXdf                   [kNetworkConfig getBaseURLWithKey:@"MyXdf"]
#define kBaseURL_IMServer                [kNetworkConfig getBaseURLWithKey:@"IMServer"]
#define kBaseURL_SpocBase                [kNetworkConfig getBaseURLWithKey:@"SpocBase"]
#define kBaseURL_Member                  [kNetworkConfig getBaseURLWithKey:@"Member"]
#define kBaseURL_ClassICenter            [kNetworkConfig getBaseURLWithKey:@"ClassICenter"]

#define kBaseURL [kNetworkConfig getBaseURLWithKey:@"baseURL"]
///如果用的是测试环境 在正式环境下，会自动切换到正式环境
#define KBaseURL(string_key,enum_type) [kNetworkConfig getBaseURLWithKey:string_key type:enum_type]

#define kNetworkConfig [DYNetworkConfig shareConfig]
#define kEnvirmentDefaultType 0

@interface DYNetworkConfig : NSObject
///全局baseURL 可以不设置
@property (nonatomic, copy) NSString *networkBaseURL;
///全局CDNURL 可以不设置
@property (nonatomic, copy) NSString *networkCDN;
///环境切换
@property (atomic, assign) DYNetworkType environmentType;
///为了在测试环境下 部分接口可以使用正式环境 配合KBaseURL宏使用
@property (nonatomic, assign, readonly) BOOL isNormallySign;

+ (instancetype)shareConfig;

+ (void)initializeNetworkConfig;

+ (void)showChangeEnvirmentVC;

- (NSString *)getBaseURLWithKey:(NSString *)key;
///如果用的是测试环境 在正式环境下，会自动切换到正式环境
- (NSString *)getBaseURLWithKey:(NSString *)key type:(DYNetworkType)type;
@end
