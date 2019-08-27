//
//  FYMessagelLayoutModel.h
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@class FYMessage;

@interface FYMessagelLayoutModel : NSObject
/**
 根据模型生成布局
 
 @param message 传入消息模型
 @return 返回布局对象
 */
-(instancetype)initWithMessage:(FYMessage *)message;

//消息模型
@property (nonatomic, strong) FYMessage  *message;

// 群id sql
@property (nonatomic, copy)         NSString *groupId;
@property (nonatomic, strong)        NSDate *create_time;

//消息布局到CELL的总高度
@property (nonatomic, assign) CGFloat      cellHeight;

// 用户昵称frame 
@property (nonatomic, assign) CGRect       nickNameRect;
// 头像控件的frame
@property (nonatomic, assign) CGRect       headerImgRect;
// 时间控件的frame
@property (nonatomic, assign) CGRect       timeLabRect;

//背景按钮的frame
@property (nonatomic, assign) CGRect       bubbleBackViewRect;
//背景按钮图片的拉伸膜是和保护区域
@property (nonatomic, assign) UIEdgeInsets imageInsets;

//文本间隙的处理
@property (nonatomic, assign) UIEdgeInsets textInsets;
//文本控件的frame
@property (nonatomic, assign) CGRect       textLabRect;

//语音时长控件的frame
@property (nonatomic, assign) CGRect       voiceTimeLabRect;
//语音波浪图标控件的frame
@property (nonatomic, assign) CGRect       voiceImgRect;

//视频控件的frame
@property (nonatomic, assign) CGRect       videoImgRect;



@end
