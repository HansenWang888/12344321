//
//  EnvelopBackImg.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "EnvelopBackImg.h"

@interface EnvelopBackImg(){
    CGFloat _r;///<半径
    CGFloat _x;
    CGFloat _y;
    UIColor *_color;
}
@end

@implementation EnvelopBackImg


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    // Drawing code
    CGFloat r = (_r>0)?_r:CGRectGetHeight(self.bounds)*0.665;
    CGFloat x = (_x>0)?_r:CGRectGetWidth(self.bounds)/2;
    CGFloat y = _y;
    
    CGContextRef  context =UIGraphicsGetCurrentContext();
//    UIColor *aColor = HexColor(@"#D65942");
    UIColor *aColor = [UIColor colorWithRed:0.851 green:0.345 blue:0.251 alpha:1.000];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextAddArc(context,x, y, r, 0, 2*M_PI, 1);
    CGContextDrawPath(context, kCGPathFill);
}

- (instancetype)initWithFrame:(CGRect)frame r:(CGFloat)r x:(CGFloat)x y:(CGFloat)y{
    self = [super initWithFrame:frame];
    if (self) {
        _r = r;
        _x = x;
        _y = y;
    }
    return self;
}


@end
