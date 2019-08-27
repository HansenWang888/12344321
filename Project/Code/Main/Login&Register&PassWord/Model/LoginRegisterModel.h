//
//  RechargeModel.h
//  Project
//
//  Created by Aalto on 2019/7/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRegisterData : NSObject
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * itemId;
@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * loginUseEditable;
@property (nonatomic, copy) NSString * loginUseFlag;
@property (nonatomic, copy) NSString * loginValidFlag;

@property (nonatomic, copy) NSString * regRequireEditable;
@property (nonatomic, copy) NSString * regRequireFlag;
@property (nonatomic, copy) NSString * regShowEditable;
@property (nonatomic, copy) NSString *regShowFlag;
@property (nonatomic, copy) NSString *regUnqEditable;
+ (NSDictionary *)mj_replacedKeyFromPropertyName;
@end

@interface LoginRegisterModel : NSObject
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSArray * data;
+(NSDictionary *)objectClassInArray;
- (NSArray *)getRegisterTypes;
- (NSArray *)getLoginTypes;
@end
NS_ASSUME_NONNULL_END
