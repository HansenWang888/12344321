//
//  PayKeyboardView.h
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/21.
//  Copyright © 2019 opo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPassWordView.h"
#define statusHeight  UIApplication.sharedApplication.statusBarFrame.size.height
#define bottomBarHeight  ((statusHeight == 20) ? 0 : 34)
#define KeyboardViewCellW (([UIScreen mainScreen].bounds.size.width - 3) / 4)
#define passWordViewW 55 //密码框的高度
#define passWordViewSpacing 30 // 密码框上下间距
typedef void(^hideKeyboardBlock)(void);

typedef void(^determineKeyboardBlock)(NSString *key);
@interface PayKeyboardView : UIView
@property (strong, nonatomic) PayPassWordView *passWordView;
/**
 隐藏键盘
 */
@property (nonatomic, copy) hideKeyboardBlock hideBlock;

/**
 确定
 */
@property (nonatomic, copy) determineKeyboardBlock determineBlock;
@end

@interface PayKeyboardViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) UIImageView *imageV;
@end
