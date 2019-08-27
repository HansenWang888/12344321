//
//  SSChatTextCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/10.
//  Copyright © 2018年 soldoros. All rights reserved.
//



#import "SSChatTextCell.h"
#import "FYTextView.h"


@interface SSChatTextCell () <FYTextViewDelegate>

@end


@implementation SSChatTextCell

-(void)initChatCellUI{
    [super initChatCellUI];
    
    self.mTextView = [FYTextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.bubbleBackView addSubview:self.mTextView];
    self.mTextView.delegate = self;
    
//    __weak __typeof(self)weakSelf = self;
//    self.mTextView.deleteMessageBlock = ^{
//        [self onDeleteMessage];
//    };
}




-(void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mTextView.messageFrom = model.message.messageFrom;
    
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
//    [self.bubbleBackView setBackgroundImage:image forState:UIControlStateNormal];

    self.mTextView.frame = model.textLabRect;
    self.mTextView.attributedText = model.message.attTextString;
   
    // 消息加载状态
    BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
    if (isActivityIndicatorHidden) {
        [self.traningActivityIndicator stopAnimating];
    } else {
        [self.traningActivityIndicator startAnimating];
        [self layoutActivityIndicator];
    }
    [self.traningActivityIndicator setHidden:isActivityIndicatorHidden];
}


- (void)layoutActivityIndicator
{
    if (self.traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        if ((self.model.message.messageFrom == FYMessageDirection_SEND))
        {
            centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
            self.traningActivityIndicator.center = CGPointMake(centerX,
                                                               self.bubbleBackView.center.y);
        }
    }
}

- (BOOL)activityIndicatorHidden
{
//    if (self.model.message.isReceivedMsg)
//    {
//        return self.model.message.deliveryState != FYMessageDeliveryStateDelivering;
//    }
//    return NO;
    return YES;
}


-(void)onTextViewWithdrawMessage {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onWithdrawMessageCell:)]){
        [self.delegate onWithdrawMessageCell:self.model.message];
    }
}


#pragma mark - 删除消息代理
-(void)onTextViewDeleteMessage {
    [self onDeleteMessage];
}

/**
 删除消息
 */
- (void)onDeleteMessage {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDeleteMessageCell:indexPath:)]){
        [self.delegate onDeleteMessageCell:self.model.message indexPath:self.indexPath];
    }
}



@end
