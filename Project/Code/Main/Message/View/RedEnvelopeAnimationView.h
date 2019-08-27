//
//  EnvelopAnimationView.h
//  Project
//
//  Created by mini on 2018/8/13.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnimationBlock)(void);
typedef void (^DetailBlock)(void);
typedef void (^OpenBtnBlock)(void);
typedef void (^AnimationEndBlock)(void);
typedef void (^DisMissRedBlock)(void);

@interface RedEnvelopeAnimationView : UIView

- (void)updateView:(id)obj response:(id)response rpOverdueTime:(NSString *)rpOverdueTime;
- (void)showInView:(UIView *)view;
@property (nonatomic ,copy) AnimationBlock animationBlock;
@property (nonatomic ,copy) DetailBlock detailBlock;
@property (nonatomic ,copy) OpenBtnBlock openBtnBlock;
@property (nonatomic ,copy) AnimationEndBlock animationEndBlock;
@property (nonatomic ,copy) DisMissRedBlock disMissRedBlock;

@property (nonatomic,assign) BOOL isClickedDisappear;

-(void)disMissRedView;

@end
