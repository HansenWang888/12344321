//
//  WebProgressView.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "WebProgressView.h"
@interface WebProgressView(){
    UIView *_proView;
}
@end

@implementation WebProgressView

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

#pragma mark Data
- (void)initData{
    _proHeigh = 2.0f;
    _progressColor = CDCOLOR(154, 216, 97);
}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
}

- (void)setProHeigh:(CGFloat)proHeigh{
    _proHeigh = proHeigh;
}

#pragma mark subView
- (void)initSubviews{
    _proView = [UIView new];
    [self addSubview:_proView];
    _proView.backgroundColor = self.progressColor;
}

#pragma mark Layout
- (void)initLayout{
    _proView.frame = CGRectMake(0, 0, 0, self.proHeigh);
    
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    CGFloat time = (animated)?0.2f:0;
    CGFloat w = CGRectGetWidth(self.frame) *progress;
    [UIView animateWithDuration:time animations:^{
        self->_proView.frame = CGRectMake(0, 0, w, self.proHeigh);
    }];
    if(progress == 1){
        [self performSelector:@selector(setProgress:animated:) withObject:0 afterDelay:0.2];
    }
}

@end
