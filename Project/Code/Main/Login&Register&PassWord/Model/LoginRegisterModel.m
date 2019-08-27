//
//  RechargeModel.m
//  Project
//
//  Created by Aalto on 2019/7/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "LoginRegisterModel.h"


@implementation LoginRegisterData : NSObject
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"itemId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation LoginRegisterModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [LoginRegisterData class]
             };
}

- (NSArray *)getRegisterTypes{
    
    NSMutableArray *allArr = [NSMutableArray array];
    
    NSMutableArray* section0 = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray* section1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray* section2 = [NSMutableArray arrayWithCapacity:8];
    
    if(self.data.count > 0){
        for (int i=0; i<self.data.count; i++) {
            LoginRegisterData* listData = self.data[i];
             if ([listData.area integerValue] == 1) {
                    if ([listData.itemId isEqualToString:@"mobile"]) {
                        [section0 addObject:@{kTit:listData.name,
                                              kImg:@"icon_phone",
                                              kType:@(EnumActionTag0),
                                              kSubTit:listData.itemId,
                                              kIsOn:listData.regRequireFlag
                                              }];
                    }
                    if ([listData.itemId isEqualToString:@"mobile_code"]) {
                        [section0 addObject:@{kTit:listData.name,
                                              kImg:@"icon_security",
                                              kType:@(EnumActionTag1),
                                              kSubTit:listData.itemId,
                                              kIsOn:listData.regRequireFlag
                                              }];
                    }
                    if ([listData.itemId isEqualToString:@"passwd"]) {
                        [section0 addObject:@{kTit:listData.name,
                                              kImg:@"icon_lock",
                                              kType:@(EnumActionTag2),
                                              kSubTit:listData.itemId,
                                              kIsOn:listData.regRequireFlag
                                              }];
                    }
                    if ([listData.itemId isEqualToString:@"passwd"]) {
                        [section0 addObject:@{kTit:@"请确认密码",
                                              kImg:@"icon_lock",
                                              kType:@(EnumActionTag3),
                                              kSubTit:listData.itemId,
                                              kIsOn:listData.regRequireFlag
                                              }];
                    }
             }
            if ([listData.area integerValue] == 2) {
                if ([listData.itemId isEqualToString:@"invite_code"]) {
                    [section1 addObject:@{kTit:listData.name,
                                          kImg:@"icon_recommend",
                                          kType:@(EnumActionTag4),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
            }
            if ([listData.area integerValue] == 3) {
                if ([listData.itemId isEqualToString:@"qq"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_qqNum",
                                          kType:@(EnumActionTag5),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"wechat"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_weixin",
                                          kType:@(EnumActionTag6),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"email"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_email",
                                          kType:@(EnumActionTag7),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"name"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_realName",
                                          kType:@(EnumActionTag8),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"pic_code"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_vertifyImg",
                                          kType:@(EnumActionTag9),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"nick"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_userName",
                                          kType:@(EnumActionTag10),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"sex"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_gender",
                                          kType:@(EnumActionTag11),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"birthday"]) {
                    [section2 addObject:@{kTit:listData.name,
                                          kImg:@"icon_date",
                                          kType:@(EnumActionTag12),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.regRequireFlag
                                          }];
                }
            }
        }
        
    }
    if (section0.count>0) {
        [allArr addObject:section0];
    }
    if (section1.count>0) {
        [allArr addObject:section1];
    }
    if (section2.count>0) {
        [allArr addObject:section2];
    }
    
    return allArr;
}

- (NSArray *)getLoginTypes{
    
    NSMutableArray *allArr = [NSMutableArray array];
    
    NSMutableArray* section0 = [NSMutableArray arrayWithCapacity:4];
    
    if(self.data.count > 0){
        for (int i=0; i<self.data.count; i++) {
            LoginRegisterData* listData = self.data[i];
            
            if ([listData.area integerValue] == 1) {
                if ([listData.itemId isEqualToString:@"mobile"]) {
                    [section0 addObject:@{kTit:listData.name,
                                          kImg:@"icon_phone",
                                          kType:@(EnumActionTag0),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.loginUseFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"mobile_code"]) {
                    [section0 addObject:@{kTit:listData.name,
                                          kImg:@"icon_security",
                                          kType:@(EnumActionTag1),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.loginUseFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"passwd"]) {
                    [section0 addObject:@{kTit:listData.name,
                                          kImg:@"icon_lock",
                                          kType:@(EnumActionTag2),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.loginUseFlag
                                          }];
                }
                if ([listData.itemId isEqualToString:@"pic_code"]) {
                    [section0 addObject:@{kTit:listData.name,
                                          kImg:@"icon_vertifyImg",
                                          kType:@(EnumActionTag3),
                                          kSubTit:listData.itemId,
                                          kIsOn:listData.loginUseFlag
                                          }];
                }
            }
        }
    }
    if (section0.count>0) {
        [allArr addObjectsFromArray:section0];
    }
    
    
    return allArr;
}
@end
