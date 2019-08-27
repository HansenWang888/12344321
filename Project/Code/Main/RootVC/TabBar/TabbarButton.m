//
//  TabbarButton.m
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "TabbarButton.h"
#import "Public.h"
#import "TabMessageAniView.h"
#import "AniView.h"
#import "TabTaskAniView.h"

@interface TabbarButton()<CAAnimationDelegate>{
    UILabel *_titleLabel;
    UILabel *_badeLabel;
    UIView *_badeBack;
}
@property(nonatomic,strong)TabTaskAniView *aniView;
@end

@implementation TabbarButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
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
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self->_iconImg.mas_bottom).offset(1);
    }];
    
    [_badeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_iconImg.mas_right).offset(-2);
        make.width.greaterThanOrEqualTo(@(10));
        make.height.equalTo(@(10));
        make.top.equalTo(self->_iconImg.mas_top).offset(1);
    }];
    
    [_badeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(12));
        make.width.equalTo(self->_badeLabel.mas_width).offset(2);
        make.center.equalTo(self->_badeLabel);
    }];
}

#pragma mark ----- subView
- (void)initSubviews {
    _iconImg = [UIImageView new];
    [self addSubview:_iconImg];
    
    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize2:11];
    
    _badeBack = [UIView new];
    [self addSubview:_badeBack];
    _badeBack.layer.cornerRadius = 6;
    _badeBack.layer.masksToBounds = YES;
    _badeBack.backgroundColor = _badeColor;
    _badeBack.hidden = YES;
    
    _badeLabel = [UILabel new];
    [self addSubview:_badeLabel];
    _badeLabel.font = [UIFont systemFontOfSize2:9];
    _badeLabel.textAlignment = NSTextAlignmentCenter;
    _badeLabel.hidden = YES;
    
    _badeLabel.textColor = [UIColor whiteColor];
    //    _badeLabel.text = @"2";
}

+ (TabbarButton *)tabbar{
    TabbarButton *item = [TabbarButton new];
    item.normalColor = Color_9;
    item.selectColor = COLOR_X(248, 75, 75);
    item.badeColor = [UIColor redColor];
    return item;
}

- (void)setBadeColor:(UIColor *)badeColor {
    _badeColor = badeColor;
    _badeBack.backgroundColor = badeColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setBadeValue:(NSString *)badeValue {
    _badeValue = badeValue;
    if([badeValue isEqualToString:@"null"]) {
        _badeLabel.hidden = YES;
        _badeBack.hidden = YES;
    } else {
        _badeLabel.hidden = NO;
        _badeBack.hidden = NO;
    }
}

- (void)setNormalImg:(UIImage *)normalImg {
    _normalImg = normalImg;
}

- (void)setSelectImg:(UIImage *)selectImg {
    _selectImg = selectImg;
}

- (void)setTabbarSelected:(BOOL)tabbarSelected{
    _tabbarSelected = tabbarSelected;
    _titleLabel.textColor = (tabbarSelected)?_selectColor:_normalColor;
//    _iconImg.image = (tabbarSelected)?_selectImg:_normalImg;
    if(tabbarSelected){
        if(self.animationType == 0)
            self.iconImg.image = self.selectImg;
        else
            [self runAni];
    }
    else{
        _iconImg.image = _normalImg;
        AniView *imgView = [self viewWithTag:99];
        if(imgView){
            NSLog(@"set deleteflag");
            imgView.deleteFlag = YES;
            if([imgView isKindOfClass:[TabMessageAniView class]]){
                TabMessageAniView *aniView = (TabMessageAniView *)imgView;
                [aniView stopAni];
            }else{
                [imgView.layer removeAllAnimations];
            }
            [imgView removeFromSuperview];
        }
    }
}

-(void)setAnimationType:(NSInteger)animationType{
    _animationType = animationType;
    if(_animationType == 5){//活动奖励
        TabTaskAniView *aniView = [[TabTaskAniView alloc] initWithFrame:CGRectMake(0, 0, 158, 75)];
        [self insertSubview:aniView atIndex:0];
        aniView.transform = CGAffineTransformMakeScale(self.scaleX,self.scaleY);
        self.aniView = aniView;
        CGPoint center = aniView.center;
        center.x = self.frame.size.width/2.0;
        center.y = self.frame.size.height/2.0 - 8;
        aniView.center = center;
        [aniView resetView];
    }
}

-(void)runAni{
    AniView *imgView = [self viewWithTag:99];
    if(imgView == nil && self.animationType != 4 && self.animationType != 5){
        imgView = [[AniView alloc] init];
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        imgView.tag = 99;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:_selectImg];
        img.frame = CGRectMake(0, 0, _selectImg.size.width, _selectImg.size.height);
        img.tag = 22;
        [imgView addSubview:img];
    }
    imgView.userInteractionEnabled = NO;
    imgView.hidden = NO;
    if(self.animationType == 1){
        imgView.frame = CGRectMake(_iconImg.center.x - _selectImg.size.width/2.0, _iconImg.center.y - _selectImg.size.height/2.0, 0, _selectImg.size.height);
        
        [UIView animateWithDuration:0.22 animations:^{
            imgView.frame = CGRectMake(self.iconImg.center.x - self.selectImg.size.width/2.0, self.iconImg.center.y - self.selectImg.size.height/2.0, self.selectImg.size.width, self.selectImg.size.height);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
            if(!imgView.deleteFlag)
                self.iconImg.image = self.selectImg;
        }];
    }else if(self.animationType == 2){
        imgView.frame = CGRectMake(self.iconImg.center.x - self.selectImg.size.width/2.0, self.iconImg.center.y - self.selectImg.size.height/2.0, self.selectImg.size.width, self.selectImg.size.height);
        
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        NSInteger times = 0.22;
        animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)];
        animation.toValue =  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360)];
        animation.duration  = times;
        animation.autoreverses = NO;                         //是否自动回倒
        animation.fillMode =kCAFillModeForwards;
        animation.removedOnCompletion = YES;           //设置进入后台动画不停止
        animation.repeatCount = 0;            //重复次数
        animation.delegate = self;                    //动画代理
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [imgView.layer addAnimation:animation forKey:nil];
    }else if(self.animationType == 3){
        imgView.frame = CGRectMake(_iconImg.center.x - _selectImg.size.width/2.0, _iconImg.center.y + _selectImg.size.height/2.0, 0, 0);
        UIImageView *img = [imgView viewWithTag:22];
        img.frame = CGRectMake(0, -_selectImg.size.height, _selectImg.size.width, _selectImg.size.height);
        [UIView animateWithDuration:0.22 animations:^{
            imgView.frame = CGRectMake(self.iconImg.center.x - self.selectImg.size.width/2.0, self.iconImg.center.y - self.selectImg.size.height/2.0, self.selectImg.size.width, self.selectImg.size.height);
            img.frame = CGRectMake(0, 0, self.selectImg.size.width, self.selectImg.size.height);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
            if(!imgView.deleteFlag)
                self.iconImg.image = self.selectImg;
        }];
    }else if(self.animationType == 4){
        TabMessageAniView *aniView = [[[NSBundle mainBundle] loadNibNamed:@"TabMessageAniView" owner:nil options:nil] lastObject];
        aniView.frame = CGRectMake(_iconImg.center.x - _selectImg.size.width/2.0 - 0.5, _iconImg.center.y - _selectImg.size.height/2.0, self.selectImg.size.width, _selectImg.size.height);
        [self addSubview:aniView];
        self.iconImg.hidden = YES;
        [aniView startAni];
        aniView.tag = 99;
        WEAK_OBJ(weakSelf, self);
        aniView.finishBlock = ^(id object) {
            BOOL deleteFlag = [object boolValue];
            weakSelf.iconImg.hidden = NO;
            if(!deleteFlag){
                weakSelf.iconImg.image = weakSelf.selectImg;
            }
        };
    }else if(self.animationType == 5){
        [self.aniView startAni];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    AniView *imgView = [self viewWithTag:99];
    [imgView removeFromSuperview];
    if(imgView && !imgView.deleteFlag){
        self.iconImg.image = self.selectImg;
        NSLog(@"set select iconimg");
    }
}


@end
