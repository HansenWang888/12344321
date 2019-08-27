//
//  MessageItem.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageItem : NSObject


@property (nonatomic ,strong) NSNumber *waterBill; // 入群发包流水

@property (nonatomic ,copy) NSString *userId; //群主ID

@property (nonatomic ,assign) BOOL shutup;  // 是否禁言
@property (nonatomic ,copy) NSString *avatar;  //
@property (nonatomic ,copy) NSString *rule;  // 群规则
@property (nonatomic ,copy) NSString *ruleImg;  // 群规则图片
@property (nonatomic ,copy) NSString *orderNum; // 排序号
@property (nonatomic ,copy) NSString *notice; // 群公告
@property (nonatomic ,copy) NSString *nick;   // 群主昵称
@property (nonatomic ,copy) NSString *know;  // 群须知
@property (nonatomic ,copy) NSString *joinMoney; // 入群金额
@property (nonatomic ,copy) NSString *groupId; // ID,
@property (nonatomic ,copy) NSString *grabCount; // 入群抢红包个数

@property (nonatomic ,assign) NSInteger isDel;  // 是否删除
@property (nonatomic ,assign) NSInteger isActive;  // 是否正常
@property (nonatomic ,copy) NSString *delFlag;
@property (nonatomic ,copy) NSString *createTime; // 创建时间
@property (nonatomic ,copy) NSString *chatgId; // 群类型ID
@property (nonatomic ,copy) NSString *chatgName; // 群组名称
@property (nonatomic ,copy) NSString *img; // 群图片

@property (nonatomic ,assign) NSInteger talkTime; // 说话时间
@property (nonatomic ,copy) NSString *password; // 加群密码

@property (nonatomic ,copy)NSString *howplay;//玩法
@property (nonatomic ,copy)NSString *howplayImg;//玩法图片

@property (nonatomic,assign)NSInteger groupNum;//成员数量基数

/**
 是否是自建群,no是自建群
 */
@property (nonatomic, assign) BOOL officeFlag;

// 红包过期时间
@property (nonatomic,copy) NSString *rpOverdueTime;
// 普通红包最大包数
@property (nonatomic,copy) NSString *simpMaxCount;
// 普通红包最小包数
@property (nonatomic,copy) NSString *simpMinCount;
// 普通红包最大金额
@property (nonatomic,copy) NSString *simpMaxMoney;
// 普通红包最小金额
@property (nonatomic,copy) NSString *simpMinMoney;

// 最大包数
@property (nonatomic,copy) NSString *maxCount;
// 最大金额
@property (nonatomic,copy) NSString *maxMoney;
// 最小包数
@property (nonatomic,copy) NSString *minCount;
// 最小金额
@property (nonatomic,copy) NSString *minMoney;
@property (nonatomic,strong) NSString *attr;


// 最后更新人
@property (nonatomic,copy) NSString *lastUpdateBy;
// 最后更新时间
@property (nonatomic,copy) NSString *lastUpdateTime;
// 群类型 0 福利  1、扫雷群；2、牛牛群  3 禁抢
@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,assign) BOOL isMyJoined;


@property (nonatomic ,copy) NSString *localImg;

@property (nonatomic ,copy) NSData *localImgData;

@end
