//
//  DepositOrderController.h
//  ProjectXZHB
//
//  Created by Mike on 2019/3/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ViewCell : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,copy)CallbackBlock copyBlock;
@end

@interface DepositOrderController : SuperViewController
@property(nonatomic,strong)RechargeDetailListItem *infoDic;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *remark;
@end

NS_ASSUME_NONNULL_END
