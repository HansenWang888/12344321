//
//  FYIMSessionViewController.h
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYMessagelLayoutModel.h"
#import "FYIMManager.h"
#import "SSChatKeyBoardInputView.h"
#import "FYIMMessageManager.h"
#import "FYContacts.h"

@interface FYIMSessionViewController : UIViewController

//底部输入框 携带表情视图和多功能视图
@property(nonatomic, strong) SSChatKeyBoardInputView *sessionInputView;
//单聊 群聊等
@property(nonatomic, assign) FYChatConversationType chatType;
// 会话id
@property (nonatomic, copy) NSString    *sessionId;
// 单聊 接受者用户信息
@property (nonatomic, strong) FYContacts    *toContactsModel;
//名字
@property (nonatomic, copy) NSString    *titleString;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,assign) BOOL reloadFinish;

- (void)didTapMessageCell:(FYMessage *)model;
//发送文本 列表滚动至底部
-(void)onChatKeyBoardInputViewSendText:(NSString *)text;


/*!
 初始化会话页面
 
 @param conversationType 会话类型
 @param targetId         目标会话ID
 
 @return 会话页面对象
 */
- (id)initWithConversationType:(FYChatConversationType)conversationType targetId:(NSString *)targetId;

//多功能视图点击回调  图片10  视频11  位置12
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag;

+ (FYIMSessionViewController *)currentChat;

@property (weak, nonatomic)id <FYChatManagerDelegate> delegate;

#pragma mark -  上传图片
/**
 上传图片
 */
- (void)loadImage;

#pragma mark - 更新未读消息
/**
 更新未读消息
 */
- (void)updateUnreadMessage;

@end
