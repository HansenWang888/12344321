//
//  Constants.h
//  Project
//
//  Created by Mike on 2019/1/5.
//  Copyright © 2019 CDJay. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


//static NSString* const WXShareDescription  = @"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元";
static NSString* const WXShareTitle  = @"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元";

static NSString * const kMessRefundMessage = @"未领取的红包，将于5分钟后发起退款";
static NSString * const kMessCowRefundMessage = @"牛牛红包不结算红包金额，只结算输赢金额";

static NSString * const kRedpackedGongXiFaCaiMessage = @"恭喜发财，大吉大利";

static NSString * const kRedpackedExpiredMessage = @"该红包已超过5分钟，如已领取，可在<账单>中查询";

static NSString * const kGrabpackageNoMoneyMessage = @"金额不足，无法抢包";

static NSString * const kLookLuckDetailsMessage = @"看看大家的手气>";

static NSString * const kNoMoreRedpackedMessage = @"手慢了，红包派完了";

static NSString * const kSystemBusyMessage = @"系统繁忙，请稍后再试";

static NSString * const kOtherDevicesLoginMessage = @"您的账号在别的设备上登录，您被迫下线！";

static NSString * const kNetworkConnectionNotAvailableMessage = @"网络连接不可用，请稍后重试";

static NSString * const kAccountOrPasswordErrorMessage = @"账号或密码错误，请重新填写";




// 自定义红包 特殊字符判断  踩雷
static NSString * const RedPacketString = @"~!@#$%^&*()";
// 牛牛
static NSString * const CowCowMessageString = @"~!@#$niuniuPrize%^&*()";
// 消息类型
static NSString * const kRCNotificationMessage = @"RC:NotiMessage";
// 密码请求token Key
static NSString * const kAccountPasswordKey = @"1234567887654321";

// ************************ 通知 ************************
// 需要刷新token通知
static NSString * const kOnConnectSocketNotification = @"kOnConnectSocketNotification";
// token 失效通知
static NSString * const kTokenInvalidNotification = @"kTokenInvalidNotification";

// 刷新群信息通知
static NSString * const kReloadMyMessageGroupList = @"kReloadMyMessageGroupList";
// 未读消息数有变更
static NSString * const kUnreadMessageNumberChange = @"kUnreadMessageNumberChange";
// 更新我的好友或者客服列表
static NSString * const kUpdateMyFriendOrServiceMembersMessageList = @"kUpdateMyFriendOrServiceMembersMessageList";
// 已经获取到我加入的群通知
static NSString * const kDoneGetMyJoinedGroupsNotification = @"kDoneGetMyJoinedGroupsNotification";

// 已登录IM
static NSString * const kLoggedSuccessNotification = @"kLoggedSuccessNotification";

// 无网络通知
static NSString * const kNoNetworkNotification = @"kNoNetworkNotification";
// 有网络通知
static NSString * const kYesNetworkNotification = @"kYesNetworkNotification";
// 控制器已显示通知
static NSString * const kMessageViewControllerDisplayNotification = @"kMessageViewControllerDisplayNotification";

#endif /* Constants_h */
