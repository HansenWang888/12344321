//  Created by hansen 



#import "YEBAccountInfoModel.h" 

@implementation YEBAccountInfoModel 



+ (NSDictionary<NSString *,id> *)mj_replacedKeyFromPropertyName {



    return @{


            @"m_balance" : @"balance",
            @"m_rollInMinMoney" : @"rollInMinMoney",
            @"m_rollInMaxMoney" : @"rollInMaxMoney",
            @"m_rollOutMaxMoney" : @"rollOutMaxMoney",
            @"m_thirtyEarnings" : @"thirtyEarnings",
            @"m_totalMoney" : @"totalMoney",
            @"m_payPassword" : @"payPassword",
            @"m_rollOutMinMoney" : @"rollOutMinMoney",
            @"m_sevenDyr" : @"sevenDyr",
            @"m_totalEarnings" : @"totalEarnings",

    };
}

@end