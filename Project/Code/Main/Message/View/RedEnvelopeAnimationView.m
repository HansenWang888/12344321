//
//  EnvelopAnimationView.m
//  Project
//
//  Created by mini on 2018/8/13.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RedEnvelopeAnimationView.h"
#import "EnvelopBackImg.h"


@interface RedEnvelopeAnimationView()<CAAnimationDelegate>

@property (nonatomic,strong) EnvelopBackImg *redView;
@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIImageView *headIcon;
@property (nonatomic,strong) UIButton *openBtn;
@property (nonatomic,strong) UILabel *redDescLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *detailButton;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *small_iconImageView;

@end

@implementation RedEnvelopeAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initLayout];
        [self initSubviews];
    }
    return self;
}

#pragma mark - Data
- (void)initData {
    
}


#pragma mark - Layout
- (void)initLayout {
    
}

#pragma mark - subView
- (void)initSubviews {
    
    _backControl = [[UIControl alloc]initWithFrame:self.bounds];
    [self addSubview:_backControl];
    _backControl.backgroundColor = ApHexColor(@"#000000", 0.6);
    [_backControl addTarget:self action:@selector(onbackControl) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginWidth = 30;
    
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = (SCREEN_WIDTH-marginWidth)/0.8125;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    _redView = [[EnvelopBackImg alloc]initWithFrame:CGRectMake(marginWidth, y, w, h)];
    [self addSubview:_redView];
    //    _redView.backgroundColor = HexColor(@"#C5513F");
    _redView.backgroundColor = [UIColor colorWithRed:0.808 green:0.325 blue:0.235 alpha:1.000];
    _redView.layer.cornerRadius = 8;
    _redView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionView:)];
    [_redView addGestureRecognizer:tapGesturRecognizer];
    
    
    
    CGFloat openWidth = 100;
    _openBtn = [[UIButton alloc]initWithFrame:CGRectMake(w/2-openWidth/2, h*0.665-openWidth/2, openWidth, openWidth)];
    [_redView addSubview:_openBtn];
//    _openBtn.layer.cornerRadius = openWidth/2;
//    _openBtn.layer.masksToBounds = YES;
//    _openBtn.backgroundColor = HexColor(@"#FFE6A2");
//    [_openBtn setTitle:@"開" forState:UIControlStateNormal];
    [_openBtn setBackgroundImage:[UIImage imageNamed:@"mess_open"] forState:UIControlStateNormal];
//    [_openBtn setTitleColor:HexColor(@"#4D4D4D") forState:UIControlStateNormal];
    _openBtn.titleLabel.font = [UIFont systemFontOfSize2:openWidth/2];
    [_openBtn addTarget:self action:@selector(openRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    
    _headIcon = [UIImageView new];
    [_redView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 5;
    _headIcon.layer.masksToBounds = YES;
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_redView);
        make.top.equalTo(self->_redView.mas_top).offset(CD_Scal(35, 667));
        make.width.height.equalTo(@(CD_Scal(45, 667)));
    }];
    
    _nameLabel = [UILabel new];
    [_redView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize2:16];
    _nameLabel.textColor = HexColor(@"#FFE6A2");
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self -> _headIcon.mas_bottom).offset(CD_Scal(7, 667));
        make.centerX.equalTo(self -> _redView);
    }];
    
    _redDescLabel = [UILabel new];
    [_redView addSubview:_redDescLabel];
    _redDescLabel.numberOfLines = 0;
    _redDescLabel.font = [UIFont systemFontOfSize2:14];
    _redDescLabel.textAlignment = NSTextAlignmentCenter;
    _redDescLabel.textColor = HexColor(@"#FFE6A2");
    [_redDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_redView);
        make.top.equalTo(self->_nameLabel.mas_bottom).offset(CD_Scal(2, 667));
    }];
    
    _contentLabel = [UILabel new];
    [_redView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 2;
    _contentLabel.font = [UIFont systemFontOfSize2:18];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = HexColor(@"#FFE6A2");
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_redView.mas_left).offset(10);
        make.right.equalTo(self->_redView.mas_right).offset(-10);
        make.centerX.equalTo(self->_redView);
        make.top.equalTo(self->_redDescLabel.mas_bottom).offset(CD_Scal(15, 667));
    }];
    
    
    _detailButton = [UIButton new];
    [_redView addSubview:_detailButton];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize2:14];
    [_detailButton addTarget:self action:@selector(actionDetail) forControlEvents:UIControlEventTouchUpInside];
    [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailButton setTitleColor:HexColor(@"#FFE6A2") forState:UIControlStateNormal];//:@"查看详情"
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->_redView.mas_bottom);
        make.centerX.equalTo(self->_redView);
        make.height.equalTo(@44);
    }];
    
    UIImageView *imageCCView = [[UIImageView alloc] init];
    imageCCView.image = [UIImage imageNamed:@"mess_redp_cc"];
    [_redView addSubview:imageCCView];
    _small_iconImageView = imageCCView;
    
    [imageCCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->_redView.mas_bottom).offset(-11);
        make.centerX.equalTo(self->_redView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    _closeButton = [UIButton new];
    [_redView addSubview:_closeButton];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize2:14];
    [_closeButton addTarget:self action:@selector(actionCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"mess_close"] forState:UIControlStateNormal];
    [_closeButton setTitleColor:HexColor(@"#FFE6A2") forState:UIControlStateNormal];
    _closeButton.alpha = 0.3;
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self->_redView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];    
}

- (void)actionCloseButton {
    [self disMissRedView];
}

-(void)tapActionView:(UITapGestureRecognizer *)tap {
    if (self.isClickedDisappear) {
        [self disMissRedView];
    }
}





- (void)animation {
//    [_openBtn setTitle:nil forState:UIControlStateNormal];
    [_openBtn setBackgroundImage:[UIImage imageNamed:@"mees_money_icon"] forState:UIControlStateNormal];
    [_openBtn.layer addAnimation:[self confirmViewRotateInfo] forKey:@"transform"];
}

- (void)remoAnimation {
    [_openBtn.layer removeAllAnimations];
    [self disMissRedView];
    if (self.animationBlock) {
        self.animationBlock();
    }
}

- (void)actionDetail {
    [self disMissRedView];
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)openRedPacketAction {
    [self animation];
    if (self.openBtnBlock) {
        self.openBtnBlock();
    }
}

- (void)showInView:(UIView *)view{
    if (self == nil) {
        return;
    }
    _redView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    _redView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _backControl.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self->_redView.transform = CGAffineTransformMakeScale(1, 1);
        self->_backControl.alpha = 0.6;
        self->_redView.alpha = 1.0;
        
    } completion:nil];
    
}

- (CAKeyframeAnimation *)confirmViewRotateInfo
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0.5, 0)],
                           nil];
    
    theAnimation.cumulative = YES;
    theAnimation.duration = 0.9f;
    theAnimation.repeatCount = 100;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    return theAnimation;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    if (self.animationEndBlock) {
//        self.animationEndBlock();
//    }
}

- (NSString *)typeString:(NSInteger)type{
    switch (type) {
        case 0:
            return @"福利红包";
            break;
        case 1:
            return @"扫雷红包";
            break;
        case 2:
            return @"牛牛红包";
            break;
        case 3:
            return @"禁抢红包";
        default:
            break;
    }
    return nil;
}

- (void)updateView:(id)obj response:(id)response rpOverdueTime:(NSString *)rpOverdueTime {
    self.isClickedDisappear = NO;
    if (response != nil) {
        [self responseNull:response];
        return;
    }
    
    [_headIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:[obj objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"nick"]];
    
    NSInteger left = [[obj objectForKey:@"left"] integerValue];
    NSInteger status = [[obj objectForKey:@"status"] integerValue];
    NSString *userId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"userId"]];
    NSInteger type = [[obj objectForKey:@"type"] integerValue];
    
    _redDescLabel.hidden = NO;
    _redDescLabel.text = [NSString stringWithFormat:@"发了一个%@，金额随机", [self typeString:type]];
    
    if (type == 1) {
        NSDictionary *attrDict = [[obj objectForKey:@"attr"] mj_JSONObject];
        _contentLabel.text = [NSString stringWithFormat:@"%zd-%@",[[obj objectForKey:@"money"] integerValue], attrDict[@"bombNum"]];
    } else if (type == 2) {
        _contentLabel.text = [NSString stringWithFormat:@"￥%zd-%@",[[obj objectForKey:@"money"] integerValue], [obj objectForKey:@"total"]];
    } else {
        _contentLabel.text = kRedpackedGongXiFaCaiMessage;
    }
    
    if (status == 1) {  // 正常
        if ([userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {  // 自己
            _small_iconImageView.hidden = YES;
            if (left == 0) {
                [self contentShow:kNoMoreRedpackedMessage];
                [self setDetaiButton];
            } else{
                [self setDetaiButton];
            }
        } else {
            if (left == 0) {
                [self contentShow:kNoMoreRedpackedMessage];
                [self setDetaiButton];
            } else {
                _detailButton.hidden = YES;
                _small_iconImageView.hidden = NO;
            }
        }
    } else { // 过期
        if (type == 2) {
            [self contentShow:@"本包游戏已截止"];
        } else {
            [self contentShow:[NSString stringWithFormat:@"该红包已超过%0.2f分钟，如已领取，可在<账单>中查询", [rpOverdueTime floatValue]/60]];
        }
        
        [self setDetaiButton];
        
    }
}

- (void)contentShow:(NSString *)message {
    _contentLabel.text = message;
    _redDescLabel.hidden = YES;
    _openBtn.hidden = YES;
    self.isClickedDisappear = YES;
}

- (void)responseNull:(id)response {
    NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
//    SVP_SUCCESS_STATUS(msg);
    _redDescLabel.hidden = YES;
    _contentLabel.text = msg;
    _openBtn.hidden = YES;
    self.isClickedDisappear = YES;
    
    if ([[response objectForKey:@"code"] integerValue] == 11 || [[response objectForKey:@"code"] integerValue] == 12) {
        [self setDetaiButton];
    } else {
        _detailButton.hidden = YES;
        _small_iconImageView.hidden = NO;
    }
}


- (void)setDetaiButton {
    _detailButton.hidden = NO;
    [_detailButton setTitle:kLookLuckDetailsMessage forState:UIControlStateNormal];
    _small_iconImageView.hidden = YES;
}


- (void)onbackControl {
    if (!IS_IPHONE_Xr || self.isClickedDisappear) {
       [self disMissRedView];
    }
}

- (void)disMissRedView {
    
    if (self.disMissRedBlock) {
        self.disMissRedBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self->_redView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self->_redView.alpha = 0.0;
        self->_backControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
