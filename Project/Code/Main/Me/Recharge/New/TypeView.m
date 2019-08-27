//
//  TypeView.m
//  Project
//
//  Created by fangyuan on 2019/5/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "TypeView.h"

@interface TypeView ()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *lastBtn;
@end

@implementation TypeView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        if(buttonArray.count > 0){
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 3.5, 50, 3)];
            lineView.backgroundColor = COLOR_X(243, 4, 0);
            [self addSubview:lineView];
            self.lineView = lineView;
        }
        
        NSInteger height = frame.size.height - 20;
        NSInteger marX = 10;
        NSInteger width = (frame.size.width - marX * 2)/buttonArray.count;
        for (NSInteger i = 0;i < buttonArray.count; i++) {
            NSDictionary *dic = buttonArray[i];
            NSString *imgNormal = [dic objectForKey:@"imgNormal"];
            NSString *imgSelected = [dic objectForKey:@"imgSelected"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(marX + (width * i), 10, width, height);
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imgSelected] forState:UIControlStateSelected];
            [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [btn setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:btn];
            btn.tag = i + 1;
            if(i == 0){
                CGPoint point = self.lineView.center;
                point.x = btn.center.x;
                self.lineView.center = point;
                
//                UIImageView *hotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rec_hot"]];
//                hotView.contentMode = UIViewContentModeScaleAspectFit;
//                [self addSubview:hotView];
//                [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(btn.mas_centerX).offset(5);
//                    make.top.equalTo(btn.mas_centerY).offset(-30);
//                }];
            }
        }
    }
    return self;
}

-(void)buttonAction:(UIButton *)btn{
    if(btn.selected)
        return;
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        self.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
    } completion:nil];
    if(self.selectBlock)
        self.selectBlock([NSNumber numberWithInteger:btn.tag]);
}
@end
