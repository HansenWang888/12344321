//
//  RechargeModel.m
//  Project
//
//  Created by Aalto on 2019/7/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "RechargeModel.h"
@implementation RechargeDetailListTypeData : NSObject
@end

@implementation RechargeDetailListBankData : NSObject
@end

@implementation RechargeDetailListItem : NSObject
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"itemId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation RechargeListTypeData : NSObject
@end

@implementation RechargeListData : NSObject
+(NSDictionary *)objectClassInArray{
    return @{
             @"detailList" : [RechargeDetailListItem class]
             };
}
@end

@implementation RechargeData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"officeChanels" : [RechargeListData class],
             @"thirdpartyChanels": [RechargeListData class]
             };
}

- (NSArray *)getChannelsArrData:(RechargeType)type{
    NSArray* arr  = [self getHorizontalTypeData:type];
    NSDictionary* dic = arr.firstObject;
    NSArray* officeChannels = dic[kArr];
    return officeChannels;
}

- (NSArray *)getChannelsTitles:(RechargeType)type{
    NSArray* arr  = [self getHorizontalTypeData:type];
    NSDictionary* dic = arr.firstObject;
    NSArray* officeChannels = dic[kArr];
    NSMutableArray* names = [NSMutableArray array];
    for (int i=0; i<officeChannels.count; i++) {
        NSDictionary* dic = officeChannels[i];
        NSDictionary* namDic = dic.allKeys[0];
        [names addObject:namDic.allKeys[0]];
    }
    return names;
}

- (NSArray *)getChannelsContainTitles:(RechargeType)type{
    NSArray* arr  = [self getHorizontalTypeData:type];
    NSDictionary* dic = arr.firstObject;
    NSArray* officeChannels = dic[kArr];
    NSMutableArray* names = [NSMutableArray array];
    for (int i=0; i<officeChannels.count; i++) {
        NSDictionary* dic = officeChannels[i];
        NSDictionary* namDic = dic.allKeys[0];
        [names addObject:namDic.allValues[0]];
    }
    return names;
}

- (NSArray *)getHorizontalTypeData:(RechargeType)type{
    NSMutableArray *allArr = [NSMutableArray array];
    
    NSMutableArray *officeChanels = [NSMutableArray array];
    NSMutableArray *thirdWXChanels = [NSMutableArray array];
    NSMutableArray *thirdZFBChanels = [NSMutableArray array];
    NSMutableArray *thirdYLChanels = [NSMutableArray array];
    
    if(self.officeChanels.count > 0){
        NSMutableArray *officeArr = [NSMutableArray array];
        
        for (int i=0; i<self.officeChanels.count; i++) {
            RechargeListData* listData = self.officeChanels[i];
            if ([listData.type.value integerValue]==RechargeType_GFWX
                &&listData.detailList.count>0) {
                [officeArr addObject:@{
                  @{listData.type.name:@"官方充值"}:
                      listData.detailList.firstObject
                  
                  }];
            }
            if ([listData.type.value integerValue]==RechargeType_GFZB
                &&listData.detailList.count>0) {
                [officeArr addObject:@{
                  @{listData.type.name:@"官方充值"}:
                      listData.detailList.firstObject
                  
                  }];
                
            }
            if ([listData.type.value integerValue]==RechargeType_GFBC
                &&listData.detailList.count>0) {
                [officeArr addObject:@{
                  @{listData.type.name:@"官方充值"}:
                      listData.detailList.firstObject
                  
                  }];
                
            }
        }
        if (officeArr.count>0) {
            NSDictionary *dic = @{@"imgNormal":@"rec_gf",
                                  @"imgSelected":@"rec_gf2",
                                  @"tag":@(RechargeType_gf),
                                  kArr:officeArr,
                                  kTit:@"官方充值"
                                  };
            [officeChanels addObject:dic];
            
            [allArr addObject:dic];
        }
        
    }
    
    for (int i=0; i<self.thirdpartyChanels.count; i++) {
        
        RechargeListData* listData = self.thirdpartyChanels[i];
        
        if ([listData.type.value integerValue] == RechargeType_SerivceWX) {
            
            NSMutableArray *officeArr = [NSMutableArray array];
            
            if (listData.detailList.count>0) {
                for (int i=0; i<listData.detailList.count; i++) {
                    RechargeDetailListItem* listItem = listData.detailList[i];
                    [officeArr addObject:@{
                      @{[NSString stringWithFormat:@"通道%@",[self  numberToZH:[NSString stringWithFormat:@"%d",i + 1]]]:listItem.title}:
                          listItem
                      }];
                    }
            }
            
            if (officeArr.count>0) {
                NSDictionary *dic = @{@"imgNormal":@"rec_wx",
                                      @"imgSelected":@"rec_wx2",
                                      @"tag":@(RechargeType_weiXin),
                                      kArr:officeArr,
                                      kTit:listData.type.name
                                      };
                [thirdWXChanels addObject:dic];
                [allArr addObject:dic];
            }
            
        }
        if ([listData.type.value integerValue] == RechargeType_SerivceZB) {
            
            NSMutableArray *officeArr = [NSMutableArray array];
            if (listData.detailList.count>0) {
                for (int i=0; i<listData.detailList.count; i++) {
                    RechargeDetailListItem* listItem = listData.detailList[i];
                    [officeArr addObject:@{
                       @{[NSString stringWithFormat:@"通道%@",[self  numberToZH:[NSString stringWithFormat:@"%d",i + 1]]]:listItem.title}:
                           listItem
                       }];
                    
                }
            }
            
            if (officeArr.count>0) {
                NSDictionary *dic = @{@"imgNormal":@"rec_jf",
                                      @"imgSelected":@"rec_jf2",
                                      @"tag":@(RechargeType_zhiFuBao),
                                      kArr:officeArr,
                                      kTit:listData.type.name
                                      };
                [thirdZFBChanels addObject:dic];
                [allArr addObject:dic];
            }
            
        }
        if ([listData.type.value integerValue] == RechargeType_SerivceYL) {
            
            NSMutableArray *officeArr = [NSMutableArray array];
            if (listData.detailList.count>0) {
                for (int i=0; i<listData.detailList.count; i++) {
                    RechargeDetailListItem* listItem = listData.detailList[i];
                    [officeArr addObject:@{
                       @{[NSString stringWithFormat:@"通道%@",[self  numberToZH:[NSString stringWithFormat:@"%d",i + 1]]]:listItem.title}:
                           listItem
                        }];
                }
            }
            if (officeArr.count>0) {
                NSDictionary *dic = @{@"imgNormal":@"rec_yl",
                                      @"imgSelected":@"rec_yl2",
                                      @"tag":@(RechargeType_yinLian),
                                      kArr:officeArr,
                                      kTit:listData.type.name
                                      };
                [thirdYLChanels addObject:dic];
                [allArr addObject:dic];
            }
            
        }
    }
    
    switch (type) {
        case RechargeType_All:
            return allArr;
            break;
        case RechargeType_gf:
            return officeChanels;
            break;
        case RechargeType_weiXin:
            return thirdWXChanels;
            break;
        case RechargeType_zhiFuBao:
            return thirdZFBChanels;
            break;
        case RechargeType_yinLian:
            return thirdYLChanels;
            break;
    }
    
    return allArr;
}

- (NSString *)numberToZH:(NSString *)number{
    NSDictionary *dic = @{@"0":@"",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六",@"7":@"七",@"8":@"八",@"9":@"九",@"10":@"十"};
    NSInteger num = [number integerValue];
    if(num <= 10)
        return dic[number];
    
    NSInteger geWei = num % 10;
    NSInteger shiWei = num / 10;
    
    NSString *getWeiString = [NSString stringWithFormat:@"%zd",geWei];
    NSString *value1 = dic[getWeiString];
    NSString *shiWeiString = [NSString stringWithFormat:@"%zd",shiWei];
    NSString *value2 = dic[shiWeiString];
    if(shiWei < 2)
        return [NSString stringWithFormat:@"十%@",value1];
    else
        return [NSString stringWithFormat:@"%@十%@",value2,value1];
}

@end

@implementation RechargeModel

@end
