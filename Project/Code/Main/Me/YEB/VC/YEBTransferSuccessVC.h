//
//  YEBTransferSuccessVC.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 转出入成功页面
 */
@class YEBTransferModel;
@interface YEBTransferSuccessVC : BaseVC


+ (instancetype)transferInSuccessVCWithResult:(YEBTransferModel *)model;
+ (instancetype)transferOutSuccessVCWithMoney:(NSString *)money;


@end

NS_ASSUME_NONNULL_END
