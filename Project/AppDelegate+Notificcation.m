//
//  AppDelegate+Notificcation.m
//  Project
//
//  Created by 汤姆 on 2019/8/6.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AppDelegate+Notificcation.h"
#import <UserNotifications/UserNotifications.h>
#import "MessageSingle.h"
#import "PushMessageModel.h"
#import "FYIMMessageManager.h"
#import "FYContacts.h"
#import "ChatViewController.h"
#import "NSObject+SSAdd.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end
@implementation AppDelegate (Notificcation)
//注册本地通知
- (void)getNotificationSettings{
    
    // 注册通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"本地通知:%@",granted ? @"YES":@"NO");
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    }
    
}
//APP在后台时
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self setModelSqlite];
    /** 客户端是通过心跳来和服务端保持连接，心跳是由定时器触发的，当我退到后台以后，定时器方法被挂起，那么通过如下设置来在后台运行定时器
     */
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask= UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,  0  ),^{
        dispatch_async(dispatch_get_main_queue(),^{
            if  (bgTask != UIBackgroundTaskInvalid)  {
                bgTask= UIBackgroundTaskInvalid;
            }
        });
    });
    [FYIMMessageManager shareInstance].mBlock = ^(NSDictionary * _Nonnull messageDict) {
        NSString *to = [NSString stringWithFormat:@"%@",messageDict[@"to"]];
        if (![[AppModel shareInstance].userInfo.userId isEqualToString:to]) {
            return ;
        }
        if ([messageDict[@"chatType"] integerValue] == 2) {
            [self getNotification:messageDict];
        }
    };
}

- (void)getNotification:(NSDictionary *)dict{
    
    if (@available(iOS 10.0, *)) {
        
        
        FYMessage *message = [FYMessage mj_objectWithKeyValues:dict];
        
        NSString *text;
        //判断是否是以 "{" 开头并且 "}"结尾
        if ([message.text hasPrefix:@"{"] && [message.text hasSuffix:@"}"]) {
            NSError * error;
            NSData * m_data = [message.text  dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:m_data options:NSJSONReadingMutableContainers error:&error];
            NSString *url = [NSString stringWithFormat:@"%@",dict[@"url"]];
            if ([url hasSuffix:@".png"] || [url hasSuffix:@".jpg"]|| [url hasSuffix:@".jpeg"]) {
                text = @"对方给您发了一张图片!";
            }
        }else{
            text = message.text;
        }
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:message.user.nick arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:text arguments:nil];
        //设置声音
        content.sound = [UNNotificationSound defaultSound];
        self.page += 1;
        content.badge = @(self.page);
        content.userInfo = dict;
        NSString *notificationId = [NSString stringWithFormat:@"projectLocalNotification%@",message.messageId];
        
        UNNotificationRequest *request = [UNNotificationRequest  requestWithIdentifier:notificationId content:content trigger:nil];
        //添加推送到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
        
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSLog(@"%@",notification);
}
//点击进入应用时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:response.notification.request.content.userInfo];

    [self performSelectorOnMainThread:@selector(puchvc:) withObject:dict waitUntilDone:YES];
    completionHandler();
}
- (void)puchvc:(NSDictionary *)dict{
    self.page = 0;
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dict];
    FYContacts *contact = [[FYContacts alloc]init];
    contact.sessionId = message.sessionId;
    contact.nick = message.user.nick;
    contact.avatar = message.user.avatar;
    contact.lastTimestamp = message.timestamp;
    contact.userId = message.user.userId;
    contact.accountUserId = message.toUserId;
    contact.name = message.user.nick;
    ChatViewController *chat = [ChatViewController privateChatWithModel:contact];
    chat.toContactsModel = contact;
    chat.hidesBottomBarWhenPushed = YES;
    
    [[self currentViewController].navigationController pushViewController:chat animated:YES];
}
- (void)test{}
//当应用在前台时，收到通知会触发这个代理方法；你可以在这个方法中对应用处于前台时接到通知做一些自己的处理

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){

//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
//    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
- (void)setModelSqlite{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[MessageSingle shareInstance].allUnreadMessagesDict];
    NSArray *arr = [dict allKeys];
    for (NSInteger i = 0; i < arr.count; i++) {
        PushMessageModel *model = (PushMessageModel *)[dict objectForKey:arr[i]];
        NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND userId='%@'",model.sessionId,[AppModel shareInstance].userInfo.userId];
        PushMessageModel *sqlModel = [[WHC_ModelSqlite query:[PushMessageModel class] where:query] firstObject];
        
        if (sqlModel) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite update:model where:query];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite insert:model];
            });
        }
        //        NSLog(@"%@ : %@", arr[i], [dict objectForKey:arr[i]]); // dic[arr[i]]
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *whereStr = @"deliveryState = 1";
        NSArray *modelArray = [WHC_ModelSqlite query:[FYMessage class] where:whereStr];
        for (NSInteger index =0; index < modelArray.count; index++) {
            FYMessage *message = (FYMessage *)modelArray[index];
            message.deliveryState = FYMessageDeliveryStateFailed;
            NSString *query = [NSString stringWithFormat:@"messageId='%@'",message.messageId];
            [WHC_ModelSqlite update:message where:query];
        }
        
        
    });
}
@end
