//
//  AppModel.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

//@class UserInfo;

@interface AppModel : NSObject<NSCoding,NSCopying>

@property (nonatomic ,assign) BOOL turnOnSound;///<声音
//@property (nonatomic ,strong) UserInfo *user;///<用户信息

/**
 用户信息
 */
@property (nonatomic ,strong) UserInfo *userInfo;///<用户信息

@property (nonatomic ,assign) NSInteger unReadCount;  ///< 未读总消息
@property (nonatomic ,assign) NSInteger friendUnReadTotal;  // 好友未读总消息
//@property (nonatomic ,assign) NSInteger customerServiceUnReadTotal;  // 客服未读总消息
@property (nonatomic ,strong) NSDictionary *commonInfo;
@property (nonatomic ,copy) NSString *appClientIdInCommonInfo;
@property (nonatomic ,copy) NSString *encRSAPubKey;
@property (nonatomic ,copy) NSString *publicKey;
@property (nonatomic ,copy) NSString *ruleString;
@property (nonatomic ,copy) NSString *randomly16Key;
@property (nonatomic ,strong) NSDictionary *noticeArray;
@property (nonatomic ,strong) NSMutableAttributedString*  noticeAttributedString;
@property (nonatomic ,copy) NSString *serverUrl;
@property (nonatomic ,copy) NSString *authKey;

// NO 正式版    YES 测试版
@property (nonatomic ,assign) BOOL debugMode;
// 我加入的群id
@property (nonatomic ,strong) NSArray *myGroupArray;
// 我的好友列表
@property (nonatomic ,strong) NSDictionary *myFriendListDict;
// 我的客服列表
@property (nonatomic ,strong) NSDictionary *myCustomerServiceListDict;

@property(nonatomic, assign) NSInteger chatType;
/**群组,是否是自建群*/
@property (nonatomic, assign) BOOL officeFlag;
+ (instancetype)shareInstance;
- (void)saveAppModel;///<登录存档
- (void)logout;///<退出清理
- (UIViewController *)rootVc;
- (void)initSetUp;
-(void)reSetRootAnimation:(BOOL)b;
-(void)reSetTabBarAsRootAnimation;
-(NSArray *)ipArray;


@end
