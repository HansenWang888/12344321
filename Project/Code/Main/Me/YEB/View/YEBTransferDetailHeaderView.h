//
//  YEBTransferDetailHeaderView.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface YEBTransferDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

+ (instancetype)headerView;
@end

NS_ASSUME_NONNULL_END
