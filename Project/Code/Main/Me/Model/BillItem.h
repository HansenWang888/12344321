//
//  BillItem.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillItem : NSObject

@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,copy) NSString *createTime; ///<int(10) DEFAULT '0',
@property (nonatomic ,assign) NSInteger isFree; ///<int(1) DEFAULT '0' COMMENT '特殊：0-常规 1-免死 2-平台奖励',
@property (nonatomic ,strong) NSString *bId;///<int(11) NOT NULL AUTO_INCREMENT,
@property (nonatomic ,assign) NSInteger type; ///
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *money;
@property (nonatomic ,strong) NSString *intro;

@end
