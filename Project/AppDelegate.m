//
//  AppDelegate.m
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "AppDelegate.h"
#import "WXManage.h"
#import "AFNetworkReachabilityManager.h"
#import "NSData+AES.h"
#import "GTMBase64.h"
#import "FYIMManager.h"
#import <objc/runtime.h>
#import "MTA.h"
#import "MessageSingle.h"
#import "PushMessageModel.h"
#import "WHC_ModelSqlite.h"
#import "BANetManager_OC.h"
#import "FYContacts.h"
#import <IQKeyboardManager.h>
#import "FYIMMessageManager.h"
#import "AppDelegate+Notificcation.h"
#import "DYBuglyConfig.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"😢😢😢😢😢😢😢服务器地址 %@",kServerUrl);
    NSLog(@"微信key %@ 微信secret %@",kWXKey,kWXSecret);
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self check];
    [self getAppConfig];

    // 热更新加载
    if(kMTAKey.length > 1)
        [MTA startWithAppkey:kMTAKey];
    [self gethistoryMessageNum];
    [FYIMManager shareInstance];
    
    [DYBuglyConfig configBugly];
#if DEBUG
#else
    [NSThread sleepForTimeInterval:2.0];
#endif
    
    [self applicationRoot];
    [self getNotificationSettings];
    return YES;
}


- (void)getAppConfig {
    [[NetRequestManager sharedInstance] requestAppConfigWithSuccess:^(id object) {
        
    } fail:^(id object) {
        
    }];
}

- (void)applicationRoot {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = CDCOLOR(245, 245, 245);
    self.window.rootViewController = [[AppModel shareInstance] rootVc];
//    self.window.rootViewController = [[BaseNewTabBarController alloc]init];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self AFNReachability];
    [[AppModel shareInstance] initSetUp];
    
    if([AppModel shareInstance].userInfo.isLogined) {
        [[NetRequestManager sharedInstance] requestSystemNoticeWithSuccess:nil fail:nil];
        [self queryContactsData];
    }
}


- (void)queryContactsData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/friend/getContact"];
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] != nil && [[response objectForKey:@"code"] integerValue] == 0) {
            [strongSelf loadLocalData:[response objectForKey:@"data"]];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }

    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)loadLocalData:(NSDictionary *)dataDict
{
    NSArray *serviceMembersArray = (NSArray *)[dataDict objectForKey:@"serviceMembers"];
    NSArray *superiorArray = (NSArray *)[dataDict objectForKey:@"superior"];
    NSArray *subordinateArray = (NSArray *)[dataDict objectForKey:@"subordinate"];
    
    NSMutableDictionary *myFriendListDictTemp = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *myServiceListDictTemp = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < serviceMembersArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:serviceMembersArray[i]];
        contact.contactsType = 3;
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
        [myServiceListDictTemp setObject:contact forKey:contact.userId];
    }
    [AppModel shareInstance].myCustomerServiceListDict = [myServiceListDictTemp copy];

    for (int i = 0; i < superiorArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:superiorArray[i]];
        contact.contactsType = 4;
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
    }

    for (int i = 0; i < subordinateArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:subordinateArray[i]];
        contact.contactsType = 2;
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
    }
    
    [AppModel shareInstance].myFriendListDict = myFriendListDictTemp;
}
//本地通知处理

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    // 获取通知所带的数据
//    NSString *message = [notification.userInfo objectForKey:@"akey"];
//    //可按需求进行数据处理
//    NSLog(@"%@",message);
//    // 更新显示的消息个数
//    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    badge--;//读了一个，所以减1
//    badge = badge >= 0 ? badge : 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""] stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    // 请检查App的APNs的权限设置，更多内容可以参考文档
    // http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败");
    NSLog(@"ERROR：%@", error);
#endif
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
  return [WXManage handleOpenURL:url];
    
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXManage handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WXManage handleOpenURL:url];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}



//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//
//    // 获取通知所带的数据
////    NSString *message = [notification.userInfo objectForKey:@"akey"];
////    //可按需求进行数据处理
////    NSLog(@"%@",message);
////    // 更新显示的消息个数
////    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
////    badge--;//读了一个，所以减1
////    badge = badge >= 0 ? badge : 0;
////    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 前台收到远程通知:%@", body);
//
//    } else {
//        // 判断为本地通知
//        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
//
//    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
- (void)gethistoryMessageNum {
    
    NSInteger oldMessageNum = 0;
    if ([AppModel shareInstance].unReadCount > 0) {
        oldMessageNum = [AppModel shareInstance].unReadCount;
    }
    [AppModel shareInstance].unReadCount = 0;

    NSString *queryWhere = [NSString stringWithFormat:@"userId='%@'",[AppModel shareInstance].userInfo.userId];
    NSArray *userGroupArray = [WHC_ModelSqlite query:[PushMessageModel class] where:queryWhere];

    for (NSInteger index = 0; index < userGroupArray.count; index++) {
        PushMessageModel *pmModel = (PushMessageModel *)userGroupArray[index];
        
        if (pmModel != nil && pmModel.sessionId != nil && ![pmModel.sessionId isEqualToString:@""]) {
//            [AppModel shareInstance].unReadCount += pmModel.number;
            
            NSString *queryId = [NSString stringWithFormat:@"%@-%@",pmModel.sessionId,[AppModel shareInstance].userInfo.userId];
            [MessageSingle shareInstance].allUnreadMessagesDict[queryId] = pmModel;
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestJSPatchInfo];
    [[FunctionManager sharedInstance] checkVersion:NO];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)requestJSPatchInfo {
    NSString *requestJStime = [[NSUserDefaults standardUserDefaults] valueForKey:@"requestJStime"];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    CGFloat timeSpace = currentTime - [requestJStime floatValue];
    if (requestJStime.length==0 | timeSpace > 3600) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",currentTime] forKey:@"requestJStime"];
    }
}

#pragma mark AFNReachability
-(void)AFNReachability{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                SVP_ERROR_STATUS(@"当前网络错误，请检查网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoNetworkNotification object:nil];
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [[NSNotificationCenter defaultCenter] postNotificationName:kYesNetworkNotification object:nil];
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

//用来防止建新的app时忘了配置某些参数
-(void)check{
#if DEBUG
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *wKey = [[[infoPlist valueForKeyPath:@"CFBundleURLTypes.CFBundleURLSchemes"] lastObject] lastObject];
    NSCAssert([wKey isEqualToString:kWXKey],@"info.plist里微信key配置不一致");
#endif
}
@end
