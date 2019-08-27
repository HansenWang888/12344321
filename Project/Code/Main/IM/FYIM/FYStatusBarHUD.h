//
//  FYStatusBarHUD.h
//  Project
//
//  Created by Mike on 2019/5/26.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYStatusBarHUD : NSObject

+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
+ (void)showMessage:(NSString *)msg;
+ (void)showSuccess:(NSString *)msg;
+ (void)showError:(NSString *)msg;
+ (void)showLoading:(NSString *)msg;
+ (void)hide;

@end
