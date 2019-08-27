//
//  AppDelegate+Notificcation.h
//  Project
//
//  Created by 汤姆 on 2019/8/6.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
//@protocol notificcationDelegate <NSObject>
//
//- (void)notificcationDict:(NSDictionary *)dict;
//
//@end
@interface AppDelegate (Notificcation)
/** 通知的代理*/
//@property (nonatomic, weak) id<notificcationDelegate> nDelegate;
/**设置本地通知*/
- (void)getNotificationSettings;
@end

NS_ASSUME_NONNULL_END
