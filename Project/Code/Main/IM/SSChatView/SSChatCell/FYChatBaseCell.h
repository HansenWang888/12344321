//
//  FYChatBaseCell.h
//  SSChatView
//
//  Created by soldoros on 2018/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYMessagelLayoutModel.h"


@class FYChatBaseCell;
@class FYMessage;
@class UserInfo;
@class FYTextView;

@protocol FYChatBaseCellDelegate <NSObject>

@optional;
// 点击头像 didSelectRowAtIndexPath
-(void)didTapCellChatHeaderImg:(UserInfo *)userInfo;
// 长按头像
-(void)didLongPressCellChatHeaderImg:(UserInfo *)userInfo;

// 点击Cell消息背景视图
- (void)didTapMessageCell:(FYMessage *)model;

// 点击文本cell
-(void)didChatTextCellIndexPath:(NSIndexPath*)indexPath index:(NSInteger)index layout:(FYMessagelLayoutModel *)layout;

// 点击cell图片和短视频
-(void)didChatImageVideoCellIndexPatch:(NSIndexPath *)indexPath layout:(FYMessagelLayoutModel *)layout;

// 点击定位cell
-(void)didChatMapCellIndexPath:(NSIndexPath*)indexPath layout:(FYMessagelLayoutModel *)layout;

// 删除消息
-(void)onDeleteMessageCell:(FYMessage *)model indexPath:(NSIndexPath *)indexPath;
/**
 撤回消息

 @param model 消息模型
 */
-(void)onWithdrawMessageCell:(FYMessage *)model;

/**
 点击重发
 
 @param model 消息模型
 */
-(void)onErrorBtnCell:(FYMessage *)model;

@end

@interface FYChatBaseCell : UITableViewCell

@property (nonatomic, strong) UIActivityIndicatorView *traningActivityIndicator;  //发送loading
@property (nonatomic, strong) UIButton *retryButton;                              //重试


@property(nonatomic, strong) NSIndexPath           *indexPath;
//撤销 删除 复制
@property(nonatomic, strong) UIMenuController *menu;
// 名称昵称
@property(nonatomic, strong) UILabel  *nicknameLabel;
// 头像
@property(nonatomic, strong) UIButton *mHeaderImgBtn;
// 时间
@property(nonatomic, strong) UILabel  *mMessageTimeLab;
// 气泡背景View
@property(nonatomic, strong) UIImageView  *bubbleBackView;
//文本消息
@property(nonatomic, strong) FYTextView     *mTextView;
//图片消息
@property(nonatomic, strong) UIImageView *mImgView;
//视频消息
@property(nonatomic, strong) UIButton *mVideoBtn;
@property(nonatomic, strong) UIImageView *mVideoImg;
// 错误标示
@property(nonatomic, strong) UIButton *errorBtn;

@property(nonatomic, weak) id <FYChatBaseCellDelegate> delegate;
-(void)initChatCellUI;
@property(nonatomic, strong) FYMessagelLayoutModel  *model;


//消息按钮
-(void)buttonPressed:(UIImageView *)sender;


@end

