//
//  UserInfo.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户性别
 */
typedef NS_ENUM(NSInteger, FYUserGender) {
    /**
     *  未知性别
     */
    FYUserGenderUnknown,
    /**
     *  性别男
     */
    FYUserGenderMale,
    /**
     *  性别女
     */
    FYUserGenderFemale,
};



@interface UserInfo : NSObject<NSCoding>

@property(nonatomic, assign) BOOL isLogined;
// 用户ID
@property(nonatomic, copy) NSString *userId;
/**用户头像*/ 
@property(nonatomic, copy) NSString *avatar;
// 用户邮箱
@property(nonatomic, copy) NSString *email;
/**邀请码*/
@property(nonatomic, copy) NSString *invitecode;
// 用户电话
@property(nonatomic, copy) NSString *mobile;
// 用户性别
@property (nonatomic, assign) FYUserGender gender;
// 余额
@property(nonatomic, copy) NSString *balance;
// 创建时间
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *jointime;

// 是否是代理
@property(nonatomic, assign) NSInteger agentFlag;


@property(nonatomic,assign) BOOL managerFlag; // 是否管理员
@property(nonatomic,assign) BOOL groupowenFlag; // 是否是群主
@property (nonatomic ,assign) BOOL innerNumFlag; // yes  内部号 不限制说话字符

// 3个月变更   如果有退出也会变更
@property(nonatomic, copy) NSString *token;
/**
 后台Token  + Ba
 */
@property(nonatomic, copy) NSString *fullToken;
@property(nonatomic, copy) NSString *nick;
@property(nonatomic, copy) NSString *userSalt;
@property(nonatomic, assign) NSInteger status;



//+ (void)getUserInfoObj:(id)obj
//               Success:(void (^)(NSDictionary *))success
//               Failure:(void (^)(NSError *))failue;

//-(void)saveToDisk;

@end

