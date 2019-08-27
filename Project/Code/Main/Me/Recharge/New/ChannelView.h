//
//  ChannelView.h
//  Project
//
//  Created by fangyuan on 2019/5/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RechargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChannelView : UIView
@property(nonatomic,copy)CallbackBlock selectBlock;
@property(nonatomic,strong)NSArray *channelArray;
@property(nonatomic,assign)RechargeType rechargeType;

@end

NS_ASSUME_NONNULL_END
