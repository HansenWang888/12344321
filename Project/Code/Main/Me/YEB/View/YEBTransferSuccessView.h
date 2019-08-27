//
//  YEBTransferSuccessView.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YEBTransferSuccessView : UIView
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)successView;
@end

NS_ASSUME_NONNULL_END
