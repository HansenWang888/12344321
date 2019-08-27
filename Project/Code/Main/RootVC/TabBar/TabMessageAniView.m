//
//  TabMessageAniView.m
//  Project
//
//  Created by fangyuan on 2019/3/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "TabMessageAniView.h"

@implementation TabMessageAniView

-(void)startAni{
    CGRect rect1 = self.imageView1.frame;
    CGRect rect2 = self.imageView2.frame;
    self.imageView1.frame = CGRectMake(rect1.origin.x, rect1.size.height, 0, 0);
    self.imageView2.frame = CGRectMake(rect2.size.width+rect2.origin.x, rect2.size.height+rect2.origin.y, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView1.frame = rect1;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:0.5 options:0 animations:^{
        self.imageView2.frame = rect2;
    } completion:^(BOOL finished) {
        if(self.finishBlock)
            self.finishBlock([NSNumber numberWithBool:self.deleteFlag]);
        [self removeFromSuperview];
    }];
}

-(void)stopAni{
    [self.imageView1.layer removeAllAnimations];
    [self.imageView2.layer removeAllAnimations];
}
@end
