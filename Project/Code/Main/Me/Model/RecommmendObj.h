//
//  RecommmendObj.h
//  Project
//
//  Created by mini on 2018/8/2.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommmendObj : NSObject

@property (nonatomic ,copy) NSString *avatar;

@property (nonatomic ,assign) NSInteger gender;
@property (nonatomic ,assign) NSInteger daili_num;
@property (nonatomic ,assign) NSInteger player_num;
@property (nonatomic ,copy) NSString *nick;
@property (nonatomic ,copy) NSString *rate;
@property (nonatomic ,copy) NSString *yonjin;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *profitCommission;
@property (nonatomic ,copy) NSString *childAgentCount;
@property (nonatomic ,copy) NSString *childPlayerCount;

@end
