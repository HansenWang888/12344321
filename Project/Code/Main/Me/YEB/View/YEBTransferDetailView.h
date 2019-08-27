//
//  YEBTransferDetailView.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "DYTableView.h"
#import "YEBTransferDetailHeaderView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 资金明细
 */
@class YEBAccountInfoModel;
@interface YEBTransferDetailView : DYTableView
@property (nonatomic, weak) YEBAccountInfoModel *model;

@property (nonatomic, weak) YEBTransferDetailHeaderView *headerView;

///**
// * type : 1：转入 2：转出 3：收益
// */
//- (void)loadDataWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
