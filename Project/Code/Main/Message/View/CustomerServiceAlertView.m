//
//  CustomerServiceAlertView.m
//  Project
//
//  Created by Mike on 2019/3/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CustomerServiceAlertView.h"

@interface CustomerServiceAlertView()<CAAnimationDelegate>

@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIImageView *contentImageView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *backImageView;

@end

@implementation CustomerServiceAlertView


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
    
    CGFloat marginWidth = 30;
    
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = (SCREEN_WIDTH-marginWidth)/1.0;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    
   UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth, y, w, h)];
    contentImageView.backgroundColor = [UIColor clearColor];
//    contentImageView.image = [UIImage imageNamed:@"cs_back"];
    contentImageView.userInteractionEnabled = YES;
    _contentImageView = contentImageView;
//    contentImageView.layer.backgroundColor = [UIColor colorWithRed:0.996 green:0.969 blue:0.898 alpha:1.000].CGColor;
//    contentImageView.layer.cornerRadius = 10;
//    contentImageView.clipsToBounds = YES;
//    contentImageView.layer.masksToBounds = YES;
    //    _contentImageView.backgroundColor = [UIColor redColor];
    [self addSubview:contentImageView];
    
//    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = MBTNColor;
//    [_contentImageView addSubview:topView];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self->_contentImageView);
//        make.height.mas_equalTo(50);
//    }];
//
//
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"-";
//    titleLabel.font = [UIFont vvBoldFontOfSize:18];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [topView addSubview:titleLabel];
//    _titleLabel = titleLabel;
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(topView);
//    }];
//
//
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

    UIButton *cs_goto_btn = [[UIButton alloc] init];
   [cs_goto_btn setBackgroundImage:[UIImage imageNamed:@"cs_goto_btncs"] forState:UIControlStateNormal];
    [cs_goto_btn addTarget:self action:@selector(onCSBtn) forControlEvents:UIControlEventTouchUpInside];
//    csBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    csBtn.backgroundColor = MBTNColor;
//    csBtn.layer.cornerRadius = 5;
    [contentImageView addSubview:cs_goto_btn];

    [cs_goto_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(contentImageView.mas_bottom).offset(-CD_Scal(18, 667));
        make.centerX.mas_equalTo(contentImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(95, 33));
    }];

    
    
//    UIImageView *backImageView = [[UIImageView alloc] init];
////    backImageView.image = [UIImage imageNamed:@"-"];
//    [_contentImageView addSubview:backImageView];
//    _backImageView = backImageView;
//
//    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
}

- (void)updateView:(NSString *)title imageUrl:(NSString *)imageUrl {
    self.titleLabel.text = title;
    

     [self.contentImageView cd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    
}

- (void)onCSBtn {
    if (self.customerServiceBlock) {
        self.customerServiceBlock();
    }
    [self disMissView];
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

@end

