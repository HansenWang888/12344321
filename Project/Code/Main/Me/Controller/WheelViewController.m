//
//  WheelViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "WheelViewController.h"
#import "WheelView.h"
#import "UIImageView+WebCache.h"

@interface WheelViewController ()
@property(nonatomic,strong)WheelView *wheelView;
@property(nonatomic,strong)NSDictionary *dataDic;//当前奖盘信息
@property(nonatomic,strong)NSDictionary *lotteryDic;//中奖信息
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,assign)NSInteger times;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *showDescBtn;
@property(nonatomic,strong)UIImageView *descImageView;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end

@implementation WheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"抽奖";
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    NSInteger ckd = statusRect.size.height+navRect.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT - ckd)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *containView = [[UIView alloc] initWithFrame:scrollView.frame];
    [scrollView addSubview:containView];
    containView.backgroundColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"668669"]];
    [containView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containView);
    }];
    NSInteger width = SCREEN_WIDTH * 0.8;
    WheelView *view = [[WheelView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    view.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    [containView addSubview:view];
    view.needleView.hidden = YES;
    self.wheelView = view;
    [self.wheelView.button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheelTitle"]];
//    titleView.contentMode = UIViewContentModeScaleAspectFit;
//    [containView addSubview:titleView];
//    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(containView).offset(40);
//        make.right.equalTo(containView).offset(-40);
//        make.bottom.equalTo(view.mas_top);
//        make.top.equalTo(containView.mas_top);
//    }];
    
    UIImageView *caiDaiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caiDai"]];
    [containView addSubview:caiDaiView];
    caiDaiView.contentMode = UIViewContentModeScaleAspectFit;
    caiDaiView.userInteractionEnabled = NO;
    [caiDaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView.mas_centerX);
        make.centerY.equalTo(containView.mas_centerY).offset(-50);
        make.left.equalTo(containView).offset(20);
        make.right.equalTo(containView).offset(-20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"请稍候" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"wheelBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(477/3.0));
        make.height.equalTo(@(116/3.0));
        if(SCREEN_HEIGHT <= 568)
            make.top.equalTo(view.mas_bottom).offset(10);
        else if(SCREEN_HEIGHT == 667)
            make.top.equalTo(view.mas_bottom).offset(30);
        else
            make.top.equalTo(view.mas_bottom).offset(50);
        make.centerX.equalTo(containView.mas_centerX);
    }];
    self.button = btn;
    SVP_SHOW;
    [self requestData];
    
    UIImageView *flagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"laba"]];
    [containView addSubview:flagImageView];
    flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@27);
        make.left.equalTo(containView.mas_left).offset(8);
        make.bottom.equalTo(containView.mas_bottom).offset(-8);
    }];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"查看介绍" forState:UIControlStateNormal];
    [btn setTitle:@"隐藏介绍" forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showDesc) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:btn];
    self.showDescBtn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@27);
        make.left.equalTo(flagImageView.mas_right).offset(10);
        make.centerY.equalTo(flagImageView.mas_centerY);
    }];
    
    if(self.indicatorView == nil){
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake((self.view.frame.size.width - 20)/2.0, (self.view.frame.size.height - 20)/2.0 - 40, 20, 20);
        indicator.autoresizingMask = UIViewAutoresizingNone;
        indicator.hidden = YES;
        self.indicatorView = indicator;
        [self.view addSubview:indicator];
    }
}

-(void)requestData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER getLotteryListWithSuccess:^(id object) {
        SVP_DISMISS;
        [weakSelf requestDataBack:object];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestDataBack:(NSDictionary *)dict{
    NSArray *arr = dict[@"data"];
    if(arr.count == 0){
        SVP_ERROR_STATUS(@"暂无转盘信息");
        return;
    }
    self.dataDic = arr[0];
    self.times = [self.dataDic[@"lotteryNum"] integerValue];
    NSString *s = [NSString stringWithFormat:@"剩余%ld次",(long)self.times];
    [self.button setTitle:s forState:UIControlStateNormal];
    
    NSString *img = self.dataDic[@"img"];
    WEAK_OBJ(weakSelf, self);
    [self.wheelView.containView sd_setImageWithURL:[NSURL URLWithString:img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        weakSelf.wheelView.needleView.hidden = NO;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController.navigationBarHidden == YES)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)btnAction{
    if(self.dataDic == nil)
        return;
    if(self.wheelView.button.userInteractionEnabled == NO)
        return;

    if(self.times == 0){
        SVP_ERROR_STATUS(@"抽奖次数已用完");
        return;
    }
    self.wheelView.button.userInteractionEnabled = NO;
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER lotteryWithId:[self.dataDic[@"lotteryId"] integerValue] success:^(id object) {
        [weakSelf.indicatorView stopAnimating];
        weakSelf.indicatorView.hidden = YES;
        [weakSelf lotteryBack:object];
    } fail:^(id object) {
        [weakSelf.indicatorView stopAnimating];
        weakSelf.indicatorView.hidden = YES;
        self.wheelView.button.userInteractionEnabled = YES;
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)lotteryBack:(NSDictionary *)dict{
    NSInteger lotteryId = [dict[@"data"][@"id"] integerValue];
    self.lotteryDic = dict;
    NSArray *arr = self.dataDic[@"lotteryItems"];
    if(arr.count == 0)
        return;
    self.wheelView.total = arr.count;
    for (NSInteger i = 0; i < arr.count; i ++) {
        NSDictionary *dd = arr[i];
        NSInteger lId = [dd[@"id"] integerValue];
        if(lId == lotteryId){
            self.wheelView.targetIndex = i + 1;
            break;
        }
    }
    WEAK_OBJ(weakSelf, self);
    self.wheelView.scrollFinishBlock = ^(id object) {
        SVP_SUCCESS_STATUS(weakSelf.lotteryDic[@"data"][@"value"]);
        weakSelf.times -= 1;
        NSString *s = [NSString stringWithFormat:@"剩余%ld次",weakSelf.times];
        [weakSelf.button setTitle:s forState:UIControlStateNormal];
    };
    [self.wheelView startScroll];
}

-(void)showDesc{
    self.showDescBtn.selected = !self.showDescBtn.selected;
    if(self.showDescBtn.selected){
        if(self.descImageView == nil){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, SCREEN_WIDTH, self.scrollView.frame.size.height)];
            UIImage *img = [UIImage imageNamed:@"hdxqq"];
            float ratt = img.size.width/img.size.height;
            float h = SCREEN_WIDTH/ratt;
            imageView.image = img;
            CGRect rect = imageView.frame;
            rect.size.height = h;
            imageView.frame = rect;
            [self.scrollView addSubview:imageView];
            self.descImageView = imageView;
        }
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.descImageView.frame.size.height + self.descImageView.frame.origin.y);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointMake(0, 88) animated:YES];
        });
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.scrollView.frame.size.height);
        });
    }
}

@end
