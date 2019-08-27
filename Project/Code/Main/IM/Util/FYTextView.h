//
//  FYTextView.h
//  Project
//
//  Created by Mike on 2019/4/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteMessageBlock)(void);


@protocol FYTextViewDelegate <NSObject>

@optional;
// 删除消息
-(void)onTextViewDeleteMessage;
// 撤回消息
-(void)onTextViewWithdrawMessage;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FYTextView : UITextView

@property (nonatomic, assign) FYChatMessageFrom messageFrom;
//
@property (nonatomic,copy) DeleteMessageBlock deleteMessageBlock;
@property(nonatomic, weak) id <FYTextViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
