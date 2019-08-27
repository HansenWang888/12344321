//
//  MemberHeadView.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MemberHeadView.h"

@interface MemberHeadView(){
    UIImageView *_headIcon;
    UILabel *_nickName;
    UILabel *_integral;
    UILabel *_account;
    UIView *_sexBackView;
    UIImageView *_sexIcon;
}
@property(nonatomic,strong)UIImageView *coinImageView;

@end

@implementation MemberHeadView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.height.width.equalTo(@(50));
        make.bottom.equalTo(self).offset(-24 - 70);
    }];
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(12);
        make.top.equalTo(self->_headIcon.mas_top).offset(3);
    }];
    
    [_sexBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_nickName.mas_right).offset(6);
        make.centerY.equalTo(self->_nickName);
        make.width.height.equalTo(@(15));
    }];
    
    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->_sexBackView);
    }];
    
    [_integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self->_account);
    }];
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_integral.mas_centerX);
        make.bottom.equalTo(self->_integral.mas_top).offset(40);
    }];
    
    [_account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(12);
        make.top.equalTo(self->_nickName.mas_bottom).offset(6);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _headIcon = [UIImageView new];
    [self addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 5;
    _headIcon.layer.masksToBounds = YES;
    
    _nickName = [UILabel new];
    [self addSubview:_nickName];
    _nickName.font = [UIFont boldSystemFontOfSize2:16];
    _nickName.textColor = [UIColor whiteColor];
    
    _sexBackView = [UIView new];
    [self addSubview:_sexBackView];
    _sexBackView.backgroundColor = SexBack;
    _sexBackView.layer.cornerRadius = 7.5;
    
    _sexIcon = [UIImageView new];
    [_sexBackView addSubview:_sexIcon];
    
    _integral = [UILabel new];
    [self addSubview:_integral];
    _integral.font = [UIFont systemFontOfSize2:14];
    _integral.textColor = [UIColor whiteColor];
    _integral.textAlignment = NSTextAlignmentRight;

    self.coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"integral"]];
    [self addSubview:self.coinImageView];
    
    _account = [UILabel new];
    [self addSubview:_account];
    _account.font = [UIFont systemFontOfSize2:14];
    _account.textColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@70);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =  TBSeparaColor;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.height.equalTo(@35);
        make.centerY.equalTo(bgView);
        make.left.mas_equalTo(SCREEN_WIDTH / 3);
    }];
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor =  TBSeparaColor;
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.height.equalTo(@35);
        make.left.mas_equalTo(SCREEN_WIDTH / 3 * 2);
        make.centerY.equalTo(bgView);
    }];
    UIButton *btn2 = [self createBtnWithIcon:@"my-bzzx" title:@"代理中心"];
    [bgView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bgView);
        make.right.equalTo(line);
    }];
    self.zhangDanBtn = btn2;
    UIButton *btn3 = [self createBtnWithIcon:@"pay_yuebao_icon" title:@"余额宝"];
    [bgView addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bgView);
        make.left.mas_equalTo(line.mas_right);
        make.right.mas_equalTo(line1.mas_left);
    }];
    self.yuEBaoBtn = btn3;
    UIButton *btn1 = [self createBtnWithIcon:@"make-money" title:@"分享赚钱"];
    [bgView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(bgView);
        make.left.equalTo(line1);
    }];
    self.zuanQianBtn = btn1;
    
    line = [[UIView alloc] init];
    line.backgroundColor =  TBSeparaColor;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(bgView);
    }];
}

- (void)update{
    UserInfo *user = [AppModel shareInstance].userInfo;
    _nickName.text = user.nick;
    _integral.text = (user.balance)?[NSString stringWithFormat:@"余额：%@元",user.balance]:@"余额：0.00元";
    _account.text = [NSString stringWithFormat:@"账号：%@",user.userId];
    [_headIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:user.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    _sexIcon.image = (user.gender == 1)?[UIImage imageNamed:@"female"]:[UIImage imageNamed:@"male"];
}

-(UIButton *)createBtnWithIcon:(NSString *)icon title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [btn addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn).offset(-12);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize2:15];
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn).offset(18);
    }];
    label.text = title;
    return btn;
}
@end
