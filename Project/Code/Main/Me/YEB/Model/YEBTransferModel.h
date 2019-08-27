//
//  YEBTransferModel.h
//  Project
//
//  Created by fangyuan on 2019/8/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 转入 结果模型
 */
@interface YEBTransferModel : NSObject
/**999933.98*/
@property (nonatomic, copy) NSNumber *beginTime;

/**100*/
@property (nonatomic, copy) NSString *createTime;

/**10000000*/
@property (nonatomic, copy) NSString *endTime;

/**10000000*/
@property (nonatomic, copy) NSDecimalNumber *money;
@end

NS_ASSUME_NONNULL_END
