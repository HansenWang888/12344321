//  Created by hansen 



#import "YEBFinancialInfoModel.h" 

@implementation YEBFinancialInfoModel 



+ (NSDictionary<NSString *,id> *)mj_replacedKeyFromPropertyName {



    return @{


            @"m_id" : @"id",
            @"m_createTime" : @"createTime",
            @"m_delFlag" : @"delFlag",
            @"m_lastUpdateBy" : @"lastUpdateBy",
            @"m_type" : @"type",
            @"m_userId" : @"userId",
            @"m_createBy" : @"createBy",
            @"m_lastUpdateTime" : @"lastUpdateTime",
            @"m_money" : @"money",

    };
}

@end