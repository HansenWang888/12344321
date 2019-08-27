//
//  BillNet.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillNet : NSObject

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NSString *billName;
@property (nonatomic ,strong) NSString *categoryStr;


@property (nonatomic ,copy) NSString *beginTime;
@property (nonatomic ,strong) NSString *endTime;

@property (nonatomic ,assign) BOOL isEmpty;///<空
@property (nonatomic ,assign) BOOL isMost;///<没有更多


- (void)getBillListWithPage:(NSInteger)page
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *))failue;

@end
