//  Created by hansen 



#import "DYTableView.h"
#import <MJExtension.h>

@interface YEBFinancialInfoModel : DYTableViewModel



        /**0*/
        @property (nonatomic, copy) NSNumber *m_id;

        /***/
        @property (nonatomic, copy) NSString *m_createTime;

        /**删除标识*/
        @property (nonatomic, copy) NSNumber *m_delFlag;

        /**0*/
        @property (nonatomic, copy) NSNumber *m_lastUpdateBy;

        /**1：转入 2：转出 3：收益*/
        @property (nonatomic, copy) NSNumber *m_type;

        /**0*/
        @property (nonatomic, copy) NSNumber *m_userId;

        /**0*/
        @property (nonatomic, copy) NSNumber *m_createBy;

        /***/
        @property (nonatomic, copy) NSString *m_lastUpdateTime;

        /**0*/
        @property (nonatomic, assign) double m_money;



@end
