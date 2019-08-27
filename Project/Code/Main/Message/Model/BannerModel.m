//
//  BannerModel.m
//  Project
//
//  Created by Aalto on 2019/5/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BannerModel.h"
@implementation BannerItem
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}
@end

@implementation BannerData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             //             @"nameChangedTime" : @"name.info.nameChangedTime",
             };
}
+(NSDictionary *)objectClassInArray{
    return @{
             @"skAdvDetailList" : [BannerItem class]
             };
}
@end

@implementation BannerModel

@end
