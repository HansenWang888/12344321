//
//  YEBInfoVC.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 资金明细 和 收益详情
 */
@class YEBAccountInfoModel;
@interface YEBInfoVC : BaseVC
@property (nonatomic, weak) YEBAccountInfoModel *model;

+ (instancetype)finalcialInfoVC:(YEBAccountInfoModel *)model;
+ (instancetype)profitInfoVC:(YEBAccountInfoModel *)model;


@end

NS_ASSUME_NONNULL_END
