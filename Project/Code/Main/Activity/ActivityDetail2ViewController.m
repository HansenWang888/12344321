//
//  ActivityDetail2ViewController.m
//  Project
//
//  Created by fangyuan on 2019/3/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityDetail2ViewController.h"
#import "ActivityDetailCell.h"
#import "UIView+AZGradient.h"
#import "UIImageView+WebCache.h"

@interface ActivityDetail2ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
}
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *getButton;
@property(nonatomic,strong)NSMutableArray *aniObjArray;
@property(nonatomic,strong)NSDictionary *rewardDic;
@property(nonatomic,strong)UIView *starView;
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ActivityDetail2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BaseColor;
    self.type = [self.infoDic[@"type"] integerValue];
    if(self.type == RewardType_fbjl){
        [self.view az_setGradientBackgroundWithColors:@[COLOR_X(253, 172, 105),COLOR_X(246, 83, 76)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }else if(self.type == RewardType_qbjl){
        [self.view az_setGradientBackgroundWithColors:@[COLOR_X(103, 204, 130),COLOR_X(183, 185, 67)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }else{
        [self.view az_setGradientBackgroundWithColors:@[HexColor(@"#187bea"),HexColor(@"#7bebe4")] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }
    
    self.aniObjArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = [ActivityDetailCell cellHeight];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    _tableView.tableHeaderView = [self headView];
    SVP_SHOW;
    [self getData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@20);
        make.width.height.equalTo(@48);
    }];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)update{
    NSMutableArray *newArray = [NSMutableArray array];
    for (UIView *view in self.aniObjArray) {
        CGPoint point = [view.superview convertPoint:view.center toView:self.view];
        if(point.y < 0 || point.y > self.view.frame.size.height)
            continue;
        if(view.hidden)
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
        imgView.frame = CGRectMake(0, view.frame.size.height, imgView.image.size.width, imgView.image.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            imgView.frame = CGRectMake(0, -imgView.image.size.height, imgView.image.size.width, imgView.image.size.height);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }else if([view isKindOfClass:[UIButton class]]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuang1"]];
        imgView.alpha = 0.9;
        [view addSubview:imgView];
        imgView.frame = CGRectMake(view.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        [UIView animateWithDuration:0.6 animations:^{
            imgView.frame = CGRectMake(-imgView.bounds.size.width, 0, imgView.image.size.width, view.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    ActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ActivityDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.aniObjArray = self.aniObjArray;
        [cell initView];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    NSInteger count = [dic[@"count"] integerValue];
    float sum = [dic[@"sum"] floatValue];
    float threshold = [dic[@"threshold"] floatValue];
    float rate = 0;
    if(threshold > 0)
        rate = sum/threshold;
    [cell setTitle:dic[@"description"] percentString:[NSString stringWithFormat:@"%@/%@",dic[@"sum"],dic[@"threshold"]] percent:rate reward:STR_TO_AmountFloatSTR(dic[@"free"]) lottery:INT_TO_STR(count)];
    [cell setBtnTitle:dic[@"strStatus"] status:[dic[@"status"] integerValue]];
    return cell;
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    if(self.type == RewardType_fbjl){
        [NET_REQUEST_MANAGER getActivityFaBaoListWithId:self.infoDic[@"id"] success:^(id object) {
            [weakSelf getDataBack:object];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else if(self.type == RewardType_qbjl){
        [NET_REQUEST_MANAGER getActivityQiaoBaoListWithId:self.infoDic[@"id"] success:^(id object) {
            [weakSelf getDataBack:object];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else{
        [NET_REQUEST_MANAGER getActivityJiujiJingListWithId:self.infoDic[@"id"] success:^(id object) {
            [weakSelf getDataBack:object];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}

-(void)getDataBack:(NSDictionary *)dict{
    SVP_DISMISS;
    self.rewardDic = dict[@"data"];
    self.dataArray = self.rewardDic[@"activityAwardList"];
    BOOL isGet = [self.rewardDic[@"isTodayGet"] boolValue];
    if(self.getButton){
        if(!isGet){
            [self.getButton setTitle:[NSString stringWithFormat:@"奖励¥%@ 领取",STR_TO_AmountFloatSTR(self.rewardDic[@"canGetMoney"])] forState:UIControlStateNormal];
            [self.getButton setTitleColor:COLOR_X(255, 60, 60) forState:UIControlStateNormal];
            [self.getButton setBackgroundImage:[UIImage imageNamed:@"getRewardBtn"] forState:UIControlStateNormal];
            if(![self.aniObjArray containsObject:self.getButton])
                [self.aniObjArray addObject:self.getButton];
        }
        else{
            [self.getButton setTitle:[NSString stringWithFormat:@"奖励¥%@ 已领取",STR_TO_AmountFloatSTR(self.rewardDic[@"canGetMoney"])] forState:UIControlStateNormal];
            [self.getButton setTitleColor:COLOR_X(255, 255, 255) forState:UIControlStateNormal];
            [self.getButton setBackgroundImage:[UIImage imageNamed:@"getRewardBtn2"] forState:UIControlStateNormal];
            self.getButton.userInteractionEnabled = NO;
            if([self.aniObjArray containsObject:self.getButton])
                [self.aniObjArray removeObject:self.getButton];
        }
    }
    
    [self.tableView reloadData];
}

-(UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    view.backgroundColor = [UIColor clearColor];

    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(9, 0, SCREEN_WIDTH - 20, 0);
    [view addSubview:imgView];
    imgView.backgroundColor = [UIColor clearColor];
    WEAK_OBJ(weakSelf, self);
    self.imageView = imgView;
    [self addStar:imgView];
    NSLog(@"%@",self.infoDic[@"headImg"]);
[imgView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"headImg"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf updateImageShow];
    }];
    return view;
}

-(void)updateImageShow{
    UIImage *image = self.imageView.image;
    UIImageView *imgView = self.imageView;
    UIView *view = self.imageView.superview;
    NSInteger width = image.size.width;
    NSInteger height = image.size.height;
    float rate = width/imgView.frame.size.width;
    NSInteger newHeight = height / rate;
    CGRect rect = imgView.frame;
    rect.size.height = newHeight;
    imgView.frame = rect;
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, newHeight + 6);
    self.tableView.tableHeaderView = view;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 44);
    CGPoint point = CGPointMake(SCREEN_WIDTH/2.0, view.frame.size.height - 42);
    btn.center = point;
    btn.clipsToBounds = YES;
    [btn setTitleColor:COLOR_X(255, 60, 60) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize2:16];
    self.getButton = btn;
    if(self.rewardDic){
        BOOL isGet = [self.rewardDic[@"isTodayGet"] boolValue];
        if(!isGet){
            [self.getButton setTitle:[NSString stringWithFormat:@"奖励¥%@ 领取",STR_TO_AmountFloatSTR(self.rewardDic[@"canGetMoney"])] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_X(255, 60, 60) forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"getRewardBtn"] forState:UIControlStateNormal];
            [self.aniObjArray addObject:btn];
        }
        else{
            [self.getButton setTitle:[NSString stringWithFormat:@"奖励¥%@ 已领取",STR_TO_AmountFloatSTR(self.rewardDic[@"canGetMoney"])] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_X(255, 255, 255) forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"getRewardBtn2"] forState:UIControlStateNormal];
            self.getButton.userInteractionEnabled = NO;
        }
    }
    else
        [btn setTitle:@"请稍候" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getRewardAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

-(void)getRewardAction{
    WEAK_OBJ(weakSelf, self);
    [[AlertViewCus createInstanceWithView:nil] showWithText:@"是否领取奖励？" button1:@"取消" button2:@"领取" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1){
            SVP_SHOW;
            [NET_REQUEST_MANAGER getRewardWithId:self.infoDic[@"id"] type:self.type success:^(id object) {
                [weakSelf getData];
            } fail:^(id object) {
                [[FunctionManager sharedInstance] handleFailResponse:object];
            }];
        }
    }];
}

-(void)addStar:(UIView *)view{
    UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuangStar"]];
    [view addSubview:starView];
    CGPoint center = CGPointMake(view.frame.size.width/2.0, 140);
    starView.center = center;
//    self.starView = starView;
//    [self starViewAni];
}

-(void)starViewAni{
    [UIView animateWithDuration:0.5 delay:3.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:nil animations:^{
        self.starView.alpha = 1.0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.starView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self starViewAni];
        }];
    }];
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
