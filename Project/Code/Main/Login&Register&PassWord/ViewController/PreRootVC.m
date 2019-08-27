
//
//  GuideViewController.m
//  Project
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "PreRootVC.h"
#import "MsgHeaderView.h"
#import "WebViewController.h"
@interface PreRootVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    NSArray *_dataList;
}
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, assign) BOOL isFirstDisappearedSelf;
@end

@implementation PreRootVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    //    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    [self loginSuccessBlockMethod];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self distoryTimer];//when push web
    _isFirstDisappearedSelf = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _dataList = @
    [@[@"launchGuidePot1",
       @"launchGuidebj1",
       @"launchGuideMid1",
       @"launchGuideRight1",
       @"抢!抢!抢!发红包!抢红包!",
       @"好礼领不停,最高可领2888.88元"],
     
     @[@"launchGuidePot2",
       @"launchGuidebj2",
       @"launchGuideMid2",
       @"launchGuideRight2",
       @"邀请好友,充值奖励",
       @"万元红包,高额彩金,奖励多多,乐趣多多..."]
     ];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    //    layout.minimumLineSpacing = 0;
    //    layout.minimumInteritemSpacing = 0;
    //
    //    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    //    [self.view addSubview:_collectionView];
    //    _collectionView.delegate = self;
    //    _collectionView.dataSource = self;
    //    _collectionView.pagingEnabled = YES;
    //    _collectionView.backgroundColor = [UIColor whiteColor];
    //    _collectionView.showsVerticalScrollIndicator = NO;
    //    _collectionView.showsHorizontalScrollIndicator = NO;
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"class"];
    //
    NSDictionary *object = (NSDictionary*)[[FunctionManager sharedInstance] getCacheDataByKey:kLaunchBannerModel];
    if (object!=nil) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            [self richElementsInView:model];
            [self richTimerElementsInView:model];
        }else{
            [self removeViewJumpMainPage];
        }
    }else{
        [self removeViewJumpMainPage];
    }
    
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeLaunch WithPictureSpe:[FunctionManager isIphoneX]?OccurBannerAdsPictureTypeLarge:OccurBannerAdsPictureTypeNormal success:^(id object) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            [[FunctionManager sharedInstance] setCacheDataWithKey:kLaunchBannerModel data:object];
//            [self richElementsInView:model];
            for (UIView* view in [self.view subviews]) {
                if (view.tag == 200) {
                    MsgHeaderView* uploadImageHV = (MsgHeaderView*)view;
                    [uploadImageHV richElemenstsInView:model.data];
                    [uploadImageHV actionBlock:^(id data) {
                        BannerItem* item = data;
                        [self fromBannerPushToVCWithBannerItem:item isFromLaunchBanner:YES];
                    }];
                }
            }
            
            if (self.isFirstDisappearedSelf) {
                [self distoryTimer];
            }
        }else{
            [self removeViewJumpMainPage];
        }
    } fail:^(id object) {
        [self removeViewJumpMainPage];
    }];
    
}

- (void)removeViewJumpMainPage{
    for (UIView* view in [self.view subviews]) {
        if (view.tag == 200) {
            [view removeFromSuperview];
        }
    }
    [self action_done];
}

- (void)richElementsInView:(BannerModel*)model{
    
    MsgHeaderView * uploadImageHV = [[MsgHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithLaunchAndLoginModel:model.data WithOccurBannerAdsType:OccurBannerAdsTypeLaunch];
    uploadImageHV.tag = 200;
    [self.view addSubview:uploadImageHV];
    [uploadImageHV actionBlock:^(id data) {
        BannerItem* item = data;
        [self fromBannerPushToVCWithBannerItem:item isFromLaunchBanner:YES];
    }];
}

- (void)richTimerElementsInView:(BannerModel*)model{
    self.timeBtn = [UIButton new];
    [self.view addSubview:self.timeBtn];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    self.timeBtn.backgroundColor = ApHexColor(@"#000000",0.6);
    //    [self.timeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.timeBtn.layer.cornerRadius = 18;
    //    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    //    btn.layer.borderWidth = 1.0f;
    [self.timeBtn addTarget:self action:@selector(action_done) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset([FunctionManager isIphoneX]? [FunctionManager statusBarHeight]+20:20);
        make.height.equalTo(@(36));
        make.width.equalTo(@84);
    }];
    
    if (![FunctionManager isEmpty:model.data.carouselSecTime]) {
        [self startTimeCount:model.data.carouselSecTime];
    }
    
    else{
        self.timeBtn.enabled = true;
        [self.timeBtn setTitle:@"进入" forState:UIControlStateNormal];
    }
    
    
}
/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    }
//    else {
//        self.timeCount = 3;
//    }
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@ s 跳过",sec] forState:UIControlStateNormal];
    [self distoryTimer];
//    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    NSString *title = [NSString stringWithFormat:@" %ld s 跳过",(long)self.timeCount];
    //    [NSString timeWithSecond:self.timeCount]
    [self.timeBtn setTitle:title forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    if(self.timeCount <= 0)
    {
        [self distoryTimer];
        self.timeBtn.enabled = true;
//        [self.timeBtn setTitle:@"进入" forState:UIControlStateNormal];
        [self action_done];
        [self.timeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           
//            make.width.equalTo(@72);
        }];
        //        [self.timeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        //        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        //        if (self.block) {
        //            self.block(@(_timeBtn.tag), _timeBtn);
        //        }
        
    }
}

-(void)dealloc{
    [self distoryTimer];
}
//- (void) removeFromSuperview
//{
//    [super removeFromSuperview];
//    [self distoryTimer];
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"class" forIndexPath:indexPath];
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    
    
    UIImageView *iVBg = [UIImageView new];
    [cell.contentView addSubview:iVBg];
    iVBg.image = [UIImage imageNamed:_dataList[indexPath.row][1]];
    //    iVBg.contentMode = UIViewContentModeScaleAspectFit;
    [iVBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(cell.contentView);
        make.height.equalTo(@kGETVALUE_HEIGHT(828, 1207, SCREEN_WIDTH));
    }];
    
    UIImageView *midIv = [UIImageView new];
    [iVBg addSubview:midIv];
    midIv.image = [UIImage imageNamed:_dataList[indexPath.row][2]];
    midIv.contentMode = UIViewContentModeScaleAspectFit;
    [midIv mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(iVBg.mas_centerX);
        make.left.equalTo(iVBg.mas_left).offset(20);
        make.right.equalTo(iVBg.mas_right).offset(-20);
        make.bottom.equalTo(iVBg.mas_bottom).offset(-70);
        
    }];
    
    UIImageView *rightIv = [UIImageView new];
    [iVBg addSubview:rightIv];
    rightIv.image = [UIImage imageNamed:_dataList[indexPath.row][3]];
    rightIv.contentMode = UIViewContentModeScaleAspectFit;
    [rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iVBg).offset([FunctionManager isIphoneX]? [FunctionManager statusBarHeight]+20:20);
        make.right.equalTo(iVBg).offset(-20);
    }];
    
    UIImageView *potIv = [UIImageView new];
    [cell.contentView addSubview:potIv];
    potIv.image = [UIImage imageNamed:_dataList[indexPath.row][0]];
    potIv.contentMode = UIViewContentModeScaleAspectFit;
    [potIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView.mas_centerX); make.bottom.equalTo(cell.contentView.mas_bottom).offset(-20);
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset([FunctionManager isIphoneX]? -[FunctionManager tabBarHeight]-20:-20);
        
    }];
    
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cell.contentView addSubview:button1];
    button1.titleLabel.numberOfLines = 0;
    button1.titleLabel.font = [UIFont boldSystemFontOfSize2:25];
    [button1 setTitle:_dataList[indexPath.row][4] forState:UIControlStateNormal];
    [button1 setTitleColor:HEXCOLOR(0xf42231) forState:UIControlStateNormal];
    button1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView.mas_centerX); make.top.equalTo(iVBg.mas_bottom).offset(3);
        
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [cell.contentView addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize2:15];
    button.titleLabel.numberOfLines = 0;
    [button setTitle:_dataList[indexPath.row][5] forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xf42231) forState:UIControlStateNormal];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView.mas_centerX); make.top.equalTo(button1.mas_bottom).offset(-3);
        
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self action_done];
    }
}

#pragma mark action
- (void)action_done{
    [self distoryTimer];
    //    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:[NSString appVersion]];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    //    [[AppModel shareInstance] reSetRootAnimation:NO];
    [[AppModel shareInstance] reSetTabBarAsRootAnimation];
}
@end
