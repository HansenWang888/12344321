//
//  RechargeModel.h
//  Project
//
//  Created by Aalto on 2019/7/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RechargeType){
    RechargeType_gf = 1,//官方
    RechargeType_weiXin = 2,//微信
    RechargeType_zhiFuBao = 3,//支付宝
    RechargeType_yinLian = 4,//银联
    
    RechargeType_All = 888,//全部
};

typedef NS_ENUM(NSInteger, NewRechargeType){
    RechargeType_SerivceWX = 1,//微信
    RechargeType_SerivceZB = 2,//支付宝
    RechargeType_SerivceYL = 3,//银联
};

typedef NS_ENUM(NSInteger, GFRechargeType){
    RechargeType_GFWX = 1,//微信
    RechargeType_GFZB = 2,//支付宝
    RechargeType_GFBC = 3,//银行卡
};

@interface RechargeDetailListTypeData : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * value;
@end

@interface RechargeDetailListBankData : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * value;
@end

@interface RechargeDetailListItem : NSObject
@property (nonatomic, strong) RechargeDetailListBankData * bank;
@property (nonatomic, strong) RechargeDetailListTypeData * type;

@property (nonatomic, copy) NSString * bankAddress;
@property (nonatomic, copy) NSString * bankNum;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * delFlag;
@property (nonatomic, copy) NSString * enableFlag;
@property (nonatomic, copy) NSString * itemId;
@property (nonatomic, copy) NSString * maxAmount;
@property (nonatomic, copy) NSString * minAmount;
@property (nonatomic, copy) NSString * payeeName;
@property (nonatomic, copy) NSString * sortNum;
//第3方
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *allocationAmount;
@property (nonatomic, copy) NSString *url;
+ (NSDictionary *)mj_replacedKeyFromPropertyName;
@end

@interface RechargeListTypeData : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * value;
@end

@interface RechargeListData : NSObject
@property (nonatomic, copy) NSArray * detailList;
@property (nonatomic, strong) RechargeListTypeData * type;
+(NSDictionary *)objectClassInArray;
@end

@interface RechargeData : NSObject
@property (nonatomic, copy) NSArray *officeChanels;
@property (nonatomic, copy) NSArray * thirdpartyChanels;
+(NSDictionary *)objectClassInArray;
- (NSArray *)getChannelsArrData:(RechargeType)type;
- (NSArray *)getChannelsTitles:(RechargeType)type;
- (NSArray *)getChannelsContainTitles:(RechargeType)type;
- (NSArray *)getHorizontalTypeData:(RechargeType)type;
@end

@interface RechargeModel : NSObject
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) RechargeData * data;
@end
NS_ASSUME_NONNULL_END
