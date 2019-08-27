//
//  PayKeyboard.h
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/20.
//  Copyright © 2019 opo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayKeyboard;
@protocol  PayKeyboardDelegate<NSObject>
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(NSString *)passWord;

/**
 *  监听输入的完成
 */
- (void)passWordCompleteInput:(NSString *)passWord keyboard:(PayKeyboard *)keyboard;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(NSString *)passWord;
/**
 *  监听确认按钮
 */
- (void)passWordDetermine:(PayKeyboard *)keyboard PassWord:(NSString *)passWord;
@end
@interface PayKeyboard : UIView

+ (void)showPayKeyboardViewAnimateDelegate:(id <PayKeyboardDelegate>)delegate;
- (void)dismiss;
@end


