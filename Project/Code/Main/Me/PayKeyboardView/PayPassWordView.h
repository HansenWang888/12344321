//
//  PayPassWordView.h
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/20.
//  Copyright © 2019 opo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayPassWordView;

@protocol  PayPassWordViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(PayPassWordView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(PayPassWordView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(PayPassWordView *)passWord;


@end

@interface PayPassWordView : UITextField
/**
 密码的位数,初始6位
 */
@property (assign, nonatomic) NSUInteger passWordNum;

/**
 正方形的大小,初始45
 */
@property (assign, nonatomic) CGFloat squareWidth;

/**
 黑点的半径,初始6
 */
@property (assign, nonatomic) CGFloat pointRadius;

/**
 黑点的颜色,初始黑色
 */
@property (strong, nonatomic) UIColor *pointColor;

/**
 边框的颜色,初始黑色
 */
@property (strong, nonatomic) UIColor *rectColor;

/**
 代理
 */
@property (weak, nonatomic) id<PayPassWordViewDelegate> payDelegate;

/**
 保存密码的字符串
 */
@property (strong, nonatomic, readonly) NSMutableString *textStore;

@end

