//
//  BannerModel.h
//  Project
//
//  Created by Aalto on 2019/5/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BannerItem : NSObject
@property (nonatomic, copy) NSString * advLinkUrl;
@property (nonatomic, copy) NSString * advPicUrl;
@property (nonatomic, copy) NSString * advSpaceId;
@property (nonatomic, copy) NSString * clickNum;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * delFlag;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * linkType;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * putFlag;
@property (nonatomic, copy) NSString * reference;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * userId;
+ (NSDictionary *)replacedKeyFromPropertyName;
@end

@interface BannerData : NSObject
@property (nonatomic, copy) NSString * carouselSecTime;
@property (nonatomic, copy) NSString * carouselTime;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;

@property (nonatomic, copy) NSArray * skAdvDetailList;
+ (NSDictionary *)replacedKeyFromPropertyName;
+(NSDictionary *)objectClassInArray;
@end

@interface BannerModel : NSObject
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) BannerData * data;
//+(NSDictionary *)objectClassInArray;
@end

NS_ASSUME_NONNULL_END
