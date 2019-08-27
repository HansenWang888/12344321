//
//  CDBaseNet.m
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "CDBaseNet.h"
#import "AFNetworking.h"

@interface CDBaseNet()
@property (nonatomic ,strong) AFHTTPSessionManager *manager;
@end

@implementation CDBaseNet


- (AFHTTPSessionManager *)manager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10.0;
    });
    return manager;
}

+ (CDBaseNet *)normalNet{
    CDBaseNet *net = [[CDBaseNet alloc]init];
    [net updateHTTPHeaderField: [AppModel shareInstance].authKey];
    return net;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
//        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:[AppModel shareInstance].authKey forHTTPHeaderField:@"Authorization"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg", @"image/png",@"text/plain",@"application/octet-stream", nil];
        _manager.requestSerializer.timeoutInterval = 30;
//        _prefix = @"";
    }
    return self;
}

- (void)updateHTTPHeaderField:(NSString *)pValue
{
    [_manager.requestSerializer setValue:pValue forHTTPHeaderField:@"Authorization"];
}

- (void)doGetSuccess:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failue{
    
    NSLog(@"GETUrl:----%@",self.path);
    NSLog(@"json:--%@",[self.param mj_JSONString]);
    
    
    [_manager GET:self.path parameters:self.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failue(error);
    }];
    
    
}

- (void)doPostSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failue{
    NSLog(@"GETUrl:----%@",self.path);
    NSLog(@"json:--%@",[self.param mj_JSONString]);
    [_manager POST:self.path parameters:self.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failue(error);
    }];
}

- (void)upLoadSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failue{
    NSLog(@"GETUrl:----%@",self.path);
    [_manager POST:self.path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.param name:@"file" fileName:@"icon.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failue(error);
    }];
}

@end
