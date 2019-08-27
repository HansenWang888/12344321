//
//  ReportView.m
//  Project
//
//  Created by fangyuan on 2019/5/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportView.h"

static ReportView *instance = nil;
@interface ReportView()
@property (nonatomic ,strong) IBOutlet UIView *bgView;
@property (nonatomic ,strong) IBOutlet UIView *lineView;
@property (nonatomic ,strong) IBOutlet UIView *containView;
@property (nonatomic ,strong) IBOutlet UIButton *reportBtn;

@property (nonatomic ,copy)CallbackBlock block;
@end
@implementation ReportView

+ (ReportView *)createInstanceWithView:(UIView *)superView{
    if(instance)
        [instance removeFromSuperview];
    if(superView == nil){
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
            return nil;
        superView = window;
    }
    instance = [[[NSBundle mainBundle] loadNibNamed:@"ReportView" owner:nil options:nil] lastObject];
    instance.frame = superView.bounds;
    [instance initView];
    [superView addSubview:instance];
    [instance show];
    return instance;
}

-(void)initView{
    self.lineView.backgroundColor = COLOR_X(240, 240, 240);
    CGRect rect = self.lineView.frame;
    rect.size.height = 0.5;
    self.lineView.frame = rect;
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.reportBtn.layer.masksToBounds = YES;
    self.reportBtn.layer.cornerRadius = 4.0;
    self.containView.layer.masksToBounds = YES;
    self.containView.layer.cornerRadius = 6.0;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.bgView addGestureRecognizer:gesture];
}

-(void)show{
    self.bgView.alpha = 0.0;
    self.containView.transform = CGAffineTransformMakeScale(0.01,0.01);
    self.containView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        // 放大
        self.containView.transform = CGAffineTransformMakeScale(1, 1);
        self.containView.alpha = 1.0;
        self.bgView.alpha = 0.6;
    } completion:nil];
}

-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.0;
        self.containView.transform = CGAffineTransformMakeScale(0.01,0.01);
        self.containView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}

-(IBAction)btnAction:(id)sender{
    [self dismiss];
    if(self.selectBlock)
        self.selectBlock(nil);
}
@end
