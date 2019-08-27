//
//  SelectTimeView.m
//  Project
//
//  Created by fy on 2019/1/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SelectTimeView.h"

@implementation SelectTimeView

static SelectTimeView *instance = nil;

+ (SelectTimeView *)sharedInstance{
    if(instance == nil)
        instance = [[SelectTimeView alloc] init];
    return instance;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tapRecognize.numberOfTapsRequired = 1;
        tapRecognize.delegate = self;
        [tapRecognize setEnabled :YES];
        
        [self.bgView addGestureRecognizer:tapRecognize];
        
        [self btnListView];
        [self showSelf];
    }
    return self;
}

-(void)showSelf{
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.bgView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.5;
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

-(void) handleTap:(UITapGestureRecognizer *)recognizer{
    [self removeSelf];
}

-(void)removeSelf{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        instance = nil;
    }];
}

-(void)btnListView{
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8.0;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@290);
        make.height.equalTo(@194);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
    }];
    
    UIImageView *tabView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBarBg"]];
    [contentView addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.height.equalTo(@44);
        make.top.equalTo(contentView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize2:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"快捷选择";
    [tabView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tabView);
    }];
    
    for (NSInteger i = 0; i < 6; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:Color_3 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize2:16];
        [btn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [btn setTitle:@"今天" forState:UIControlStateNormal];
                break;
            case 1:
                [btn setTitle:@"昨天" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"本周" forState:UIControlStateNormal];
                break;
            case 3:
                [btn setTitle:@"上周" forState:UIControlStateNormal];
                break;
            case 4:
                [btn setTitle:@"本月" forState:UIControlStateNormal];
                break;
            case 5:
                [btn setTitle:@"上月" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        if(i == 0 || i == 3 || i == 4)
            [btn setBackgroundColor:COLOR_X(252, 252, 252)];
        [contentView addSubview:btn];
        btn.tag = i + 1;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i%2 == 0)
                make.left.equalTo(contentView);
            else
                make.right.equalTo(contentView);
            make.height.equalTo(@50);
            make.width.equalTo(contentView.mas_width).multipliedBy(0.5);
            NSInteger t = i/2;
            make.top.equalTo(@(48 * t + 44));
        }];
    }
}

-(void)selectTime:(UIButton *)btn{
    NSInteger tag = btn.tag;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.selectBlock([NSNumber numberWithInteger:tag]);
        [self removeFromSuperview];
        instance = nil;
    }];
}
@end
