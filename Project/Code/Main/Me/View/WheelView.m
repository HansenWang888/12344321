//
//  WheelView.m
//  Project
//
//  Created by fangyuan on 2019/2/18.
//  Copyright © 2019 CDJay. All rights reserved.
//转盘

#import "WheelView.h"
@interface WheelView()<CAAnimationDelegate>
@property(nonatomic,strong)NSArray *dataArray;//奖品数据
@property(nonatomic,assign)NSInteger currentAngel;

@end

@implementation WheelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger width = frame.size.width;
        self.containView = [[UIImageView alloc] init];
        self.containView.contentMode = UIViewContentModeScaleAspectFit;
        self.containView.frame = CGRectMake(0, 0, width, width);
        self.containView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        self.containView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containView];
        
        self.needleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhen"]];
        self.needleView.contentMode = UIViewContentModeScaleAspectFit;
        self.needleView.backgroundColor = [UIColor clearColor];
        self.needleView.frame = CGRectMake(0, 0, width*0.7, width*0.7);
        self.needleView.center = self.containView.center;
        self.needleView.userInteractionEnabled = YES;
        [self addSubview:self.needleView];
        self.currentAngel = 0;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0, 0, 70, 70);
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //[btn setTitle:@"开始抽奖" forState:UIControlStateNormal];
        btn.center = CGPointMake(self.needleView.frame.size.width/2.0, self.needleView.frame.size.height/2.0);
        [self.needleView addSubview:btn];
        self.button = btn;
    }
    return self;
}

-(void)startScroll{
    self.button.userInteractionEnabled = NO;
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    
    animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.currentAngel%360)];
    NSLog(@"====targetIndex = %ld",(long)self.targetIndex);
    self.currentAngel = ((self.total - self.targetIndex) * 1.0)/self.total * 360 + 360 * 4;
    NSInteger per = 360/self.total;//每块占的角度
    self.currentAngel += per/2;//默认是指向块的分隔线，这边修正指到块的中间
    
    //随机在这个块做一定的偏移，这样更真实
    NSInteger a = arc4random()%((per - 6)/2);
    NSInteger b = arc4random()%2;
    if(b == 0)
        self.currentAngel -= a;
    else
        self.currentAngel += a;
    animation.toValue =  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.currentAngel)];
    animation.duration  = 5.0 + ((self.total - self.targetIndex) * 1.0)/self.total;  //一次时间
    animation.autoreverses = NO;                         //是否自动回倒
    animation.fillMode =kCAFillModeForwards;
    animation.removedOnCompletion = NO;           //设置进入后台动画不停止
    animation.repeatCount = 0;            //重复次数
    animation.delegate = self;                    //动画代理
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.containView.layer addAnimation:animation forKey:nil];
}

//数据未返回来时一直转
-(void)loadingScroll{
    self.button.userInteractionEnabled = NO;
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    NSInteger times = 100;
    animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.currentAngel%360)];
    self.currentAngel = 360 * times;
    animation.toValue =  [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.currentAngel)];
    animation.duration  = times;
    animation.autoreverses = NO;                         //是否自动回倒
    animation.fillMode =kCAFillModeForwards;
    animation.removedOnCompletion = NO;           //设置进入后台动画不停止
    animation.repeatCount = 0;            //重复次数
    animation.delegate = self;                    //动画代理
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.containView.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.button.userInteractionEnabled = YES;
    if(self.scrollFinishBlock){
        self.scrollFinishBlock(nil);
    }
}

@end
