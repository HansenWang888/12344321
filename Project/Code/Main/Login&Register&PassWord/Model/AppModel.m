//
//  AppModel.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "AppModel.h"
#import "CDBaseNet.h"
#import "UserInfo.h"
#import "WXManage.h"
//#import "SqliteManage.h"
#import "LoginViewController.h"
#import "LoginBySMSViewController.h"
#import "BANetManager_OC.h"
#import "FYIMManager.h"
#import "PreLoginVC.h"
#import "PreRootVC.h"
#import "MessageNet.h"

static NSString *Path = @"COM.XMFX.path";

@implementation AppModel

    MJCodingImplementation

+ (void)load{
    [self performSelectorOnMainThread:@selector(shareInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)shareInstance{
    static AppModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                instance = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
                if(instance == nil){
                    instance = [[AppModel alloc] init];
                }
            } else {
                instance = [[AppModel alloc] init];
            }
            
        }
//        instance.turnOnSound = [RCIM sharedRCIM].disableMessageAlertSound;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger serverIndex = [[ud objectForKey:@"serverIndex"] integerValue];
        NSArray *arr = [instance ipArray];
        if(serverIndex >= arr.count)
            serverIndex = 0;
        NSDictionary *dic = arr[serverIndex];
        instance.serverUrl = dic[@"url"];
        instance.debugMode = [dic[@"isBeta"] boolValue];
        NSString *authKey = instance.commonInfo[@"app_client_id"];
        if(authKey)
            instance.authKey = [NSString stringWithFormat:@"%@",authKey];
        else
            instance.authKey = dic[@"baseKey"];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setTurnOnSound:(BOOL)Sound{ ///<YES关闭，No开启
    _turnOnSound = Sound;
}

- (void)saveAppModel {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
    [NSKeyedArchiver archiveRootObject:self toFile:filename];
}

-(UserInfo *)userInfo{
    if(_userInfo == nil)
        _userInfo = [[UserInfo alloc] init];
    return _userInfo;
}

- (void)logout {
    self.userInfo = [UserInfo new];

    [[FYIMManager shareInstance] userSignout];
    [AppModel shareInstance].unReadCount = 0;
    [[MessageNet shareInstance] destroyData];
    [[AppModel shareInstance] saveAppModel];
    [self reSetRootAnimation:YES];
//    [self reSetTabBarAsRootAnimation];
}

#pragma mark method

- (void)initSetUp {
    
    //开启消息撤回功能
//    [RCIM sharedRCIM].enableMessageRecall = YES;
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    //    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //svp
    [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
    [SVProgressHUD setMaximumDismissTimeInterval:1.2f];
    
    //去掉底部和适配11
    [[UITableView appearance] setTableFooterView:[UIView new]];
    [[UITableView appearance] setEstimatedSectionFooterHeight:0];
    [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    [[UITableViewCell appearance] setSelectionStyle:0];
    
    [[UIWindow appearance]setBackgroundColor:BaseColor];
    [[UIButton appearance]setExclusiveTouch:YES];
    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000,0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:Color_3];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize2:18],NSForegroundColorAttributeName:Color_F}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];
    if([AppModel shareInstance].debugMode){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 14)];
        label.text = [NSString stringWithFormat:@"%@  新IM",[AppModel shareInstance].serverUrl];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [[UINavigationBar appearance] addSubview:label];
    }
}

-(void)login{
    if([[[FunctionManager sharedInstance] currentViewController] isKindOfClass:[LoginBySMSViewController class]] || [[[FunctionManager sharedInstance] currentViewController] isKindOfClass:[LoginViewController class]])
    [self reSetRootAnimation:YES];
}

- (UIViewController *)rootVc{

    if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString appVersion]]) {
        return [[NSClassFromString(@"GuideViewController") alloc]init];
    }
    else{
        //        dispatch_semaphore_t signal = dispatch_semaphore_create(3);
        //        __block UIViewController* rVC = [UIViewController new];
        //
        //        [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeLaunch success:^(id object) {
        //            BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        //            if (model.data.records.count>0) {
        ////                NSDictionary* dic = @{
        ////                                      kArr:
        ////                                          @[
        ////                                              @{kImg:@"msg_banner1",kUrl:@"https://www.baidu.com"},
        ////                                              @{kImg:@"msg_banner2",kUrl:@"https://news.baidu.com"}
        ////                                              ]
        ////                                      };
        //                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"PreRootVC")alloc]init]];
        //                rVC = nav;
        //                dispatch_semaphore_signal(signal);
        //            }
        //        } fail:^(id object) {
        //            if ([AppModel shareInstance].user.isLogined) {
        //                rVC = [[NSClassFromString(@"BaseTabBarController")alloc]init];
        //
        //
        //
        //            }else{
        //                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController")alloc]init]];//PreLoginVC
        //                rVC = nav;
        //            }
        //            dispatch_semaphore_signal(signal);
        //
        //        }];
        //        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        //        return rVC;
        //    }
        if ([AppModel shareInstance].userInfo.isLogined) {
//
//            return [[NSClassFromString(@"BaseTabBarController")alloc]init];
            NSString *namespace = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];

            return [[NSClassFromString([NSString stringWithFormat:@"%@.%@",namespace,@"BaseNewTabBarController"]) alloc]init];
        }else{
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController")alloc]init]];//PreLoginVC//LoginViewController
            return nav;
        }

//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"PreRootVC")alloc]init]];//PreLoginVC
//        return nav;
    }

    
    //        return [[NSClassFromString(@"PreRootVC")alloc]init];
    
    
//            if ([AppModel shareInstance].user.isLogined) {
//                    return [[NSClassFromString(@"BaseTabBarController")alloc]init];
//    
//
//    
//            }else{
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController")alloc]init]];//PreLoginVC
//                return nav;
//            }
    
}

-(void)reSetRootAnimation:(BOOL)b{
    dispatch_async(dispatch_get_main_queue(),^{
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
            if (b) {
                [window.layer addAnimation:self.animation forKey:nil];
            }
        window.rootViewController = self.rootVc;
        
    });
    
}

-(void)reSetTabBarAsRootAnimation{

    dispatch_async(dispatch_get_main_queue(),^{
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if ([AppModel shareInstance].userInfo.isLogined == true) {
            [window.layer addAnimation:self.animation forKey:nil];
            window.rootViewController = [[NSClassFromString(@"BaseTabBarController") alloc] init];
//            NSString *namespace = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
//
//            window.rootViewController = [[NSClassFromString([NSString stringWithFormat:@"%@.%@",namespace,@"BaseNewTabBarController"]) alloc]init];
        }else{
            window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController") alloc] init]];
        }
        
    });
}


- (CATransition *)animation{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type =  @"cube";  //立方体效果
    
    //设置动画子类型
    animation.subtype = kCATransitionFromTop;
    return animation;
}

-(NSString *)serverUrl {
    return [self serverUrl2:_serverUrl];
}

-(NSString *)serverUrl2:(NSString *)url{
    url = [url stringByReplacingOccurrencesOfString:@"10.15" withString:@"10.95"];
    return url;
}

-(NSArray *)ipArray{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [ud objectForKey:@"ipArray"];
    NSDictionary *dic1 = @{@"url":kServerUrl, @"isBeta":@(NO),@"baseKey":kBaseKey};
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic1, nil];
    NSArray *testArr = [kServerJson mj_JSONObject];
    [array addObjectsFromArray:self.envirments];
    if(arr)
    [array addObjectsFromArray:arr];
    return array;
}
/**
 * 测试环境
 */
- (NSArray *)envirments {
    
    return @[
             @{@"url":@"http://gateway.wcqun.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://10.10.95.9:6000/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://api.wcqun.com/api/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://10.10.95.35:6000/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://10.10.95.201:16000/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://10.10.95.35:16000/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="}
             
             ];
    
}
/**
 * 商户号
 */
- (NSArray *)tenants {
    
    return @[@"100000",@"fy_pig_test",@"pigss"];
}


@end
