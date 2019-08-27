//
//  EnvelopeMessage.h
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

//#import <RongIMLib/RongIMLib.h>

// 红包类型
typedef NS_ENUM(NSInteger, FYRedEnvelopeType) {
    // 福利红包
    FYRedEnvelopeType_Fu    = 0,
    // 扫雷红包
    FYRedEnvelopeType_Mine    = 1, 
    // 牛牛红包
    FYRedEnvelopeType_Cow    = 2,
    // 禁抢红包
    FYRedEnvelopeType_NoRob    = 3
};


//@interface EnvelopeMessage : RCMessageContent<NSCoding>
@interface EnvelopeMessage : NSObject<NSCoding>


@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *money;
// 红包id
@property (nonatomic, copy) NSString *redpacketId;
@property (nonatomic, assign) NSInteger num;


@property (nonatomic, assign) FYRedEnvelopeType type;

// Cell状态   (红包标识符+ userId) 获得
 @property (nonatomic, copy) NSString *cellStatus;     
        


// 禁抢
@property (nonatomic, strong) NSDictionary *nograbContent;




 @property (nonatomic, copy) NSString *content;
- (instancetype)initWithObj:(id)obj;

@end
