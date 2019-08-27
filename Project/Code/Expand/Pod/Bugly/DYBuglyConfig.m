//
//  BuglyHotfixConfig.m
//  BuglyHotfix
//
//  Created by Hansen on 2019/1/14.
//  Copyright © 2019 Hansen. All rights reserved.
//

#import "DYBuglyConfig.h"

@interface DYBuglyConfig ()<NSCopying,BuglyDelegate>

@end

@implementation DYBuglyConfig


+ (instancetype)instance {
    
    static DYBuglyConfig *obj = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[super allocWithZone:NULL] init];
    });
    return obj;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [self instance];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

+ (void)configBugly{
    //初始化 Bugly 异常上报
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.delegate = [DYBuglyConfig instance];
    config.debugMode = YES;
    config.reportLogLevel = BuglyLogLevelInfo;
    
    [Bugly startWithAppId:XDFBuglyAppID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    //捕获 JSPatch 异常并上报
    [JPEngine handleException:^(NSString *msg) {
        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
        [Bugly reportException:jspatchException];
    }];
    //检测补丁策略
    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
        //有新补丁或本地补丁状态正常
        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
            //获取本地补丁路径
            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
            if (patchDirectory) {
                //指定执行的 js 脚本文件名
                NSString *patchFileName = @"xdfpatch.js";
                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
                //执行补丁加载并上报激活状态
                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
                    BLYLogInfo(@"evaluateScript success");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
                }else {
                    BLYLogInfo(@"evaluateScript failed");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
                }
            }
        }
    }];
}

+ (void)testPatchWithFileName:(NSString *)file {
    
    [JPEngine evaluateScriptWithPath:[[NSBundle mainBundle] pathForResource:file ofType:nil]];
    [JPEngine handleException:^(NSString *msg) {
        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
        NSLog(@"测试热更新补丁异常：\n%@",jspatchException);
    }];
}

#pragma mark delegate

- (NSString *)attachmentForException:(NSException *)exception {
    
    return exception.reason;
}
@end
