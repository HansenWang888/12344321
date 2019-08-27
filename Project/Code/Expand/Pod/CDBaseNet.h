//
//  CDBaseNet.h
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDBaseNet : NSObject

@property (nonatomic ,copy) NSString *path;
@property (nonatomic ,copy) NSString *method;
@property (nonatomic ,strong) id param;
@property (nonatomic ,assign) BOOL isLine;

+ (CDBaseNet *)normalNet;

- (void)updateHTTPHeaderField:(NSString *)pValue;

- (void)doGetSuccess:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failue;

- (void)doPostSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failue;

- (void)upLoadSuccess:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failue;

@end
