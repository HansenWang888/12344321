//
//  FYChatBaseCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "FYChatBaseCell.h"
#import "FYIMKitUtil.h"

@implementation FYChatBaseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SSChatCellColor;
        self.contentView.backgroundColor = SSChatCellColor;
        [self initChatCellUI];
    }
    return self;
}


-(void)initChatCellUI {

    //创建时间
    _mMessageTimeLab = [UILabel new];
    _mMessageTimeLab.bounds = CGRectMake(0, 0, SSChatTimeWidth, SSChatTimeHeight);
    _mMessageTimeLab.top = SSChatTimeTopOrBottom;
    _mMessageTimeLab.centerX = FYSCREEN_Width*0.5;
    [self.contentView addSubview:_mMessageTimeLab];
    _mMessageTimeLab.textAlignment = NSTextAlignmentCenter;
    _mMessageTimeLab.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _mMessageTimeLab.textColor = [UIColor whiteColor];
    _mMessageTimeLab.backgroundColor = [UIColor colorWithRed:0.788 green:0.788 blue:0.788 alpha:1.000];
    _mMessageTimeLab.clipsToBounds = YES;
    _mMessageTimeLab.layer.cornerRadius = 3;
    
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mHeaderImgBtn.backgroundColor =  [UIColor brownColor];
    _mHeaderImgBtn.tag = 10;
    _mHeaderImgBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:_mHeaderImgBtn];
     _mHeaderImgBtn.layer.cornerRadius = 5;
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(onHeadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPgr =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
     longPgr.minimumPressDuration = 0.5;
    [_mHeaderImgBtn addGestureRecognizer:longPgr];
    
    
    // 创建昵称
    _nicknameLabel = [UILabel new];
    _nicknameLabel.bounds = CGRectMake(FYChatIconLeftOrRight*2 + SSChatIconWH,SSChatCellTopOrBottom, FYChatNameWidth, FYChatNameHeight);
    [self.contentView addSubview:_nicknameLabel];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _nicknameLabel.textColor = [UIColor darkGrayColor];
    
    
    //背景按钮
    _bubbleBackView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleBackViewAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_bubbleBackView addGestureRecognizer:tap];
    _bubbleBackView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleBackView];
    
    //traningActivityIndicator
    _traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [self.contentView addSubview:_traningActivityIndicator];
//    _traningActivityIndicator.backgroundColor = [UIColor redColor];
    _traningActivityIndicator.color = [UIColor darkGrayColor];
    _traningActivityIndicator.hidden = YES;
    
//    _bubbleBackView.backgroundColor = [UIColor greenColor];
   // 高度   45 + 10 + 名称(12) + 4 + 消息内容高度（？）+ 10
    
    _errorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
//    _errorBtn.backgroundColor = [UIColor redColor];
    [_errorBtn setBackgroundImage:[UIImage imageNamed:@"message_ic_warning"] forState:UIControlStateNormal];
    _errorBtn.hidden = YES;
    [_errorBtn addTarget:self action:@selector(onErrorBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_errorBtn];
    
}


- (void)onErrorBtn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onErrorBtnCell:)]){
        [self.delegate onErrorBtnCell:self.model.message];
    }
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)setModel:(FYMessagelLayoutModel *)model{
    _model = model;
    
    _mMessageTimeLab.hidden = !model.message.showTime;
    _mMessageTimeLab.text = [FYIMKitUtil showTime:model.message.timestamp/1000 showDetail:YES];
    [_mMessageTimeLab sizeToFit];
    _mMessageTimeLab.height = SSChatTimeHeight;
    _mMessageTimeLab.width += 20;
    _mMessageTimeLab.centerX = FYSCREEN_Width*0.5;
    _mMessageTimeLab.top = SSChatTimeTopOrBottom;
    
    self.nicknameLabel.frame = model.nickNameRect;
    if (model.message.messageFrom == FYMessageDirection_SEND) {
        self.nicknameLabel.text = @"";
    } else {
        self.nicknameLabel.text = model.message.user.nick;
    }
    
    self.mHeaderImgBtn.frame = model.headerImgRect;
    [self.mHeaderImgBtn cd_setImageWithURL:[NSURL URLWithString:model.message.user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user-default"]];

//    [self.mHeaderImgBtn setBackgroundImage:[UIImage imageNamed:@"touxaing2"] forState:UIControlStateNormal];
    
    // 接收
    if(model.message.messageFrom == FYMessageDirection_RECEIVE){
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        _nicknameLabel.textAlignment = NSTextAlignmentRight;
    }
 
}




/**
 点击头像

 @param sender UIButton
 */
-(void)onHeadImageBtn:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapCellChatHeaderImg:)]){
        [self.delegate didTapCellChatHeaderImg:self.model.message.user];
    }
}


// 头像长按手势
-(void)longPress:(UILongPressGestureRecognizer *)longPressGesture {
    // 当识别到长按手势时触发(长按时间到达之后触发)
    if (UIGestureRecognizerStateBegan ==longPressGesture.state) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLongPressCellChatHeaderImg:)]){
            [self.delegate didLongPressCellChatHeaderImg:self.model.message.user];
        }
    }
}




// 点击消息背景事件
-(void)bubbleBackViewAction:(UIImageView *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]){
        [self.delegate didTapMessageCell:self.model.message];
    }
}

@end
