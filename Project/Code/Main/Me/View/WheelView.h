//
//  WheelView.h
//  Project
//
//  Created by fangyuan on 2019/2/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WheelView : UIView
@property(nonatomic,strong)UIImageView *containView;//转盘
@property(nonatomic,strong)UIImageView *needleView;//转针
@property(nonatomic,strong)UIButton *button;//开始抽奖
@property(nonatomic,assign)NSInteger targetIndex;//目标块数
@property(nonatomic,assign)NSInteger total;//总的几块
@property(nonatomic,copy)CallbackBlock scrollFinishBlock;
-(void)loadingScroll;
-(void)startScroll;
@end

NS_ASSUME_NONNULL_END
