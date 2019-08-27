//
//  NotifMessageNet.h
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifMessageNet : NSObject

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选


@end
