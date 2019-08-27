//
//  Public.h
//  FreeFare
//
//  Created by wc on 14-4-29.
//  Copyright (c) 2014年 wc All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define INT_TO_STR(x) [NSString stringWithFormat:@"%ld",(long)x]
#define STR_TO_AmountFloatSTR(x) [NSString stringWithFormat:@"%.2f",[x doubleValue]]
#define NUMBER_TO_STR(a) [a isKindOfClass:[NSString class]]?a:[a stringValue]

#define MERGE_String(x,y)[NSString stringWithFormat:@"%@%@",x,y]

#define NOTIF_CENTER [NSNotificationCenter defaultCenter]

#define WEAK_OBJ(weakObj,obj) __weak __typeof(obj)weakObj = obj;


typedef void (^CallbackBlock)(id object);

#define NOTIF_LOGIN_BACK @"NOTIF_LOGIN_BACK"
#define NOTIF_LOGOUT_BACK @"NOTIF_LOGOUT_BACK"

#define NOTIF_UPDATE_USER_INFO @"NOTIF_UPDATE_USER_INFO"

typedef NS_ENUM(NSUInteger, ResultCode) {
    ResultCodeSuccess = 0,//成功
};

typedef NS_ENUM(NSInteger, GetSmsCodeFromVCType){
    GetSmsCodeFromVCNil,
    GetSmsCodeFromVCRegister ,
    GetSmsCodeFromVCResetPW,
    GetSmsCodeFromVCLoginBySMS,
    GetSmsCodeFromVCPayPW,
};

typedef NS_ENUM(NSInteger, RewardType){
    RewardType_nil,
    RewardType_bzsz = 6000,//豹子顺子奖励
    RewardType_ztlsyj = 5000,//直推流水佣金
    RewardType_yqhycz = 1110,//邀请好友充值
    RewardType_czjl = 1100,//充值奖励
    RewardType_ecjl = 1200,//二充奖励 未知类处理
    RewardType_fbjl = 3000,//发包奖励
    RewardType_qbjl = 4000,//抢包奖励
    RewardType_jjj = 7000,//救济金
    RewardType_zcdljl = 2100,//注册登录奖励
};



#define WXShareDescription [NSString stringWithFormat:@"我的邀请码是%@",[AppModel shareInstance].userInfo.invitecode]

#define PUSH_C(viewController,targetViewController,animation) targetViewController *vc = [[targetViewController alloc] init]; vc.hidesBottomBarWhenPushed = YES; [viewController.navigationController pushViewController:vc animated:animation];

#define HEXCOLOR(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1]
///<页面背景色
#define BaseColor HexColor(@"#F6F6F6")
///<导航栏背景色
#define Color_3 HexColor(@"#333333")
///<tab选项栏选中颜色
#define TABSelectColor HexColor(@"#a971fb")
///<分割线颜色
#define TBSeparaColor HexColor(@"#EBEBEB")
///<提交按钮颜色
#define MBTNColor HexColor(@"#FE3962")//ff3833  a971fb

#define MBTAColor(a) ApHexColor(@"#a971fb",a)
#define SexBack HexColor(@"#6cd1f1")

// 黑色
#define Color_0 HexColor(@"#1E1E1E")
#define Color_3 HexColor(@"#333333")
#define Color_6 HexColor(@"#666666")
#define Color_9 HexColor(@"#999999")
// 白色
#define Color_F HexColor(@"#FFFFFF")

#define kGETVALUE_HEIGHT(width,height,limit_width) ((limit_width)*(height)/(width))

// wx背景灰色
#define kBackgroundGrayColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]

#define COLOR_X(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#pragma mark - UserDefault
#define SetUserDefaultKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define SetUserBoolKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setBool:object forKey:key]

#define GetUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define GetUserDefaultBoolWithKey(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define DeleUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define UserDefaultSynchronize  [[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark - 沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString * const kJSPatchURL = @"https://www.520qun.com";

#define kSendRPTitleCellWidth 80


#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else
#define NSLog(FORMAT, ...) nil
#endif

#import "AABlock.h"
#import "FLAnimatedImage.h"
#import "NSObject+CDCategory.h"
#import "NSObject+CDExtension.h"
#import "CDProtocol.h"
#import "UIView+CDSDImage.h"
#import "CDFunction.h"
#import "UIButton+Ani.h"
#import "Masonry.h"

#import "CDTableModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"

#import "NetRequestManager.h"
#import "FunctionManager.h"

#import "Constants.h"
#import "Macros.h"
#import "VVAdaptUI.h"

#import "SuperViewController.h"

#import "AppModel.h"
//#import "UserModel.h"
#import "UserInfo.h"


#import "SVProgressHUD+CDHUD.h"
#import "UIAlertController+Cus.h"
#import "UIView+AZGradient.h"
#import "AlertViewCus.h"
#import "FYSDK.h"

#import "YBNotificationManager.h"
#import "BannerModel.h"
#import "UIView+SDExtension.h"
#import "SDCycleScrollView.h"
#import "AlertTipPopUpView.h"
#import "BaseVC.h"
#import "UITableView+YBGeneral.h"
#import "NSDictionary+dy_extension.h"

#import "NetworkConfig.h"

#import <ReactiveObjC.h>
