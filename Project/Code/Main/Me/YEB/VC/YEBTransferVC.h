//
//  YEBTransferInVC.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 余额宝转入转出
 */
@class YEBAccountInfoModel;
@interface YEBTransferVC : BaseVC
@property (nonatomic, weak) YEBAccountInfoModel *model;


+ (instancetype)transferInVC;
+ (instancetype)transferOutVC;

@end

NS_ASSUME_NONNULL_END
