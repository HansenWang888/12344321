//
//  JSPatchManager.m
//  Project
//
//  Created by Mike on 2019/1/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "JSPatchManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>

#define kJSPatchVersion(appVersion)   [NSString stringWithFormat:@"JSPatchVersion_%@", appVersion]


@implementation JSPatchManager
static BOOL _async;



/**
 同步加载还是异步加载补丁更新
 
 @param async YES 异步  NO 同步
 */ 
+(void)asyncUpdate:(BOOL)async {
//    [JPEngine startEngine];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"main.js" ofType:nil];
//    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [JPEngine evaluateScript:script];
//
//    [JPEngine handleException:^(NSString *msg) {
//        NSLog(@"😭😭😭😭😭😭😭😭😭 jspatch  %@", msg);
//    }];
//    return;
    //
    [JPLoader run];
    _async = async;
    
    NSString *projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString *string = [AppModel shareInstance].commonInfo[@"ios.download.path"];
//    NSString *string = kJSPatchURL;
//    if (string.length == 0) {
//        return;
//    }
//    NSRange startRange = [string rangeOfString:@"url="];
//    NSRange endRange = [string rangeOfString:@"/appLoad/"];
//    if (startRange.location > 200 || endRange.location > 200) {
//        return;
//    }
//    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//    NSString *resultStr = [string substringWithRange:range];
    
//    https://www.5858hb.com/appLoad/xzhb/iOSPatch/ProjectWBHB1903241/v1.zip  // 58
//      https://www.96hongbao.com/appLoad/xzhb/iOSPatch/ProjectTTHB1903241/v1.zip  // 天天
//    https://www.520qun.com/appLoad/xzhb/iOSPatch/ProjectXZHB1903241/v1.zip  // 小猪
//    https://www.wangwanghb.com/appLoad/xzhb/iOSPatch/ProjectWWHB1903241/v1.zip  // 旺旺
    NSString *resultStr = kJSPatchURL;
    NSString *requestUrl = [NSString stringWithFormat:@"%@/appLoad/iOSPatch/%@%@/patchVersion.js",resultStr,projectName,appVersion];
    [JSPatchManager patchVersionCheck:requestUrl];
    
}

static dispatch_semaphore_t semaphore;
+(void)patchVersionCheck:(NSString*)urlStr{
    
    if (![JSPatchManager isUserNetOK]) {
        //获取补丁文件名
        NSString *patchFileName = [JSPatchManager currentJSFileName];
        if(patchFileName == nil)
            return;
        //获取本地补丁文件
        [JSPatchManager getJSPatchWithFileName:patchFileName];
        return;
    }
    
    if (!_async) {
        semaphore = dispatch_semaphore_create(0);
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSessionDataTask *dataTask= [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            if (range.location == NSNotFound) {
                NSLog(@"error: network get data not a Dictionary or other error");
                return;
            }
            
            NSString *dicString = [string substringFromIndex:range.location];
            if (!dicString) {
                return;
            }
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[dicString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            [JSPatchManager mangerJSPatchVersion:resultDic];
        } else {
            //如果失败执行本地脚本
            //获取补丁文件名
            NSString *patchFileName = [JSPatchManager currentJSFileName];
            if(patchFileName == nil)
                return;
            //获取本地补丁文件
            [JSPatchManager getJSPatchWithFileName:patchFileName];
            
            if (!_async) {
                dispatch_semaphore_signal(semaphore);
            }
        }
        
    }];
    [dataTask resume];
    
    if (!_async) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
}



+(void)jsPatchLoading:(NSDictionary*)dict{
    NSString *urlString = dict[@"js_url"];
    if (!urlString || [urlString rangeOfString:@"http"].location == NSNotFound) {
        NSLog(@"get js_url failure");
        return;
    }
    NSString *filename = [urlString lastPathComponent];
    NSString *pathExtension = filename.pathExtension;
    
    #pragma mark - zip文件获取
    if ([pathExtension isEqualToString:@"zip"]) {
        
        [JPLoader updateToVersion:[dict[@"js_version"] integerValue] loadURL:dict[@"js_url"] callback:^(NSError *error) {
            if (!error) {
                [JPLoader run];
                [JSPatchManager saveLatestJSVersion:[dict[@"js_version"] integerValue]];
                [JSPatchManager saveLatestJSFileName:dict[@"file_name"]];
                
            }
            
            if (!_async) {
                dispatch_semaphore_signal(semaphore);
            }
        }];
        
    }else if ([pathExtension isEqualToString:@"js"]){
        [JPEngine startEngine];
        
        NSURLSessionDataTask *dataTask= [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [JPEngine evaluateScript:script];
                //保存最新补丁版本号和补丁文件名
                [JSPatchManager saveLatestJSVersion:[dict[@"js_version"] integerValue]];
                [JSPatchManager saveLatestJSFileName:dict[@"file_name"]];
                //保存补丁数据到本地
                [JSPatchManager saveJSPatchToLocal:script fileName:dict[@"file_name"]];
                
            }
            
            if (!_async) {
                dispatch_semaphore_signal(semaphore);
            }
        }];
        [dataTask resume];
    }
    
}


+(void)mangerJSPatchVersion:(NSDictionary*)patchDic {
    
    if (patchDic[@"error"]) {
        return;
    }
    //判断app版本是否对应
    if (patchDic && [JSPatchManager compareVersionNumber:patchDic[@"app_version"]] ==VVOrderedSame) {
        //返回的补丁版本>本地的补丁版本
        if ([patchDic[@"js_version"] integerValue] > [JSPatchManager currentJSVersion]) {
            
            [JSPatchManager jsPatchLoading:patchDic];
        }else if ([patchDic[@"js_version"] integerValue] == [JSPatchManager currentJSVersion]){
            //获取本地补丁文件
            [JSPatchManager getJSPatchWithFileName:patchDic[@"file_name"]];
            
            if (!_async) {
                dispatch_semaphore_signal(semaphore);
            }
            
        }else if ([patchDic[@"js_version"] integerValue] < [JSPatchManager currentJSVersion]){
            //版本回滚
            [JSPatchManager removeLocalJSPatch];
            //重新获取回滚补丁
            [JSPatchManager jsPatchLoading:patchDic];
        }
        
    }else if (patchDic && [JSPatchManager compareVersionNumber:patchDic[@"app_version"]] ==VVOrderedDescending){
        
        [JSPatchManager removeLocalJSPatch];
        
        if (!_async) {
            dispatch_semaphore_signal(semaphore);
        }
    }
    
}

#pragma mark -- 数据管理
+(void)saveJSPatchToLocal:(NSString*)script fileName:(NSString*)filename{
    // script directory
    NSString *scriptDirectory = [self fetchScriptDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:scriptDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:scriptDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *newFilePath = [scriptDirectory stringByAppendingPathComponent:filename];
    [[script dataUsingEncoding:NSUTF8StringEncoding] writeToFile:newFilePath atomically:YES];
    
    if (TARGET_IPHONE_SIMULATOR) {
        NSArray *subPaths = [NSHomeDirectory() componentsSeparatedByString:@"/"];
        
        NSString *path = [NSString stringWithFormat:@"Users/%@/Desktop/%@",subPaths[2],filename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        newFilePath = [NSString stringWithFormat:@"\n//文件保存路径：%@\n",newFilePath];
        script = [newFilePath stringByAppendingString:script];
        BOOL save = [[script dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        if (save) {
            NSLog(@"save to write file success");
        }else{
            NSLog(@"save failure");
        }
    }
    
    
}

+(void)getJSPatchWithFileName:(NSString*)fileName{
    NSString *scriptDirectory = [self fetchScriptDirectory];
    NSString *scriptPath = [scriptDirectory stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath]){
        [JPEngine startEngine];
        [JPEngine evaluateScriptWithPath:scriptPath];
    }
}

+(void)removeLocalJSPatch{
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *scriptDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JSPatch/"]];
    if ([[NSFileManager defaultManager] removeItemAtPath:scriptDirectory error:nil]) {
        NSLog(@"remove sucess");
    }else{
        NSLog(@"remove failure");
    }
    
}

+ (NSString *)fetchScriptDirectory
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *scriptDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JSPatch/%@/", appVersion]];
    return scriptDirectory;
}

+ (NSInteger)currentJSVersion
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger jsV = [[NSUserDefaults standardUserDefaults] integerForKey:kJSPatchVersion(appVersion)];
    return jsV;
}

+(void)saveLatestJSVersion:(NSInteger)version{
    if (!version) {
        return;
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setInteger:version forKey:kJSPatchVersion(appVersion)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)currentJSFileName
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *filekey = [NSString stringWithFormat:@"JSPatchFileName_%@",appVersion];
    NSString *jsFileNam = [[NSUserDefaults standardUserDefaults] valueForKey:filekey];
    return jsFileNam;
}


+(void)saveLatestJSFileName:(NSString*)fileName{
    if (!fileName) {
        return;
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *filekey = [NSString stringWithFormat:@"JSPatchFileName_%@",appVersion];
    [[NSUserDefaults standardUserDefaults] setValue:fileName forKey:filekey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- app版本比较
+ (VVComparisonResult)compareVersionNumber:(NSString*)str{
    if ([str rangeOfString:@"."].location != NSNotFound) {
        str = [str stringByAppendingString:@".0"];
    }
    NSArray *netVersionArr = [str componentsSeparatedByString:@"."];
    //build版本
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    if ([currentVersion rangeOfString:@"."].location != NSNotFound) {
        currentVersion = [currentVersion stringByAppendingString:@".0"];
    }
    NSArray *localVersionArr = [currentVersion componentsSeparatedByString:@"."];
    if (netVersionArr.count>localVersionArr.count) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:localVersionArr];
        [tempArr addObject:@"0"];
        localVersionArr = (NSArray*)tempArr;
    }else if (netVersionArr.count<localVersionArr.count){
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:netVersionArr];
        [tempArr addObject:@"0"];
        netVersionArr = (NSArray*)tempArr;
    }
    for (NSInteger i = 0; i<localVersionArr.count; i++) {
        NSInteger netVersion = [netVersionArr[i] integerValue];
        NSInteger localVersion = [localVersionArr[i] integerValue];
        if (netVersion > localVersion) {
            return VVOrderedAscending;
        }else if (netVersion < localVersion){
            return VVOrderedDescending;
        }
        
    }
    
    return VVOrderedSame;
}


+(BOOL)isUserNetOK{
    if ([self networkWhenRequest] == 0) {
        return NO;
    }
    return YES;
}
+(NSInteger)networkWhenRequest{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    //不知道的状态
    NSInteger status = -1;
    //无网络状态
    if (isNetworkReachable == NO) {
        status = 0;
    }
#if	TARGET_OS_IPHONE
    //移动网络状态
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = 1;
    }
#endif
    //wifi状态
    else {
        status = 2;
    }
    
    return status;
}



@end
