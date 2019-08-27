//
//  GroupNet.h
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNet : NSObject

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page;   // < 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize;   // < 页大小(默认值15)                可选

@property (nonatomic ,assign) BOOL isEmpty; // <空
@property (nonatomic ,assign) BOOL isMost; // <没有更多

@property(nonatomic,assign)NSInteger groupNum;//群用户基数


/**
 查询群成员

 @param groupId 群ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)queryGroupUserGroupId:(NSString *)groupId
             successBlock:(void (^)(NSDictionary *))successBlock
             failureBlock:(void (^)(NSError *))failureBlock;


/**
 * 解散或退出群
 *@param isOffcialGroup 是否为官方创建群
 */
- (void)dissolveGroupWithID:(NSString *)groupId isOfficeFlag:(BOOL)isOfficeFlag isGroupManager:(BOOL)isGroupManager successBlock:(void (^)(NSDictionary *))successBlock
               failureBlock:(void (^)(NSError *))failureBlock;
/**
 * 显示 自建群 所有群成员和搜索成员
 * @param userId 查询用户id
 * @param groupId 查询所有成员
 */
- (void)getGroupMemberWithUserID:(NSString *)userId groupId:(NSString *)groupId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize successBlock:(void (^)(NSDictionary *))successBlock
                         failureBlock:(void (^)(NSError *))failureBlock;

/**
 * 删除群成员
 */

- (void)deleteGroupMembersWithGroupId:(NSString *)grupId userIds:(NSArray *)array successBlock:(void (^)(NSDictionary *))successBlock
                         failureBlock:(void (^)(NSError *))failureBlock;
@end
