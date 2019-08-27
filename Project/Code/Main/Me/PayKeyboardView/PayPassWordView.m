//
//  PayPassWordView.m
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/20.
//  Copyright © 2019 opo. All rights reserved.
//

#import "PayPassWordView.h"
#import "PayKeyboard.h"
@interface PayPassWordView()

/**
保存密码的字符串
 */
@property (strong, nonatomic) NSMutableString *textStore;
@end

@implementation PayPassWordView

static NSString  * const MONEYNUMBERS = @"0123456789";

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.textStore = [NSMutableString string];
        self.squareWidth = 45;
        self.passWordNum = 6;
        self.pointRadius = 6;
        self.rectColor = UIColor.blackColor;
        self.pointColor = UIColor.blackColor;;
        [self becomeFirstResponder];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = self.rectColor.CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textStore = [NSMutableString string];
        
        self.squareWidth = 45;
        self.passWordNum = 6;
        self.pointRadius = 6;
        self.rectColor = UIColor.blackColor;
        self.pointColor = UIColor.blackColor;
        self.tintColor = UIColor.clearColor;
        [self becomeFirstResponder];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = self.rectColor.CGColor;
        self.layer.borderWidth = 1;
        
    }
    return self;
}
- (void)setRectColor:(UIColor *)rectColor{
    _rectColor = rectColor;
    self.layer.borderColor = _rectColor.CGColor;
    [self setNeedsDisplay];
}

/**
 *  设置正方形的边长
 */
- (void)setSquareWidth:(CGFloat)squareWidth {
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}

- (UIView *)inputView{
    return [PayKeyboard new];
}
/**
 *  设置密码的位数
 */
- (void)setPassWordNum:(NSUInteger)passWordNum {
    _passWordNum = passWordNum;
    [self setNeedsDisplay];
}

- (BOOL)becomeFirstResponder {
    if ([self.payDelegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.payDelegate passWordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}
/**
 *  是否能成为第一响应者
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark - UIKeyInput
/**
 *  用于显示的文本对象是否有任何文本
 */
- (BOOL)hasText {
    return self.textStore.length > 0;
}

/**
 *  插入文本
 */
- (void)insertText:(NSString *)text {
    
    if (self.textStore.length < self.passWordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.textStore appendString:text];
            if ([self.payDelegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.payDelegate passWordDidChange:self];
            }
            if (self.textStore.length == self.passWordNum) {
                if ([self.payDelegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self.payDelegate passWordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/**
 *  删除文本
 */
- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.payDelegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.payDelegate passWordDidChange:self];
        }
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat x = (width - self.squareWidth*self.passWordNum)/2.0;
    CGFloat y = (height - self.squareWidth)/2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    CGContextAddRect(context, CGRectMake( x, y, self.squareWidth*self.passWordNum, self.squareWidth));
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //画竖条
    for (int i = 1; i <= self.passWordNum; i++) {
        CGContextMoveToPoint(context, x+i*self.squareWidth, y);
        CGContextAddLineToPoint(context, x+i*self.squareWidth, y+self.squareWidth);
        CGContextClosePath(context);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    //画黑点
    for (int i = 1; i <= self.textStore.length; i++) {
        CGContextAddArc(context,  x+i*self.squareWidth - self.squareWidth/2.0, y+self.squareWidth/2, self.pointRadius, 0, M_PI*2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}


@end
