

#import "BANetManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

/*! 系统相册 */
#import <Photos/Photos.h>

#import "AFNetworkActivityIndicatorManager.h"
#import "UIImage+CompressImage.h"
#import "BANetManagerCache.h"

#import "BADataEntity.h"

#import "GTMBase64.h"
#import "NSData+AES.h"
static NSMutableArray *tasks;

//static void *isNeedCacheKey = @"isNeedCacheKey";

//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...){}
//#endif

@interface BANetManager ()



@end

@implementation BANetManager

+ (instancetype)sharedBANetManager
{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedBANetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBANetManager = [[super allocWithZone:NULL] init];
    });
    return sharedBANetManager;
}

+ (void)initialize
{
    [self setupBANetManager];
}

+ (void)setupBANetManager
{
    BANetManagerShare.sessionManager = [AFHTTPSessionManager manager];
    
    //    BANetManagerShare.requestSerializer = BAHttpRequestSerializerJSON;
    //    BANetManagerShare.responseSerializer = BAHttpResponseSerializerJSON;
    
    /*! 设置请求超时时间，默认：30秒 */
    BANetManagerShare.timeoutInterval = 15;
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 设置返回数据类型为 json, 分别设置请求以及相应的序列化器 */
    /*!
     根据服务器的设定不同还可以设置：
     json：[AFJSONResponseSerializer serializer](常用)
     http：[AFHTTPResponseSerializer serializer]
     */
    //    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //    /*! 这里是去掉了键值对里空对象的键值 */
    ////    response.removesKeysWithNullValues = YES;
    //    BANetManagerShare.sessionManager.responseSerializer = response;
    
    /* 设置请求服务器数类型式为 json */
    /*!
     根据服务器的设定不同还可以设置：
     json：[AFJSONRequestSerializer serializer](常用)
     http：[AFHTTPRequestSerializer serializer]
     */
    AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
    BANetManagerShare.sessionManager.requestSerializer = request;
    /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
    NSString *token = [AppModel shareInstance].userInfo.fullToken; // 后台Token
    [BANetManagerShare.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *mobile = GetUserDefaultWithKey(@"mobile");
    [BANetManagerShare.sessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [BANetManagerShare.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *iosVersion = [[FunctionManager sharedInstance] getIosVersion];
    NSString *model = [[FunctionManager sharedInstance] getDeviceModel];
    NSString *appVersion = [[FunctionManager sharedInstance] getApplicationVersion];
    if(iosVersion)
        [BANetManagerShare.sessionManager.requestSerializer setValue:iosVersion forHTTPHeaderField:@"systemVersion"];
    if(model)
        [BANetManagerShare.sessionManager.requestSerializer setValue:model forHTTPHeaderField:@"deviceModel"];
    if(appVersion)
        [BANetManagerShare.sessionManager.requestSerializer setValue:appVersion forHTTPHeaderField:@"appVersion"];
    [BANetManagerShare.sessionManager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
    [BANetManagerShare.sessionManager.requestSerializer setValue:@"APP" forHTTPHeaderField:@"type"];
    [BANetManagerShare.sessionManager.requestSerializer setValue:@"3" forHTTPHeaderField:@"deviceType"];
    /*! 设置响应数据的基本类型 */
    BANetManagerShare.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
    
    // 配置自建证书的Https请求
    //    [self ba_setupSecurityPolicy];
}

/**
 配置自建证书的Https请求，只需要将CA证书文件放入根目录就行
 */
+ (void)ba_setupSecurityPolicy
{
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    
    if (cerSet.count == 0)
    {
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        BANetManagerShare.sessionManager.securityPolicy = securityPolicy;
    }
    else
    {
        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        // 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        // 如果需要验证自建证书(无效证书)，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // 是否需要验证域名，默认为YES
        //    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
        
        BANetManagerShare.sessionManager.securityPolicy = securityPolicy;
        
        
        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //            NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //            policy.allowInvalidCertificates = YES;
        //            BANetManagerShare.sessionManager.securityPolicy = policy;
    }
}

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param isNeedCache  是否需要缓存，只有 get / post 请求有缓存配置
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progressBlock 进度
 */
+ (BAURLSessionTask *)ba_requestWithType:(BAHttpRequestType)type
                             isNeedCache:(BOOL)isNeedCache
                               urlString:(NSString *)urlString
                              parameters:(id)parameters
                            successBlock:(BAResponseSuccessBlock)successBlock
                            failureBlock:(BAResponseFailBlock)failureBlock
                           progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (urlString == nil)
    {
        return nil;
    }
    
    BAWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        case 2:
            requestType = @"PUT";
            break;
        case 3:
            requestType = @"DELETE";
            break;
            
        default:
            break;
    }

    if(![URLString containsString:@"auth/oauth/mobile/token"]) {
        NSString *token = [AppModel shareInstance].userInfo.fullToken; // 后台Token
        if (token.length == 0) {
            NSLog(@"🔴------------------0000000000------------");
            failureBlock(nil);
            return nil;
        }
        [BANetManagerShare.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        NSString *mobile = GetUserDefaultWithKey(@"mobile");
        [BANetManagerShare.sessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    }
//    else {
//        NSLog(@"auth/oauth/token");
//    }
    
    AFHTTPSessionManager *scc = BANetManagerShare.sessionManager;
    AFHTTPResponseSerializer *scc2 = scc.responseSerializer;
    AFHTTPRequestSerializer *scc3 = scc.requestSerializer;
    NSTimeInterval timeoutInterval = BANetManagerShare.timeoutInterval;
    
    NSString *isCache = isNeedCache ? @"开启":@"关闭";
    CGFloat allCacheSize = [BANetManagerCache ba_getAllHttpCacheSize];

    if (BANetManagerShare.isOpenLog)
    {
        NSLog(@"\n******************** 请求参数 ***************************");
        NSLog(@"\n请求头: %@\n超时时间设置：%.1f 秒【默认：30秒】\nAFHTTPResponseSerializer：%@【默认：AFJSONResponseSerializer】\nAFHTTPRequestSerializer：%@【默认：AFJSONRequestSerializer】\n请求方式: %@\n请求URL: %@\n请求param: %@\n是否启用缓存：%@【默认：开启】\n目前总缓存大小：%.6fM\n", BANetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, timeoutInterval, scc2, scc3, requestType, URLString, parameters, isCache, allCacheSize);
        NSLog(@"\n********************************************************");
    }
    
    BAURLSessionTask *sessionTask = nil;
    
    // 读取缓存
    id responseCacheData = [BANetManagerCache ba_httpCacheWithUrlString:urlString parameters:parameters];
    
    if (isNeedCache && responseCacheData != nil)
    {
        if (successBlock)
        {
            successBlock(responseCacheData);
        }
        if (BANetManagerShare.isOpenLog)
        {
            NSLog(@"取用缓存数据结果： *** %@", responseCacheData);
        }
        [[weakSelf tasks] removeObject:sessionTask];
        return nil;
    }
    
    if (BANetManagerShare.isSetQueryStringSerialization)
    {
        [BANetManagerShare.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            
            return parameters;
            
        }];
    }
    
    if (type == BAHttpRequestTypeGet)
    {
        sessionTask = [BANetManagerShare.sessionManager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            // 对数据进行异步缓存
            [BANetManagerCache ba_setHttpCache:responseObject urlString:urlString parameters:parameters];
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == BAHttpRequestTypePost)
    {
        sessionTask = [BANetManagerShare.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            if (BANetManagerShare.isOpenLog)
            {
                NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock)
                {
                    progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                }
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (BANetManagerShare.isOpenLog)
            {
                NSLog(@"post 请求数据结果： *** %@", responseObject);
            }
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            // 对数据进行异步缓存
            [BANetManagerCache ba_setHttpCache:responseObject urlString:urlString parameters:parameters];
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == BAHttpRequestTypePut)
    {
        sessionTask = [BANetManagerShare.sessionManager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == BAHttpRequestTypeDelete)
    {
        sessionTask = [BANetManagerShare.sessionManager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@",error);
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask)
    {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark - 网络请求的类方法 + Entity --- get / post / put / delete

/**
 网络请求的实例方法 get
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度回调
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)ba_request_GETWithEntity:(BADataEntity *)entity
                                  successBlock:(BAResponseSuccessBlock)successBlock
                                  failureBlock:(BAResponseFailBlock)failureBlock
                                 progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (!entity || ![entity isKindOfClass:[BADataEntity class]]) {
        return nil;
    }
    return [self ba_requestWithType:BAHttpRequestTypeGet isNeedCache:entity.isNeedCache urlString:entity.urlString
                         parameters:entity.parameters successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/**
 网络请求的实例方法 post
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)ba_request_POSTWithEntity:(BADataEntity *)entity
                                   successBlock:(BAResponseSuccessBlock)successBlock
                                   failureBlock:(BAResponseFailBlock)failureBlock
                                  progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (!entity || ![entity isKindOfClass:[BADataEntity class]]) {
        return nil;
    }
    
    NSLog(@"=================BAnet 接口地址:%@ ===参数:%@",entity.urlString,[entity.parameters mj_JSONString]);
    NSDictionary* encryDic = @{
                               };
    if (entity.parameters) {
        encryDic = [FunctionManager encryMethod:entity.parameters];
    }
    else{
        NSLog(@"=================BAnet 接口地址:%@ ===参数:nil",entity.urlString);
    }
    return [self ba_requestWithType:BAHttpRequestTypePost isNeedCache:entity.isNeedCache urlString:entity.urlString parameters:encryDic successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/**
 网络请求的实例方法 put
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)ba_request_PUTWithEntity:(BADataEntity *)entity
                                  successBlock:(BAResponseSuccessBlock)successBlock
                                  failureBlock:(BAResponseFailBlock)failureBlock
                                 progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (!entity || ![entity isKindOfClass:[BADataEntity class]]) {
        return nil;
    }
    return [self ba_requestWithType:BAHttpRequestTypePut isNeedCache:NO urlString:entity.urlString parameters:entity.parameters successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/**
 网络请求的实例方法 delete
 
 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)ba_request_DELETEWithEntity:(BADataEntity *)entity
                                     successBlock:(BAResponseSuccessBlock)successBlock
                                     failureBlock:(BAResponseFailBlock)failureBlock
                                    progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (!entity || ![entity isKindOfClass:[BADataEntity class]]) {
        return nil;
    }
    return [self ba_requestWithType:BAHttpRequestTypeDelete isNeedCache:NO urlString:entity.urlString parameters:entity.parameters successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/**
 上传图片(多图)
 
 @param entity 请求信息载体
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progressBlock 上传进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)ba_uploadImageWithEntity:(BADataEntity *)entity
                                  successBlock:(BAResponseSuccessBlock)successBlock
                                   failurBlock:(BAResponseFailBlock)failureBlock
                                 progressBlock:(BAUploadProgressBlock)progressBlock
{
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[BAImageDataEntity class]]) {
        return nil;
    }
    
    BAImageDataEntity *imageEntity = (BAImageDataEntity *)entity;
    
    BAWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:imageEntity.urlString] ? imageEntity.urlString : [self strUTF8Encoding:imageEntity.urlString];

    if (BANetManagerShare.isOpenLog)
    {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",BANetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"POST",URLString, imageEntity.parameters);
        NSLog(@"********************************************************");
    }
    BAURLSessionTask *sessionTask = nil;
    sessionTask = [BANetManagerShare.sessionManager POST:URLString parameters:imageEntity.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*! 出于性能考虑,将上传图片进行压缩 */
        [imageEntity.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /*! image的压缩方法 */
            UIImage *resizedImage;
            /*! 此处是使用原生系统相册 */
            if ([obj isKindOfClass:[PHAsset class]]) {
                PHAsset *asset = (PHAsset *)obj;
                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth , asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (BANetManagerShare.isOpenLog)
                    {
                        NSLog(@" width:%f height:%f",result.size.width,result.size.height);
                    }
                    [self ba_uploadImageWithFormData:formData resizedImage:result imageType:imageEntity.imageType imageScale:imageEntity.imageScale fileNames:imageEntity.fileNames index:idx];
                }];
            } else {
                /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
                [self ba_uploadImageWithFormData:formData resizedImage:resizedImage imageType:imageEntity.imageType imageScale:imageEntity.imageScale fileNames:imageEntity.fileNames index:idx];
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (BANetManagerShare.isOpenLog)
        {
            NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (BANetManagerShare.isOpenLog)
        {
            NSLog(@"上传图片成功 = %@",responseObject);
        }
        if (successBlock) {
            successBlock(responseObject);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息：%@",error);
        if (failureBlock) {
            failureBlock(error);
        }
        [[weakSelf tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

/**
 视频上传
 
 @param entity 请求信息载体
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progressBlock 上传的进度
 */
+ (void)ba_uploadVideoWithEntity:(BADataEntity *)entity
                    successBlock:(BAResponseSuccessBlock)successBlock
                    failureBlock:(BAResponseFailBlock)failureBlock
                   progressBlock:(BAUploadProgressBlock)progressBlock
{
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[BAFileDataEntity class]]) {
        return;
    }
    BAFileDataEntity *fileEntity = (BAFileDataEntity *)entity;
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:fileEntity.filePath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [BANetManagerShare.sessionManager POST:fileEntity.urlString parameters:fileEntity.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (BANetManagerShare.isOpenLog)
                    {
                        NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    }
                    /*! 回到主线程刷新UI */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressBlock)
                        {
                            progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                        }
                    });
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传视频成功 = %@",responseObject);
                    
                    if (successBlock)
                    {
                        successBlock(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传视频失败 = %@", error);
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

/**
 文件下载
 
 @param entity 请求信息载体
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progressBlock 下载文件的进度显示
 @return BAURLSessionTask
 */

+ (BAURLSessionTask *)ba_downLoadFileWithEntity:(BADataEntity *)entity
                                   successBlock:(BAResponseSuccessBlock)successBlock
                                   failureBlock:(BAResponseFailBlock)failureBlock
                                  progressBlock:(BADownloadProgressBlock)progressBlock
{
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[BAFileDataEntity class]]) {
        return nil;
    }
    
    BAFileDataEntity *fileEntity = (BAFileDataEntity *)entity;
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fileEntity.urlString]];
    if (BANetManagerShare.isOpenLog)
    {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",BANetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"download", fileEntity.urlString, fileEntity.parameters);
        NSLog(@"******************************************************");
    }
    
    BAURLSessionTask *sessionTask = nil;
    
    sessionTask = [BANetManagerShare.sessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (BANetManagerShare.isOpenLog)
        {
            NSLog(@"下载进度：%.2lld%%",100 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progressBlock)
            {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!fileEntity.filePath)
        {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            if (BANetManagerShare.isOpenLog)
            {
                NSLog(@"默认路径--%@",downloadURL);
            }
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        else
        {
            return [NSURL fileURLWithPath:fileEntity.filePath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self tasks] removeObject:sessionTask];
        
        NSLog(@"下载文件成功");
        if (error == nil)
        {
            if (successBlock)
            {
                /*! 返回完整路径 */
                successBlock([filePath path]);
            }
        }
        else
        {
            if (failureBlock)
            {
                failureBlock(error);
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

/**
 文件上传
 
 @param entity 请求信息载体
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 @param progressBlock progressBlock description
 @return BAURLSessionTask
 */

+ (BAURLSessionTask *)ba_uploadFileWithWithEntity:(BADataEntity *)entity
                                     successBlock:(BAResponseSuccessBlock)successBlock
                                     failureBlock:(BAResponseFailBlock)failureBlock
                                    progressBlock:(BAUploadProgressBlock)progressBlock
{
    if (!entity || entity.urlString == nil || ![entity isKindOfClass:[BAFileDataEntity class]]) {
        return nil;
    }
    
    BAFileDataEntity *fileEntity = (BAFileDataEntity *)entity;
    if (BANetManagerShare.isOpenLog)
    {
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",BANetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"uploadFile", fileEntity.urlString, fileEntity.parameters);
        NSLog(@"******************************************************");
    }
    BAURLSessionTask *sessionTask = nil;
    sessionTask = [BANetManagerShare.sessionManager POST:fileEntity.urlString parameters:fileEntity.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:fileEntity.filePath] name:fileEntity.fileName error:&error];
        if (failureBlock && error)
        {
            failureBlock(error);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (BANetManagerShare.isOpenLog)
        {
            NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock)
            {
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self tasks] removeObject:sessionTask];
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self tasks] removeObject:sessionTask];
        if (failureBlock)
        {
            failureBlock(error);
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

#pragma mark - 网络状态监测
/*!
 *  开启网络监测
 */
+ (void)ba_startNetWorkMonitoringWithBlock:(BANetworkStatusBlock)networkStatus
{
    /*! 1.获得网络监控的管理者 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*! 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 2.设置网络状态改变后的处理 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*! 当网络状态改变了, 就会调用这个block */
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                networkStatus ? networkStatus(BANetworkStatusUnknown) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                networkStatus ? networkStatus(BANetworkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                networkStatus ? networkStatus(BANetworkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi 网络");
                networkStatus ? networkStatus(BANetworkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ba_cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ba_cancelRequestWithURL:(NSString *)URL
{
    if (!URL)
    {
        return;
    }
    @synchronized (self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL])
            {
                [task cancel];
                [[self tasks] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if (newSize.height > 375/newSize.width*newSize.height)
    {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375)
    {
        newSize.width = 375;
    }
    
    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
    return newImage;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else
    {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

#pragma mark - setter / getter
/**
 存储着所有的请求task数组
 
 @return 存储着所有的请求task数组
 */
+ (NSMutableArray *)tasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    _timeoutInterval = timeoutInterval;
    BANetManagerShare.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setRequestSerializer:(BAHttpRequestSerializer)requestSerializer
{
    _requestSerializer = requestSerializer;
    switch (requestSerializer) {
        case BAHttpRequestSerializerJSON:
        {
            BANetManagerShare.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer] ;
        }
            break;
        case BAHttpRequestSerializerHTTP:
        {
            BANetManagerShare.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
        }
            break;
            
        default:
            break;
    }
}

- (void)setResponseSerializer:(BAHttpResponseSerializer)responseSerializer
{
    _responseSerializer = responseSerializer;
    switch (responseSerializer) {
        case BAHttpResponseSerializerJSON:
        {
            BANetManagerShare.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer] ;
        }
            break;
        case BAHttpResponseSerializerHTTP:
        {
            BANetManagerShare.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
        }
            break;
            
        default:
            break;
    }
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary
{
    _httpHeaderFieldDictionary = httpHeaderFieldDictionary;
    
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    
    if (keyArray.count <= 0)
    {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    
    for (NSInteger i = 0; i < keyArray.count; i ++)
    {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        
        [BANetManager ba_setValue:valueString forHTTPHeaderKey:keyString];
    }
}

/**
 *  自定义请求头
 */
+ (void)ba_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey
{
    [BANetManagerShare.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}


/**
 删除所有请求头
 */
+ (void)ba_clearAuthorizationHeader
{
    [BANetManagerShare.sessionManager.requestSerializer clearAuthorizationHeader];
}

+ (void)ba_uploadImageWithFormData:(id<AFMultipartFormData>  _Nonnull )formData
                      resizedImage:(UIImage *)resizedImage
                         imageType:(NSString *)imageType
                        imageScale:(CGFloat)imageScale
                         fileNames:(NSArray <NSString *> *)fileNames
                             index:(NSUInteger)index
{
    /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
    if (imageScale == 0)
    {
        imageScale = 0.8;
    }
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, imageScale ?: 1.f);
    
    /*! 拼接data */
    if (imageData != nil)
    {   // 图片数据不为空才传递 fileName
        //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
        
        // 默认图片的文件名, 若fileNames为nil就使用
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@",str, index, imageType?:@"jpg"];
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[index],imageType?:@"jpg"] : imageFileName
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"]];
//        NSLog(@"上传图片 %lu 成功", (unsigned long)index);
    }
}

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ba_clearAllHttpCache
{
    [BANetManagerCache ba_clearAllHttpCache];
}

@end

#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建 NSDictionary 与 NSArray 的分类, 控制台打印 json 数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (BANetManager)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (BANetManager)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end

#endif


