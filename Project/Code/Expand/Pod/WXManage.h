//
//  WXManage.h
//  Project
//
//  Created by mini on 2018/8/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@class WXShareModel;

typedef NS_ENUM(NSInteger, MediaType)
{
    MediaType_url,
    MediaType_image,
};//


@interface WXManage : NSObject<WXApiDelegate>

+ (WXManage *)shareInstance;

/**
 *   obj 分享内容 目前市场基本是分享网页内容
 *   WXMediaMessage *message = [WXMediaMessage message];
 *   message.title = @"标题";
 *
 *   WXSceneSession  = 0,       聊天界面
 *   WXSceneTimeline = 1,       朋友圈
 *   WXSceneFavorite = 2,       收藏
 */
- (void)wxShareObj:(WXShareModel *)obj
         mediaType:(MediaType)mediaType
           Success:(void (^)(void))success
           Failure:(void (^)(NSError *))failue;

- (void)wxAuthCode:(void (^)(NSString *))code
           Failure:(void (^)(NSError *))failue;

- (void)wxAuthSuccess:(void (^)(NSDictionary *))success
              Failure:(void (^)(NSError *))failue;

+ (BOOL) isWXAppInstalled;
+ (BOOL) handleOpenURL:(NSURL *)url;

@end
