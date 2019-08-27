//
//  TabTaskAniView.m
//  Project
//
//  Created by fangyuan on 2019/3/26.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "TabTaskAniView.h"

@implementation TabTaskAniView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.lineImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar2_1"]];
        [self addSubview:self.lineImage1];
        CGRect rect = self.lineImage1.frame;
        rect.origin.x = self.frame.size.width/2.0 -47;
        rect.origin.y = 11;
        rect.size = self.lineImage1.image.size;
        self.lineImage1.frame = rect;
        
        self.lineImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar2_2"]];
        [self addSubview:self.lineImage2];
        rect = self.lineImage2.frame;
        rect.origin.x = self.frame.size.width/2.0 -16;
        rect.origin.y = 6;
        rect.size = self.lineImage2.image.size;
        self.lineImage2.frame = rect;
        
        self.lineImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar2_3"]];
        [self addSubview:self.lineImage3];
        rect = self.lineImage3.frame;
        rect.origin.x = self.frame.size.width/2.0 + 40;
        rect.size = self.lineImage3.image.size;
        rect.origin.y = 0;
        self.lineImage3.frame = rect;
        
//        self.baseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar2"]];
//        self.baseImage.frame = self.bounds;
//        //self.baseImage.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:self.baseImage];
    }
    return self;
}

-(void)startAni{
    self.lineImage1.frame = CGRectMake(self.lineImage1.frame.size.width, self.lineImage1.frame.size.height + 15, 0, 0);
    self.lineImage2.frame = CGRectMake(self.lineImage2.frame.size.width + 75, self.lineImage2.frame.size.height + 6, 0, 0);
    self.lineImage3.frame = CGRectMake(self.frame.size.width/2.0 + 40,self.lineImage3.frame.size.height, 0, 0);
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self resetView];
    } completion:^(BOOL finished) {
        if(self.finishBlock)
            self.finishBlock([NSNumber numberWithBool:self.deleteFlag]);
        //[self removeFromSuperview];
    }];
}

-(void)resetView{
    CGRect rect = self.lineImage1.frame;
    rect.origin.x = self.frame.size.width/2.0 -47;
    rect.origin.y = 11;
    rect.size = self.lineImage1.image.size;
    self.lineImage1.frame = rect;
    
    rect = self.lineImage2.frame;
    rect.origin.x = self.frame.size.width/2.0 -16;
    rect.origin.y = 6;
    rect.size = self.lineImage2.image.size;
    self.lineImage2.frame = rect;
    
    rect = self.lineImage3.frame;
    rect.origin.x = self.frame.size.width/2.0 + 40;
    rect.size = self.lineImage3.image.size;
    rect.origin.y = 0;
    self.lineImage3.frame = rect;
}

-(void)stopAni{
    
}

@end
