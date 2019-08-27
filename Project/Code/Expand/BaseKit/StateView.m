//
//  StateView.m
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "StateView.h"

@interface StateView(){
    UIImageView *_imgView;
    UILabel *_stateLabel;
    UIButton *_handleBtn;
}

@property (nonatomic ,copy) CDStateHandleBlock handle;

@end


@implementation StateView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (instancetype)StateViewWithHandle:(CDStateHandleBlock)handle{
    StateView *view = [StateView new];
    view.handle = handle;
    return view;
}

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
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
        make.width.height.equalTo(@150);
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_imgView.mas_bottom);
        make.centerX.equalTo(self);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _imgView = [UIImageView new];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgView];
    
    _stateLabel = [UILabel new];
    [self addSubview:_stateLabel];
    _stateLabel.font = [UIFont systemFontOfSize2:14];
    _stateLabel.textColor = [UIColor lightGrayColor];
    self.clipsToBounds = YES;
}

- (void)hidState{
//    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
//    });
}

- (void)showNetError{
    [self showImg:[UIImage imageNamed:@"state_netError"] Title:@"网络开小差了，请检查网络"];
}
- (void)showNetError:(NSString *)errmsg {
    [self showImg:[UIImage imageNamed:@"state_netError"] Title:errmsg];
}
- (void)showEmpty{
    [self showImg:[UIImage imageNamed:@"state_empty"] Title:@"暂无内容"];
}
- (void)showEmpty:(NSString *)title {
    [self showImg:[UIImage imageNamed:@"state_empty"] Title:title];
}

- (void)showImg:(UIImage *)img Title:(NSString *)title{
    CGRect frame = self.superview.bounds;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *sc = (UIScrollView *)self.superview;
        frame = CGRectMake(frame.origin.x, frame.origin.y+sc.contentSize.height+64, frame.size.width, frame.size.height-sc.contentSize.height-64);
    }
    self.frame = frame;
    [self initLayout];
    _imgView.image = img;
    _stateLabel.text = title;
    self.hidden = NO;
}

@end
