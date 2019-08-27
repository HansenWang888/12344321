//
//  ActivityDetail1ViewController.m
//  Project
//
//  Created by fangyuan on 2019/3/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityDetail1ViewController.h"

@interface ActivityDetail1ViewController ()
@property(nonatomic,strong)NSDictionary *moneyDic;
@property(nonatomic,strong)NSMutableArray *aniObjArray;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ActivityDetail1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    // Do any additional setup after loading the view.
    self.aniObjArray = [NSMutableArray array];

    [self getData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)update{
    NSMutableArray *newArray = [NSMutableArray array];
    for (UIView *view in self.aniObjArray) {
        CGPoint point = [view.superview convertPoint:view.center toView:self.view];
        if(point.y < 0 || point.y > self.view.frame.size.height)
            continue;
        [newArray addObject:view];
    }
    if(newArray.count == 0)
        return;
    NSInteger random = arc4random()%newArray.count;
    if(random >= newArray.count)
        random = newArray.count - 1;
    UIView *view = newArray[random];
    if([view isKindOfClass:[UIImageView class]]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuang2"]];
        imgView.alpha = 0.9;
        [view addSubview:imgView];
        imgView.frame = CGRectMake(0, view.frame.size.height - 7, imgView.image.size.width, imgView.image.size.height);
        [UIView animateWithDuration:0.6 animations:^{
            imgView.frame = CGRectMake(0, -imgView.image.size.height, imgView.image.size.width, imgView.image.size.height);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    NSInteger type = [self.infoDic[@"type"] integerValue];
    if(type == RewardType_zcdljl)
        return;
    SVP_SHOW;
    [NET_REQUEST_MANAGER getActivityDetailWithId:self.infoDic[@"id"] type:type success:^(id object) {
        [weakSelf getDataBack:object];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)getDataBack:(NSDictionary *)dict{
    SVP_DISMISS;
    NSInteger type = [self.infoDic[@"type"] integerValue];
    if(type == RewardType_ztlsyj || type == RewardType_bzsz){
        self.moneyDic = @{@"first":dict[@"data"][@"money"]};
    }else
        self.moneyDic = dict[@"data"][@"money"];
    [self writeTitle];
}

-(void)writeTitle{
    if(self.moneyDic == nil)
        return;
    if(self.imageView.image == nil)
        return;
    NSInteger type = [self.infoDic[@"type"] integerValue];
    NSArray *arr = [self.imageView subviews];
    for (id obj in arr) {
        if([obj isKindOfClass:[UILabel class]])
            [obj removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize2:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_X(255, 177, 2);
//    label.shadowColor = Color_9;
//    label.shadowOffset = CGSizeMake(0, 1);
    NSString* amout= STR_TO_AmountFloatSTR(self.moneyDic[@"first"]);
    if(type == RewardType_czjl)
        label.text = [NSString stringWithFormat:@"已领取%@元",amout];
    else if(type == RewardType_ztlsyj || type == RewardType_bzsz)
        label.text = [NSString stringWithFormat:@"%@元",amout];
    else
        label.text = [NSString stringWithFormat:@"累计%@元",amout];
    label.frame = CGRectMake(0, 0, 200, 30);
    CGPoint center = CGPointMake(0, 0);
    
    NSInteger imgWidth = self.imageView.frame.size.width;
    if(type == RewardType_czjl){
        center = CGPointMake(imgWidth * 0.32, imgWidth * 0.9683);//0.32
//#ifdef QQHB
//        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.9683);//0.32
//#endif
    }
    else if(type == RewardType_yqhycz)
        center = CGPointMake(imgWidth * 0.33, imgWidth * 0.9287);
    else if(type == RewardType_ztlsyj)
        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.974);
    else if(type == RewardType_bzsz)
        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.93);
    label.center = center;

    [self.imageView addSubview:label];
    
    BOOL va = (type == RewardType_yqhycz || type == RewardType_czjl);
//#ifdef QQHB
//    va = (type == RewardType_yqhycz);
//#endif
    if(va){
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize2:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_X(255, 177, 2);
//        label.shadowColor = Color_9;
//        label.shadowOffset = CGSizeMake(0, 1);
        NSString* amout= STR_TO_AmountFloatSTR(self.moneyDic[@"two"]);
        if(type == RewardType_czjl)
            label.text = [NSString stringWithFormat:@"已领取%@元",amout];
        else
            label.text = [NSString stringWithFormat:@"累计%@元",amout];
        label.frame = CGRectMake(0, 0, 200, 30);
        CGPoint center = CGPointMake(0, 0);
        NSInteger type = [self.infoDic[@"type"] integerValue];
        if(type == RewardType_czjl)
            center = CGPointMake(imgWidth * 0.686, imgWidth * 0.9683);
        else if(type == RewardType_yqhycz)
            center = CGPointMake(imgWidth * 0.693, imgWidth * 0.9287);
        label.center = center;
        [self.imageView addSubview:label];
    }

    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activityIcon1"]];
    iconImage.frame = CGRectMake(0, 0, 50, 50);
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    iconImage.clipsToBounds = YES;
    [self.imageView addSubview:iconImage];
    center = CGPointMake(0, 0);
    if(type == RewardType_czjl){
        center = CGPointMake(imgWidth * 0.32, imgWidth * 0.78);
//#ifdef QQHB
//        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.78);
//#endif
    }
    else if(type == RewardType_yqhycz)
        center = CGPointMake(imgWidth * 0.33, imgWidth * 0.7553);
    else if(type == RewardType_ztlsyj)
        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.8046);
    else if(type == RewardType_bzsz)
        center = CGPointMake(imgWidth * 0.5, imgWidth * 0.752);
    iconImage.center = center;
    [self.aniObjArray addObject:iconImage];

     if(va){
         UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activityIcon1"]];
         iconImage.frame = CGRectMake(0, 0, 50, 50);
         iconImage.contentMode = UIViewContentModeScaleAspectFit;
         iconImage.clipsToBounds = YES;
         [self.imageView addSubview:iconImage];
         center = CGPointMake(0, 0);
         if(type == RewardType_czjl)
             center = CGPointMake(imgWidth * 0.686, imgWidth * 0.78);
         else if(type == RewardType_yqhycz)
             center = CGPointMake(imgWidth * 0.693, imgWidth * 0.7553);
         iconImage.center = center;
         [self.aniObjArray addObject:iconImage];
     }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController.navigationBarHidden == NO)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}
@end
