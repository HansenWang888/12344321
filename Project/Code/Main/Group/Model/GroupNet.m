//
//  GroupNet.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupNet.h"
#import "BANetManager_OC.h"

@implementation GroupNet

-(instancetype)init {
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _page = 1;
        _pageSize = 15;
        _isMost = NO;
        _isEmpty = NO;
    }
    return self;
}



/**
 查询群成员
 
 @param groupId 群ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)queryGroupUserGroupId:(NSString *)groupId
                 successBlock:(void (^)(NSDictionary *))successBlock
                 failureBlock:(void (^)(NSError *))failureBlock {

    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/groupUsers"];
    
    NSMutableDictionary *queryParamDict = [[NSMutableDictionary alloc] init];
    [queryParamDict setObject:groupId forKey:@"id"];  
    
    NSDictionary *parameters = @{
                                 @"size":@(self.pageSize),
                                 @"sort":@"id",
                                 @"isAsc":@"true",
                                 @"current":@(self.page),
                                 @"queryParam":queryParamDict
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
        
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];

}

- (void)dissolveGroupWithID:(NSString *)groupId isOfficeFlag:(BOOL)isOfficeFlag isGroupManager:(BOOL)isGroupManager successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    NSDictionary *parameters = nil;
    if (isOfficeFlag) {//退出群,解散群
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/quit"];
        
        parameters = @{
                       @"id":groupId
                       };

    } else {//自建群
        if (isGroupManager) {//群主解散群
            
            entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/delGroup"];
            parameters = @{
                           @"chatGroupId":groupId,
                           @"userId": AppModel.shareInstance.userInfo.userId
                           };
        }else{
            entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/quit"];
            
            parameters = @{
                           @"id":groupId
                           };
        }
    }
    
    entity.parameters = parameters;
    entity.needCache = NO;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        successBlock(response);
        
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];
}
- (void)getGroupMemberWithUserID:(NSString *)userId groupId:(NSString *)groupId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    BADataEntity *entity = [BADataEntity new];
    NSDictionary *parameters = nil;
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/queryGroupUsers"];
    
    parameters = @{
                   @"queryParam": @{
                           @"id": groupId,
                           @"userIdOrNick": userId
                           },
                   @"current": @(pageIndex),
                   @"size": @(pageSize)
                   };
    
    entity.parameters = parameters;
    entity.needCache = NO;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        successBlock(response);
        
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];
}

- (void)deleteGroupMembersWithGroupId:(NSString *)grupId userIds:(NSArray *)array successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    NSDictionary *parameters = nil;
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/delGroupMember"];
    
    parameters = @{
                   @"chatGroupId": grupId,
                   @"userId":array
                   };
    
    entity.parameters = parameters;
    entity.needCache = NO;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        successBlock(response);
        
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];
    
}
- (void)processingData:(NSDictionary *)response {
    if (CD_Success([response objectForKey:@"code"], 0)) {
        NSDictionary *data = [response objectForKey:@"data"];
        if (data != NULL) {
//            self.page = [[data objectForKey:@"current"] integerValue];
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            self.total = [[data objectForKey:@"total"]integerValue];
            if(self.groupNum > 0)
                self.total += self.groupNum;
            NSArray *list = [data objectForKey:@"records"];
            for (id obj in list) {
                if([obj isKindOfClass:[NSNull class]]){
                    [self.dataList addObject:@{}];
                }else
                    [self.dataList addObject:obj];
            }
            self.isEmpty = (self.dataList.count == 0)?YES:NO;
            self.isMost = ((self.dataList.count % self.pageSize == 0)&(list.count>0))?NO:YES;
        }
        
    }
}

@end
