//
//  TypeView.h
//  Project
//
//  Created by fangyuan on 2019/5/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TypeView : UIView
@property(nonatomic,copy)CallbackBlock selectBlock;
- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray;
@end

NS_ASSUME_NONNULL_END
