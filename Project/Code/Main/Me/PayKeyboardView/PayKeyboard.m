//
//  PayKeyboard.m
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/20.
//  Copyright © 2019 opo. All rights reserved.
//

#define CUSTOM_KEYBOARD_HEIGHT   (KeyboardViewCellW * 2 + bottomBarHeight + passWordViewW + passWordViewSpacing * 2 + 40)           //自定义键盘高度

#import "PayKeyboard.h"
#import "PayKeyboardView.h"
#import <Masonry.h>
@interface PayKeyboard()<PayPassWordViewDelegate>
@property (strong, nonatomic) PayKeyboardView *keyboardView;
@property (nonatomic , weak) id<PayKeyboardDelegate> delegate;
@end
@implementation PayKeyboard

+ (void)showPayKeyboardViewAnimateDelegate:(id<PayKeyboardDelegate>)delegate{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    PayKeyboard *pay = [[PayKeyboard alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pay.delegate = delegate;
    pay.hidden = NO;
    [window addSubview:pay];
    [pay showNumKeyboardViewAnimate];
    
}
- (void)dismiss{
    [self hideNumKeyboardViewWithAnimate];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:bgView];
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapAction:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [bgView addGestureRecognizer:singleRecognizer];
        self.keyboardView = [[PayKeyboardView alloc]init];
        __weak __typeof(self)weakSelf = self;
        self.keyboardView.hideBlock = ^{
            [weakSelf hideNumKeyboardViewWithAnimate];
        };
        self.keyboardView.determineBlock = ^(NSString *key) {
            if ([weakSelf.delegate respondsToSelector:@selector(passWordDetermine:PassWord:)]) {
                [weakSelf.delegate passWordDetermine:weakSelf PassWord:key];
            }
        };
        self.keyboardView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.keyboardView];
        self.keyboardView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
        
    }
    return self;
}

- (void)showNumKeyboardViewAnimate{
    self.keyboardView.passWordView.payDelegate = self;
    [UIView animateWithDuration:0.2 animations:^{
        self.keyboardView.frame = CGRectMake(0, SCREEN_HEIGHT-CUSTOM_KEYBOARD_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
           } completion:^(BOOL finished) {
        
    }];
}
-(void)bgViewTapAction:(UITapGestureRecognizer*)recognizer
{
    [self hideNumKeyboardViewWithAnimate];
}
- (void)hideNumKeyboardViewWithAnimate{
    [UIView animateWithDuration:0.2 animations:^{
        self.keyboardView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        self.keyboardView.passWordView.payDelegate = nil;
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = YES;
    }];
}
#pragma mark - PayPassWordViewDelegate
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(PayPassWordView *)passWord {

    if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
        [self.delegate passWordDidChange:passWord.textStore];
    }
}

/**
 *  监听输入完成时
 */
- (void)passWordCompleteInput:(PayPassWordView *)passWord {
 
    if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:keyboard:)]) {
        [self.delegate passWordCompleteInput:passWord.textStore keyboard:self];
    }
    
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(PayPassWordView *)passWord {

    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.delegate passWordBeginInput:passWord.textStore];
    }
}
@end
