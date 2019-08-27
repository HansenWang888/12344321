//
//  WNBaseNetwork.h
//  项目常用设定
//
//  Created by Hansen on 2018/11/8.
//  Copyright © 2018 ma c. All rights reserved.
//

#import "YTKRequest.h"
#import "DYNetworkError.h"
#import "DYNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYBaseNetwork : YTKRequest
///域名
@property (nonatomic, copy) NSString *dy_baseURL;
///相对路径
@property (nonatomic, copy) NSString *dy_requestUrl;
///请求参数
@property (nonatomic, copy) id dy_requestArgument;
///请求方式
@property (nonatomic, assign) YTKRequestMethod dy_requestMethod;
///缓存时间 默认不缓存 单位：秒
@property (nonatomic, assign) NSUInteger dy_cacheTimeInSeconds;
///验证返回数据
@property (nonatomic, copy) NSDictionary *dy_jsonValidator;
///超时时间 默认60s
@property (nonatomic, assign) NSTimeInterval dy_requestTimeout;
///请求参数的解析方式 默认json
@property (nonatomic, assign) YTKRequestSerializerType dy_requestSerializerType;
///回参的返回方式 默认json
@property (nonatomic, assign) YTKResponseSerializerType dy_responseSerializerType;
/**请求头*/
@property (nonatomic, copy) NSDictionary *dy_requestHeaderFieldValueDictionary;
/**上传文件s使用*/
@property (nonatomic,copy) AFConstructingBlock dy_constructingBodyBlock;


/*
 *统一调用 对返回进行统一处理 外部处理业务错误
 *
 *@param response 返回数据 已经是从字典中取出的data
 *@param error 错误信息
 */
- (void)dy_startRequestWithFinished:(void(^)(__nullable id  responseObject, DYNetworkError * _Nullable error))finished;

/*
 *统一调用 对返回进行统一处理 外部处理业务错误和网络错误
 *
 *@param response 返回数据 已经是从字典中取出的data
 *@param error1 业务错误信息
 *@param error2 接口错误信息
 */
- (void)dy_startRequestWithSuccessful:(void(^)(__nullable id  responseObject,DYNetworkError * _Nullable error))successful failing:(void(^)(DYNetworkError * _Nullable error))failing;

/*
*只返回成功的回调，出现错误会弹出提示
*
*@param response 返回数据 已经是从字典中取出的data
*/
- (void)dy_startRequestWithSuccessful:(void(^)(__nullable id  responseObject))successful;

///统一调用 无处理
- (void)dy_startRequestWithCompleted:(void (^)(YTKBaseRequest *request))Completed;


- (BOOL)isAvailableNetwork;
@end






NS_ASSUME_NONNULL_END
