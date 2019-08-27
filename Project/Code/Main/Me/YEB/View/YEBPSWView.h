//
//  YEBPWDView.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/8/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YEBPSWView : UIView
@property (nonatomic, copy) void(^forgotBtnClickCallback)(void);


+ (instancetype)pswView;

+ (instancetype)showView:(NSString *)title completed:(void(^)(NSString *pwd))completed;

- (void)showForgotPSW;
@end

NS_ASSUME_NONNULL_END
