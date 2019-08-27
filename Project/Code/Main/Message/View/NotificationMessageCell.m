//
//  NotificationMessageCell.m
//  Project
//
//  Created by Mike on 2019/2/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "NotificationMessageCell.h"
#import "NotificationMessageModel.h"
#import "NSString+Size.h"

@interface NotificationMessageCell()
//
@property (nonatomic,strong) UIView *textBackView;

@end

@implementation NotificationMessageCell


-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
}

#pragma mark - subView
- (void)initSubviews {


    _tipLabel = [UILabel new];
    [self addSubview:_tipLabel];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.backgroundColor = [UIColor colorWithRed:0.788 green:0.788 blue:0.788 alpha:1.000];
    _tipLabel.font = [UIFont systemFontOfSize:12];
    _tipLabel.clipsToBounds = YES;
    _tipLabel.layer.cornerRadius = 3;
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

-(void)setModel:(FYMessagelLayoutModel *)model {
    [super setModel:model];
    
    if (model.message.messageFrom == FYChatMessageFromSystem) {
        self.tipLabel.text = model.message.text;
        
      CGFloat width = [model.message.text widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:17] +10*2;
        
        [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 20));
        }];
        
        return;
    }
    
    NotificationMessageModel *messageModel = [[NotificationMessageModel alloc] init];
    
    if (messageModel.messagetype == 1) {
        self.tipLabel.text = @"发送的消息超过规定长度";
    } else if (messageModel.messagetype == 2) {
        if (messageModel.talkTime > 0) {
            self.tipLabel.text = [NSString stringWithFormat:@"消息需要间隔%ld秒才能再次发送", (long)messageModel.talkTime];
        } else {
            self.tipLabel.text = @"发送消息的间隔时间没到，请稍后再试";
        }
    } else if (messageModel.messagetype == 3) {
        self.tipLabel.text = @"服务器连接错误";
    } else {
        self.tipLabel.text = @"系统历史消息";
    }
    
    
   
}


@end

