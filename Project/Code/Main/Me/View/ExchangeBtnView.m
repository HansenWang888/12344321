//
//  ExchangeBtnView.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ExchangeBtnView.h"

@implementation ExchangeBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 3, 36, 4)];
        barView.backgroundColor = MBTNColor;
        barView.layer.cornerRadius = 2;
        barView.layer.masksToBounds = YES;
        [self addSubview:barView];
        self.barView = barView;
        _selectIndex = 0;
    }
    return self;
}

-(void)setBtnTitleArray:(NSArray *)btnTitleArray{
    NSInteger width = self.frame.size.width/btnTitleArray.count;
    NSInteger i = 0;
    for (NSString *title in btnTitleArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize2:15];
        [btn setTitleColor:MBTNColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        [self addSubview:btn];
        btn.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
        if(i == 0){
            CGPoint point = self.barView.center;
            point.x = btn.center.x;
            self.barView.center = point;
        }
        i += 1;
    }
}

-(void)btnAction:(UIButton *)button{
    NSInteger tag = button.tag - 1;
    if(tag == _selectIndex)
        return;
    _selectIndex = tag;
    CGPoint point = self.barView.center;
    point.x = button.center.x;
    [UIView animateWithDuration:0.25 animations:^{
        self.barView.center = point;
    }];
    NSNumber *num = [NSNumber numberWithInteger:tag];
    self.callbackBlock(num);
}

-(void)setSelectIndex:(NSInteger)index{
    _selectIndex = index;
    CGPoint point = self.barView.center;
    UIButton *btn = [self viewWithTag:index + 1];
    point.x = btn.center.x;
    [UIView animateWithDuration:0.25 animations:^{
        self.barView.center = point;
    }];
}

@end
