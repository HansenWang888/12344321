//
//  RecommendNet.h
//  Project
//
//  Created by mini on 2018/8/2.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendNet : NSObject

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选

@property (nonatomic ,assign) BOOL isEmpty;///<空
@property (nonatomic ,assign) BOOL isMost;///<没有更多
@property (nonatomic ,assign) BOOL IsNetError;///<没有更多

@property(nonatomic,strong)NSString *userString;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSDictionary *commonInfo;

- (void)getPlayerWithPage:(NSInteger)page success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failue;

- (void)requestCommonInfoWithSuccess:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *))failue;
@end
