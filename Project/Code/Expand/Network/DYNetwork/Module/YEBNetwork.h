//
//  YEBNetwork.h
//  Project
//
//  Created by fangyuan on 2019/8/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "DYBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 余额宝相关接口
 */
@interface YEBNetwork : DYBaseNetwork

/**
 * 获取账户详情
 */
+ (instancetype)getAccountInfo;

/**
 * 获取收益报表
 */
+ (instancetype)getProfitList;

/**
 * 获取资金详情
 * @param type 类型：1：转入 2：转出 3：收益
 * @param isASC 是否升序
 *
 */
+ (instancetype)getFinancialInfoWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSInteger)type isASC:(BOOL)isASC;

/**
 * 转入
 */
+ (instancetype)shiftInWithMoney:(double)money password:(NSString *)password;

/**
 * 转出
 */
+ (instancetype)shiftOutWithMoney:(double)money password:(NSString *)password;

/**
 * 设置或者修改余额宝支付密码
 * 
 */
+ (instancetype)setOrModifyPassword:(NSString *)psw mobile:(NSString *)mobile code:(NSString *)code;


+ (instancetype)common;
@end

NS_ASSUME_NONNULL_END
