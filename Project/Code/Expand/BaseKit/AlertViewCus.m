//
//  AlertViewCus.m
//  Project
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AlertViewCus.h"

@interface AlertViewCus()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIView *containView;
@property (nonatomic ,strong) UIView *btnView;
@property (nonatomic ,copy)CallbackBlock block;
@end

static AlertViewCus *instance = nil;

@implementation AlertViewCus

+ (AlertViewCus *)createInstanceWithView:(UIView *)superView{
//    [SVProgressHUD dismiss];
    if(instance) {
         [instance removeFromSuperview];
    }
    if(superView == nil){
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal){
            NSArray *windows = [[UIApplication sharedApplication] windows];
            
//            for(UIWindow *tmpWin in windows){
//                if (tmpWin.windowLevel == UIWindowLevelNormal){
//                    window = tmpWin;
//                    break;
//                }
//            }
            for (NSInteger index = 0; index < windows.count; index++) {
                UIWindow *tmpWin = [windows objectAtIndex:index];
                if (tmpWin.windowLevel == UIWindowLevelNormal){
                    window = tmpWin;
                    break;
                }
            }
        }
        
        if(window == nil) {
             return nil;
        }
        superView = window;
    }
    instance = [[AlertViewCus alloc] initWithFrame:superView.bounds];
    [superView addSubview:instance];
    return instance;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.containView = [[UIView alloc] init];
        self.containView.backgroundColor = [UIColor whiteColor];
        self.containView.layer.masksToBounds = YES;
        self.containView.layer.cornerRadius = 10.0;
        NSInteger width = 300;
//        self.containView.frame = CGRectMake(0, 0, width, width * 0.618);
//        self.containView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0 - 30);
        [self addSubview:self.containView];
        [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.height.equalTo(@(width * 0.618));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-30);
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, width - 40, width * 0.618 - 48)];
        label.textColor = Color_0;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize2:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self.containView addSubview:label];
        self.textLabel = label;
        
        UIImageView *view = [[UIImageView alloc] init];
        //view.backgroundColor = MBTNColor;//COLOR_X(242, 242, 242);
        view.image = [UIImage imageNamed:@"navBarBg"];
        view.userInteractionEnabled = YES;
        [self.containView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containView);
            make.height.equalTo(@48);
        }];
        self.btnView = view;

    }
    return self;
}

-(void)showWithText:(NSString *)text button:(NSString *)buttonTitle callBack:(CallbackBlock)block{
    self.textLabel.text = text;
    self.block = block;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setBackgroundColor:MBTNColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6.0;
    [self.btnView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.btnView);
    }];
    [self refreshLayout];
    [self show];
}

-(void)showWithText:(NSString *)text button1:(NSString *)buttonTitle1 button2:(NSString *)buttonTitle2 callBack:(CallbackBlock)block{
    self.textLabel.text = text;
    //[self.textLabel setValue:@(40) forKey:@"lineSpacing"];
    self.block = block;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setBackgroundColor:MBTNColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:buttonTitle1 forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6.0;
    [self.btnView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.btnView);
        make.width.equalTo(self.btnView.mas_width).multipliedBy(0.5);
    }];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setBackgroundColor:MBTNColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction2) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:buttonTitle2 forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6.0;
    [self.btnView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.btnView.mas_width).multipliedBy(0.5);
        make.right.top.bottom.equalTo(self.btnView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    lineView.alpha = 0.8;
    [self.btnView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnView.mas_centerX);
        make.top.bottom.equalTo(self.btnView);
        make.width.equalTo(@0.5);
    }];
    [self refreshLayout];
    [self show];
}

-(void)btnAction1{
    if(self.block)
        self.block(@0);
    [self dismiss];
}

-(void)btnAction2{
    if(self.block)
        self.block(@1);
    [self dismiss];
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

-(void)refreshLayout{
    CGSize size = [[FunctionManager sharedInstance] getFitSizeWithLabel:self.textLabel withFixType:FixTypes_width];
    CGRect rect = self.textLabel.frame;
    rect.size.height = size.height + 30;
    NSInteger height = rect.size.height + 48;
    NSInteger width = 300;
    NSInteger h = width * 0.618;
    if(height < h){
        height = h;
    }else{
        self.textLabel.frame = rect;
        [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}
@end
