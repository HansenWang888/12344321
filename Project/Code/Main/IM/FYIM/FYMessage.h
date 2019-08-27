//
//  FYMessage.h
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+SSAdd.h"
#import "FYMessageConstants.h"


NS_ASSUME_NONNULL_BEGIN

@class EnvelopeMessage;

/**
 *  消息送达状态枚举
 */
typedef NS_ENUM(NSInteger, FYMessageDeliveryState){
    /**
     *  消息发送失败
     */
    FYMessageDeliveryStateFailed,
    /**
     *  消息发送中
     */
    FYMessageDeliveryStateDelivering,
    /**
     *  消息发送成功
     */
    FYMessageDeliveryStateDeliveried
};

/**
 *  消息结构
 */
@interface FYMessage : NSObject<NSCopying>

/**
 *  消息类型
 */
@property (nonatomic, assign) FYMessageType messageType;

/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic, copy)         NSString *sessionId;

/**
 to   接收者 单聊
 */
@property (nonatomic, copy)         NSString *toUserId;

/**
 to   接收者 对象
 */
@property (nonatomic, strong)         NSDictionary *receiver;

/**
 发送者
 */
@property (nonatomic, copy)  NSString *messageSendId;

/**
 消息ID,唯一标识
 */
@property (nonatomic, copy) NSString    *messageId;

/**
 *  消息发送时间    时间戳
 *  @discussion 本地存储消息可以通过修改时间戳来调整其在会话列表中的位置，发完服务器的消息时间戳将被服务器自动修正
 */
@property (nonatomic, assign)                NSTimeInterval timestamp;

/**
 *  消息文本
 *  @discussion 消息中除 NIMMessageTypeText 和 NIMMessageTypeTip 外，其他消息 text 字段都为 nil
 */
@property (nullable,nonatomic,copy)                  NSString *text;
/**
 红包信息
 */
@property (nonatomic, strong) EnvelopeMessage    *redEnvelopeMessage;
/**
 牛牛报奖信息
 */
@property (nonatomic, strong) NSDictionary    *cowcowRewardInfoDict;

/**
 消息 发送 or 接收 or 系统
 */
@property (nonatomic, assign) FYChatMessageFrom messageFrom;
/**
 用户资料
 */
@property (nonatomic, strong) UserInfo    *user;
/**
 数据库的创建时间
 */
@property (nonatomic, strong) NSDate    *create_time;

/**
 消息是否标记为已删除  为本地自己的
 */
@property (nonatomic,assign)       BOOL isDeleted;
/**
 消息是否标记为已撤回
 */
@property (nonatomic,assign)       BOOL isRecallMessage;
/**
 *  消息所属会话   群组还是个人 等
 */
@property(nonatomic,assign) FYChatConversationType chatType;
/**
 *  消息附件内容
 */
//@property (nullable,nonatomic,strong)                id<NIMMessageObject> messageObject;

/**
 *  消息投递状态 仅针对发送的消息
 */
@property (nonatomic,assign)       FYMessageDeliveryState deliveryState;

/**
 *  是否是收到的消息
 *  @discussion 由于有漫游消息的概念,所以自己发出的消息漫游下来后仍旧是"收到的消息",这个字段用于消息出错是时判断需要重发还是重收
 */
@property (nonatomic,assign)       BOOL isReceivedMsg;

@property (nonatomic,assign)       BOOL isNewReceivedMsg;

/**
 *  是否是往外发的消息
 *  @discussion 由于能对自己发消息，所以并不是所有来源是自己的消息都是往外发的消息，这个字段用于判断头像排版位置（是左还是右）。
 */
//@property (nonatomic,assign,readonly)       BOOL isOutgoingMsg;

/**
 *  消息发送者名字
 *  @discussion 当发送者是自己时,这个值可能为空,这个值表示的是发送者当前的昵称,而不是发送消息时的昵称。聊天室消息里，此字段无效。
 */
//@property (nullable,nonatomic,copy,readonly)         NSString *senderName;
/**
 *  发送者客户端类型
 */
//@property (nonatomic,assign,readonly)   NIMLoginClientType senderClientType;

/**
 *  是否在黑名单中
 *  @discussion YES 为被目标拉黑;
 */
//@property (nonatomic,assign,readonly) BOOL isBlackListed;

// 备用字段1
@property (nonatomic, copy)  NSString *FieldOne;
// 备用字段2
@property (nonatomic, copy)  NSString *FieldTwo;






// ******************* 后面扩展使用 *******************

// CellIDString
@property (nonatomic, copy) NSString     *cellString;

// 是否需要显示时间
@property (nonatomic, assign) BOOL        showTime;
//单条消息背景图
@property (nonatomic, copy) NSString    *backImgString;


//文本消息内容 颜色  消息转换可变字符串
//@property (nonatomic, strong) NSString    *textString;
//@property (nonatomic, strong) UIColor     *textColor;
@property (nonatomic, strong) NSMutableAttributedString  *attTextString;

//图片消息链接或者本地图片 图片展示格式
@property (nonatomic, copy) NSString    *imageString;
//@property (nonatomic, strong) UIImage     *image;
@property (nonatomic, copy) NSString     *imageUrl;
//@property (nonatomic, assign) UIViewContentMode contentMode;

@property(nonatomic,strong) NSDictionary *selectPhoto;

//音频时长(单位：秒) 展示时长  音频网络路径  本地路径  音频
@property (nonatomic, assign) NSInteger   voiceDuration;
@property (nonatomic, strong) NSString    *voiceTime;
@property (nonatomic, strong) NSString    *voiceRemotePath;
@property (nonatomic, strong) NSString    *voiceLocalPath;
@property (nonatomic, strong) NSData      *voice;

//语音波浪图标及数组
//@property (nonatomic, strong) UIImage     *voiceImg;
@property (nonatomic, strong) NSArray     *voiceImgs;


//地理位置纬度  经度   详细地址
@property (nonatomic, assign) double      latitude;
@property (nonatomic, assign) double      longitude;
@property (nonatomic, copy) NSString    *addressString;

//短视频缩略图网络路径 本地路径  视频图片 local路径
@property (nonatomic, copy) NSString    *videoRemotePath;
@property (nonatomic, copy) NSString    *videoLocalPath;
//@property (nonatomic, strong) UIImage     *videoImage;
@property (nonatomic, assign) NSInteger   videodDration;


// 拓展消息
@property(nonatomic,strong) NSDictionary *extDict;

// 消息验证时候使用
@property(nonatomic,strong) NSDictionary *extras;


/**
 判断当前时间是否展示
 
 @param lastTime 最后展示的时间
 @param currentTime 当前时间
 */
-(void)showTimeWithLastShowTime:(NSTimeInterval)lastTime currentTime:(NSTimeInterval)currentTime;


@end

NS_ASSUME_NONNULL_END


