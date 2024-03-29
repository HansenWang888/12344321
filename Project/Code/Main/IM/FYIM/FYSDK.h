//
//  NIMSDK.h
//  NIMSDK
//
//  Created by Netease.
//  Copyright © 2017年 Netease. All rights reserved.
//

/**
 *  平台相关定义
 */
//#import "NIMPlatform.h"

/**
 *  全局枚举和结构体定义
 */
#import "FYStatusDefine.h"

#undef    AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
/**
 *  配置项
 */
//#import "NIMSDKOption.h"
//#import "NIMSDKConfig.h"

/**
 *  会话相关定义
 */
//#import "NIMSession.h"
//#import "NIMRecentSession.h"
//#import "NIMMessageSearchOption.h"
#import "FYMessage.h"
#import "FYChatManagerProtocol.h"

/**
 *  用户定义
 */
//#import "NIMUser.h"

/**
 *  群相关定义
 */
//#import "NIMTeamDefs.h"
//#import "NIMTeam.h"
//#import "NIMTeamMember.h"
//#import "NIMCreateTeamOption.h"
/**
 *  聊天室相关定义
 */
//#import "NIMChatroom.h"
//#import "NIMChatroomEnterRequest.h"
//#import "NIMMessageChatroomExtension.h"
//#import "NIMChatroomMember.h"
//#import "NIMChatroomMemberRequest.h"
//#import "NIMChatroomUpdateRequest.h"
//#import "NIMChatroomQueueRequest.h"
//#import "NIMChatroomBeKickedResult.h"

/**
 *  消息定义
 */
//#import "NIMMessage.h"
//#import "NIMSystemNotification.h"
//#import "NIMRevokeMessageNotification.h"
//#import "NIMDeleteMessagesOption.h"
//#import "NIMBroadcastMessage.h"
//#import "NIMImportedRecentSession.h"

/**
 *  推送定义
 */
//#import "NIMPushNotificationSetting.h"

/**
 *  登录定义
 */
//#import "NIMLoginClient.h"

/**
 *  文档转码信息
 */
//#import "NIMDocTranscodingInfo.h"

/**
 *  事件订阅
 */
//#import "NIMSubscribeEvent.h"
//#import "NIMSubscribeRequest.h"
//#import "NIMSubscribeOnlineInfo.h"
//#import "NIMSubscribeResult.h"


/**
 *  缓存管理
 */
//#import "NIMCacheQuery.h"

/**
 *  通用音视频信令
 */
//#import "NIMSignalingMemberInfo.h"
//#import "NIMSignalingRequest.h"
//#import "NIMSignalingResponse.h"


/**
 *  各个对外接口协议定义
 */
//#import "NIMLoginManagerProtocol.h"
//#import "NIMChatManagerProtocol.h"
//#import "NIMConversationManagerProtocol.h"
//#import "NIMMediaManagerProtocol.h"
//#import "NIMUserManagerProtocol.h"
//#import "NIMTeamManagerProtocol.h"
//#import "NIMSystemNotificationManagerProtocol.h"
//#import "NIMApnsManagerProtocol.h"
//#import "NIMResourceManagerProtocol.h"
//#import "NIMChatroomManagerProtocol.h"
//#import "NIMDocTranscodingManagerProtocol.h"
//#import "NIMEventSubscribeManagerProtocol.h"
//#import "NIMRobotManagerProtocol.h"
//#import "NIMRedPacketManagerProtocol.h"
//#import "NIMBroadcastManagerProtocol.h"
//#import "NIMAntispamManagerProtocol.h"
//#import "NIMSignalManagerProtocol.h"

/**
 *  SDK业务类
 */
//#import "NIMServerSetting.h"
//#import "NIMSDKHeader.h"

