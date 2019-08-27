//
//  EasyOperater.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/3/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "EasyOperater.h"

@implementation EasyOperater

static EasyOperater *instance = nil;
+(instancetype)sharedInstance{
    if(instance == nil){
        instance = [[[NSBundle mainBundle] loadNibNamed:@"EasyOperater" owner:nil options:nil] lastObject];
        [instance initView];
    };
    return instance;
}

+(BOOL)isExist{
    if(instance)
        return YES;
    return NO;
}

+(void)remove{
    if(instance){
        [instance removeFromSuperview];
        instance = nil;
    }
}

-(void)initView{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    if(window == nil)
        return;
    [window addSubview:self];
    self.frame = CGRectMake(SCREEN_WIDTH - self.frame.size.width - 20, 70, self.frame.size.width, self.frame.size.height);
}

-(IBAction)buttonAction:(id)sender{
}

-(void)show{
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:nil];
}

-(void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        instance = nil;
    }];
}

@end
