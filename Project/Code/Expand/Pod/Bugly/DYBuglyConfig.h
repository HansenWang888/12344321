//
//  BuglyHotfixConfig.h
//  BuglyHotfix
//
//  Created by Hansen on 2019/1/14.
//  Copyright © 2019 Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BuglyHotfix/Bugly.h>
#import "JPEngine.h"

NS_ASSUME_NONNULL_BEGIN

#define XDFBuglyAppID @"de93e4ef4f"

@interface DYBuglyConfig : NSObject

+ (instancetype)instance;

/*
 *配置热更新
 */
+ (void)configBugly;

/*
 *测试本地补丁文件
 *
 *@param <#name#> <#desc#>
 *@param <#name#> <#desc#>
 */
+ (void)testPatchWithFileName:(NSString *)file;
@end

NS_ASSUME_NONNULL_END
