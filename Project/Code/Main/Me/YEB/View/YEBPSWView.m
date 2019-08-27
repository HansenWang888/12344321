//
//  YEBPWDView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/8/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBPSWView.h"
#import <IQKeyboardManager.h>
@interface PasswordEditView : UIView
@property (nonatomic, copy) void(^finishedEdit)(NSString *psw);

- (NSString *)getPsw;
- (void)showKeybord;
- (void)dismiss;
@end


@interface YEBPSWView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) PasswordEditView *pswView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, copy) void (^completed)(NSString * _Nonnull);
@property (nonatomic, strong) UIButton *forgotBtn;

@end


@implementation YEBPSWView

+ (instancetype)pswView {
    
    YEBPSWView *view = [YEBPSWView new];
    [view setupSubView];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupSubView{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    self.titleLabel = [UILabel new];
    self.pswView = [PasswordEditView new];
    self.forgotBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forgotBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    self.forgotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.forgotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.forgotBtn addTarget:self action:@selector(forgotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.forgotBtn.hidden = YES;
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.pswView];
    [contentView addSubview:self.forgotBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(88);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(8);
    }];
    [self.pswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.offset(40);
    }];
    
    [self.forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-5);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];

    kWeakly(self);
    self.pswView.finishedEdit = ^(NSString *psw) {
        weakself.completed(psw);
        [weakself dismiss];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)showForgotPSW {
    self.forgotBtn.hidden = NO;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(110);
    }];
}

- (void)forgotBtnClick {
    [self dismiss];
    if (self.forgotBtnClickCallback) {
        self.forgotBtnClickCallback();
    }
    
}

- (void)keyboradWillShow:(NSNotification *)info {
    CGFloat height =  [info.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGFloat animation = [info.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:animation animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
    
}
- (void)keyboradWillHide:(NSNotification *)info {
    
    CGFloat animation = [info.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:animation animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.completed = nil;
        [self removeFromSuperview];
        IQKeyboardManager.sharedManager.enable = YES;
    }];
}


+ (instancetype)showView:(NSString *)title completed:(void (^)(NSString * _Nonnull))completed {
    
    IQKeyboardManager.sharedManager.enable = NO;
    YEBPSWView *view = [YEBPSWView pswView];
    view.titleLabel.text = title;
    [UIApplication.sharedApplication.keyWindow addSubview:view];
    [view.pswView showKeybord];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    view.completed = completed;
    return view;
}
- (void)dismiss {
    IQKeyboardManager.sharedManager.enable = YES;
    [self.pswView dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.completed = nil;
        [self removeFromSuperview];
    });
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@interface PasswordEditView ()
@property (nonatomic, strong) UITextField *pswTF;


@end
@implementation PasswordEditView

#pragma mark - 设置UI
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.pswTF];
    
    //添加6个label
    for (int i = 0; i < 6; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*self.frame.size.width/6.0, 0, self.frame.size.width/6.0, self.frame.size.height)];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.tag = 100 + i;
        label.font = [UIFont boldSystemFontOfSize:25];
        
        [self addSubview:label];
    }
    
    //设置边框圆角与颜色
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeybord)];
    
    [self addGestureRecognizer:tap];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.subviews.count == 0) {
        [self initUI];
    }
    
}
- (void)showKeybord {
    [self.pswTF becomeFirstResponder];
}
- (void)dismiss {
    [self.pswTF endEditing:YES];
}
- (void)valueChange:(UITextField *)textField{
    NSString *text = textField.text;
    
    if (text.length <= 6){    //当输入小于6的时候
        for (int i = 0; i < 6; i++) {
            //通过tag获取label
            UILabel *label = (UILabel *)[self viewWithTag:100 + i];
            
            //更改label值
            if (i < text.length) {
                label.text = @"*";
            }
            else{
                label.text = @"";
            }
        }
    }
    else{ //输入值长度大于6时，截取字符串
        textField.text = [text substringWithRange:NSMakeRange(0, 6)];
    }
    DYLog(@"%@",textField.text);

    if (text.length == 6) {
        self.finishedEdit(text);
    }
}

//划线
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    
    //设置分割线颜色
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    
    CGContextBeginPath(context);
    
    //5条分割线绘制
    for (int i = 0; i < 5;  i++){
        CGContextMoveToPoint(context, self.frame.size.width/6.0 * (i + 1), 0);
        CGContextAddLineToPoint(context,self.frame.size.width/6.0 * (i + 1) , self.frame.size.height);
    }
    
    CGContextStrokePath(context);
    
}
- (NSString *)getPsw{
    return self.pswTF.text;
}
- (UITextField *)pswTF{
    if (!_pswTF) {
        _pswTF = [[UITextField alloc] init];
                
        _pswTF.keyboardType = UIKeyboardTypeNumberPad;
        
        //添加对输入值的监视
        [_pswTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _pswTF;
}
@end
