//
//  PreLoginVCViewController.m
//  Project
//
//  Created by Aalto on 2019/4/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "PreLoginVC.h"
#import "UIView+AZGradient.h"
#import "MsgHeaderView.h"
#import "WebViewController.h"
@interface PreLoginVC ()
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)UIImageView* decorIv3;
@property (nonatomic, strong) UIButton* decorIv;
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;
@end

@implementation PreLoginVC

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_X(232, 232,232);
    _funcBtns = [NSMutableArray array];
//    UIImage* decorImage = [UIImage imageNamed:@""];//preloginTop
    self.decorIv = [[UIButton alloc]init];
    [self.view addSubview:self.decorIv];
    [self.decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.mas_equalTo(self.view.mas_centerX); make.leading.trailing.equalTo(self.view);
        //        make.top.mas_equalTo(self.view.mas_top).offset([FunctionManager isIphoneX]? [FunctionManager statusBarHeight]:0);
        //        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        
        //        make.right.equalTo(self.view.mas_right).offset(-14);
        //        make.top.mas_equalTo(self.view.mas_top).offset([FunctionManager isIphoneX]? [FunctionManager statusBarHeight]+14:14);
        //        make.size.mas_equalTo(CGSizeMake(69, 82));
        make.top.left.right.equalTo(self.view);
        make.height.offset(44 + FunctionManager.statusBarHeight);
    }];
    self.decorIv.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    [self.decorIv setTitle:@"登录注册" forState:UIControlStateNormal];
    [self.decorIv setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.decorIv.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    //    [decorIv setContentMode:UIViewContentModeScaleAspectFill];
    self.decorIv.clipsToBounds = YES;
    //    self.decorIv.image = decorImage;
    [self.decorIv az_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe3366),HEXCOLOR(0xff733d)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    self.decorIv.userInteractionEnabled = YES;
    
    [self createTvView];
    
//    UIImage* decorImage3 = [UIImage imageNamed:@""];//preloginBottom
    UIImage* decorImage3 = [UIImage new];
    self.decorIv3 = [[UIImageView alloc]init];
    [self.view addSubview:self.decorIv3];
    [self.decorIv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset([FunctionManager isIphoneX]? -[FunctionManager tabBarHeight]:-0); make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kGETVALUE_HEIGHT(720, 143, SCREEN_WIDTH)));
    }];
    [self.decorIv3 setContentMode:UIViewContentModeScaleAspectFill];
    self.decorIv3.clipsToBounds = YES;
    self.decorIv3.image = decorImage3;
    self.decorIv3.userInteractionEnabled = YES;
    
    
    [self layoutPublicLoginAndRegisterBtn];
}

- (void)layoutPublicLoginAndRegisterBtn{
    UIView* bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {; make.top.equalTo(self.view.mas_top).offset(kGETVALUE_HEIGHT(316, 174, SCREEN_WIDTH - 2*15)+120);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@115);
    }];
    
    NSArray* subtitleArray =@[@"登录",@"注册"];
    for (int i = 0; i < subtitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+1;
        
        button.titleLabel.font = [UIFont systemFontOfSize2:18];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        //        [button az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [bgView addSubview:button];
        [_funcBtns addObject:button];
        //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:15 leadSpacing:0 tailSpacing:0];
    //withFixedItemLength:44 leadSpacing:0 tailSpacing:0];
    //
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    //    [self.view layoutIfNeeded];
    UIButton* bt2 =_funcBtns.firstObject;
    [bt2 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [bt2 az_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe3366),HEXCOLOR(0xff733d)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    
    UIButton* bt3 =_funcBtns.lastObject;
    bt3.backgroundColor =  [UIColor whiteColor];
    [bt3 setTitleColor:COLOR_X(51, 51,51) forState:UIControlStateNormal];
    
}
- (void)funAdsButtonClickItem:(UIButton*)button{
    //    if (self.block)
    //    {
    //        self.block(@(button.tag),button);
    //    }
    EnumActionTag type = button.tag;
    switch (type) {
        case EnumActionTag1:
        {
            CDPush(self.navigationController, CDVC(@"LoginViewController"), YES);
        }
            break;
        case EnumActionTag2:
        {
            CDPush(self.navigationController, CDVC(@"RegisterViewController"), YES);
        }
            break;
        default:
            break;
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}


-(void)createTvView{
//    UIImage* decorImage2 = [UIImage imageNamed:@""];//preloginMid
    UIImage* decorImage2 = [UIImage new];
    UIImageView* decorIv2 = [[UIImageView alloc]init];
    [self.view addSubview:decorIv2];
    [decorIv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        //        make.leading.trailing.equalTo(self.view);
        
        make.top.equalTo(self.decorIv.mas_bottom).offset(-10);
        //        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kGETVALUE_HEIGHT(692, 660, SCREEN_WIDTH)));
        make.size.mas_equalTo(CGSizeMake(314, 291));
    }];
    [decorIv2 setContentMode:UIViewContentModeScaleAspectFill];
    decorIv2.clipsToBounds = YES;
    decorIv2.image = decorImage2;
    decorIv2.userInteractionEnabled = YES;
    
    //    CGFloat sdx =  49;
    //    CGFloat sdy = 137.5;
    //    CGFloat sdw = SCREEN_WIDTH -2*sdx;
    //    CGFloat sdh = kGETVALUE_HEIGHT(765, 427, sdw);
    
    //    CGFloat sdx =  47;
    //    CGFloat sdy = 90;
    //    CGFloat sdw = 220;
    //    CGFloat sdh = 150;
    NSDictionary *object = (NSDictionary*)[[FunctionManager sharedInstance] getCacheDataByKey:kLoginBannerModel];
    if (object!=nil) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            [self richElementsInView:model];
        }else{
            [self richElementsInView:nil];
        }
    }else{
        [self richElementsInView:nil];
    }
    
    
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeLogin WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            [[FunctionManager sharedInstance] setCacheDataWithKey:kLoginBannerModel data:object];
            
            [weakSelf richElementsInView:model];
            
        }else{
            [weakSelf richElementsInView:nil];
        }
    } fail:^(id object) {
        [weakSelf richElementsInView:nil];
    }];
    
    
}

- (void)richElementsInView:(BannerModel*)model{
    CGFloat sdx =  15;
    CGFloat sdy = 90;
    CGFloat sdw = SCREEN_WIDTH - 2*15;
    CGFloat sdh = kGETVALUE_HEIGHT(316, 174, sdw);
    for (UIView* view in [self.view subviews]) {
        if (view.tag == 200) {
            [view removeFromSuperview];
        }
    }
    MsgHeaderView * uploadImageHV = [[MsgHeaderView alloc]initWithFrame:CGRectMake(sdx, sdy, sdw, sdh) WithLaunchAndLoginModel:model.data WithOccurBannerAdsType:OccurBannerAdsTypeLogin];
    uploadImageHV.tag = 200;
    [self.view addSubview:uploadImageHV];
    uploadImageHV.layer.masksToBounds = YES;
    
    uploadImageHV.layer.cornerRadius = 6;
    uploadImageHV.layer.borderColor = [UIColor whiteColor].CGColor;
    uploadImageHV.layer.borderWidth = 6;
    
    [uploadImageHV actionBlock:^(id data) {
        BannerItem* item = data;
        [self fromBannerPushToVCWithBannerItem:item isFromLaunchBanner:NO];        
    }];
}

@end
