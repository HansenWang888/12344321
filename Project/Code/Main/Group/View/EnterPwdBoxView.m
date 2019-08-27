//
//  EnterPwdBoxView.m
//  Project
//
//  Created by Mike on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "EnterPwdBoxView.h"

@interface EnterPwdBoxView()<CAAnimationDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIImageView *contentImageView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *backImageView;

@property (nonatomic,strong) UITextField *textField;
@end

@implementation EnterPwdBoxView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


#pragma mark - subView
- (void)initSubviews {
    
    _backControl = [[UIControl alloc]initWithFrame:self.bounds];
    [self addSubview:_backControl];
    _backControl.backgroundColor = ApHexColor(@"#000000", 0.6);
    [_backControl addTarget:self action:@selector(onbackControl) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginWidth = CD_WidthScal(35, 375);
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = 213;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth, y, w, h)];
    contentImageView.backgroundColor = [UIColor clearColor];
    contentImageView.image = [UIImage imageNamed:@"gp_addgroup_backview"];
    contentImageView.userInteractionEnabled = YES;
    _contentImageView = contentImageView;
    [self addSubview:contentImageView];
    
    
    UIView *passwordBackView = [[UIView alloc] init];
    passwordBackView.backgroundColor = [UIColor colorWithRed:0.902 green:0.855 blue:0.725 alpha:1.000];
    passwordBackView.layer.cornerRadius = 5;
    passwordBackView.layer.masksToBounds = YES;
    [contentImageView addSubview:passwordBackView];
    
    [passwordBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentImageView.mas_left).offset(CD_WidthScal(50, 375));
        make.right.mas_equalTo(contentImageView.mas_right).offset(-CD_WidthScal(40, 375));
        make.centerY.mas_equalTo(contentImageView.mas_centerY);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *password_iconView = [[UIImageView alloc] init];
    password_iconView.image = [UIImage imageNamed:@"gp_password_icon"];
    [passwordBackView addSubview:password_iconView];
    
    [password_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordBackView.mas_left).offset(12);
        make.centerY.mas_equalTo(passwordBackView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 16));
    }];
    
    UIView *backLineView = [[UIView alloc] init];
    backLineView.backgroundColor = [UIColor colorWithRed:0.835 green:0.655 blue:0.443 alpha:1.000];
    [passwordBackView addSubview:backLineView];
    
    [backLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(password_iconView.mas_right).offset(12);
        make.centerY.mas_equalTo(passwordBackView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1,15));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont boldSystemFontOfSize:15.0];
    textField.placeholder = @"请输入密码";
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.keyboardType = UIKeyboardTypeDefault;
    //    textField.returnKeyType = UIReturnKeyGo;
    textField.textColor = [UIColor colorWithRed:0.835 green:0.655 blue:0.443 alpha:1.000];
    [passwordBackView addSubview:textField];
    _textField = textField;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backLineView.mas_right).offset(12);
        make.right.mas_equalTo(passwordBackView.mas_right);
        make.centerY.mas_equalTo(passwordBackView.mas_centerY);
        make.height.mas_equalTo(@(40));
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(didClickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    //    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"cs_close"] forState:UIControlStateNormal];
    [contentImageView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentImageView.mas_top).offset(3);
        make.centerX.equalTo(contentImageView.mas_right).offset(-3);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    
    UIButton *joinGroupBtn = [[UIButton alloc] init];
    [joinGroupBtn setBackgroundImage:[UIImage imageNamed:@"gp_join_group_btn"] forState:UIControlStateNormal];
    [joinGroupBtn addTarget:self action:@selector(on_joinGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentImageView addSubview:joinGroupBtn];
    
    [joinGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(contentImageView.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(10);
        make.size.mas_equalTo(CGSizeMake(96, 33));
    }];
    
}

- (void)on_joinGroupBtn {
    if (self.joinGroupBtnBlock) {
        self.joinGroupBtnBlock(self.textField.text);
    }
    //    [self disMissView];
}

- (void)didClickCloseBtn {
    [self disMissView];
}

- (void)showInView:(UIView *)view{
    if (self == nil) {
        return;
    }
    _contentImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    _contentImageView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _backControl.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self->_contentImageView.transform = CGAffineTransformMakeScale(1, 1);
        self->_backControl.alpha = 0.6;
        self->_contentImageView.alpha = 1.0;
        
    } completion:nil];
    
}


- (void)disMissView {
    
    if (self.disMissViewBlock) {
        self.disMissViewBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self->_contentImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self->_contentImageView.alpha = 0.0;
        self->_backControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (void)onbackControl {
    [self disMissView];
}


//点击输入框界面跟随键盘上移
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat marginWidth = CD_WidthScal(35, 375);
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = 213;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    
    CGFloat keyboard = 258 + 45;
    CGFloat lowestHeight = SCREEN_HEIGHT -(h+keyboard);
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.5f];
    if ((y - lowestHeight) > 0) {
        self.contentImageView.frame = CGRectMake(marginWidth, lowestHeight, w, h);
        [UIView commitAnimations];
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGFloat marginWidth = CD_WidthScal(35, 375);
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = 213;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    self.contentImageView.frame = CGRectMake(marginWidth, y, w, h);
}




@end


