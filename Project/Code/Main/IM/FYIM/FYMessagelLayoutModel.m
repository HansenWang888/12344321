//
//  FYMessagelLayoutModel.m
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYMessagelLayoutModel.h"
#import "SSChatDatas.h"
#import "SSChatIMEmotionModel.h"
#import "NSObject+SSAdd.h"
#import "FYMessage.h"


@implementation FYMessagelLayoutModel

//根据模型返回布局
-(instancetype)initWithMessage:(FYMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}


-(void)setMessage:(FYMessage *)message {
    _message = message;
    
    if (message.messageType == FYMessageTypeImage && message.messageFrom == FYChatMessageFromSystem) {
        [self setSystemMessage];
        return;
    }
    
    switch (message.messageType) {
        case FYMessageTypeText:
        case FYMessageTypeReportAwardInfo:
            [self setText];
            break;
        case FYMessageTypeRedEnvelope:
            [self setRedEnvelope];
            break;
        case FYMessageTypeNoticeRewardInfo:
            [self setCowCowRewardInfo];
            return;
        case FYMessageTypeImage:
            [self setImage];
            break;
        case FYMessageTypeVoice:
            [self setVoice];
            break;
        case FYMessageTypeMap:
            [self setMap];
            break;
        case FYMessageTypeVideo:
            [self setVideo];
            break;
            
        case FYMessageTypeUndo:
            [self setRecallMessage];
            break;
        case FYMessageTypeDelete:
            [self setRemoveMessage];
            break;
        default:
            break;
    }
    [self setCommonView];
}

#pragma mark - 公共部分
- (void)setCommonView {
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _nickNameRect = CGRectMake(FYChatIconLeftOrRight*2 + SSChatIconWH,SSChatCellTopOrBottom, FYChatNameWidth, FYChatNameSpacingHeight-4);
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _nickNameRect = CGRectMake(0,0, 0, 0);
    }
    
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom * 2 + SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        CGRect userRect = self.nickNameRect;
        userRect.origin.y = SSChatTimeTopOrBottom * 2 + SSChatTimeHeight;
        self.nickNameRect = userRect;
        
        CGFloat bubbleY;
        if(_message.messageFrom == FYMessageDirection_RECEIVE){
            bubbleY = _nickNameRect.origin.y + FYChatNameSpacingHeight;
        } else {
            bubbleY = _nickNameRect.origin.y;
        }
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, bubbleY, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
        
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + SSChatCellTopOrBottom;
    
}

#pragma mark - 红包
-(void)setRedEnvelope {
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, FYRedEnvelopeBackWidth, FYRedEnvelopeBackHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _textLabRect.origin.x = SSChatTextLRB;
        _textLabRect.origin.y = SSChatTextTop;
        
    }else{
        
        //        _bubbleBackViewRect = CGRectMake( SSChatIcon_RX - FYRedEnvelopeBackWidth - FYChatIconLeftOrRight, SSChatCellTopOrBottom +FYChatNameSpacingHeight, FYRedEnvelopeBackWidth, FYRedEnvelopeBackHeight);
        _bubbleBackViewRect = CGRectMake( SSChatIcon_RX - FYRedEnvelopeBackWidth - FYChatIconLeftOrRight, SSChatCellTopOrBottom, FYRedEnvelopeBackWidth, FYRedEnvelopeBackHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _textLabRect.origin.x = SSChatTextLRS;
        _textLabRect.origin.y = SSChatTextTop;
    }
}

#pragma mark - 文本
-(void)setText {
    
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, 0, SSChatTextInitWidth, 100);
    mTextView.attributedText = _message.attTextString;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
    
    _textLabRect = mTextView.bounds;// [NSObject getRectWith:_message.attTextString width:SSChatTextInitWidth];
    
    CGFloat textWidth  = _textLabRect.size.width;
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _textLabRect.origin.x = SSChatTextLRB;
        _textLabRect.origin.y = SSChatTextTop;
        
    } else {
        
        //        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatTextLRB-textWidth-SSChatTextLRS, SSChatCellTopOrBottom +FYChatNameSpacingHeight, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatTextLRB-textWidth-SSChatTextLRS, SSChatCellTopOrBottom, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _textLabRect.origin.x = SSChatTextLRS;
        _textLabRect.origin.y = SSChatTextTop;
    }
    
}

#pragma mark - 牛牛报奖信息
-(void)setCowCowRewardInfo {
    
    NSInteger height = 20 + 10;
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    if(_message.showTime==YES){
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
    }
    _cellHeight =  _timeLabRect.origin.y + SSChatTimeHeight + SSChatTimeTopOrBottom +  + CowBackImageHeight + height;
    
}

#pragma mark - 系统消息
-(void)setSystemMessage {
    
    _cellHeight =  40;
    
}

#pragma mark - 图片消息
-(void)setImage {
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (_message.isReceivedMsg) {
         NSDictionary *imageDict = (NSDictionary *)[_message.text mj_JSONObject];
        imgWidth  = [imageDict[@"width"] floatValue];
        imgHeight = [imageDict[@"height"] floatValue];
    } else {
       imgWidth = [_message.selectPhoto[@"width"] floatValue];
       imgHeight = [_message.selectPhoto[@"height"] floatValue];
    }
    
    CGSize realImageSize = CGSizeMake(imgWidth, imgHeight);
    
    
    if (imgWidth == 0) {
        imgWidth = 100;
    }
    if (imgHeight == 0) {
        imgHeight = 100;
    }
    CGSize imageSize = [self contentSize:SCREEN_WIDTH size:realImageSize];
    
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight- imageSize.width, self.headerImgRect.origin.y, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom;
    
}

- (CGSize)contentSize:(CGFloat)cellWidth size:(CGSize)size
{
    CGFloat attachmentImageMinWidth  = (cellWidth / 4.0);
    CGFloat attachmentImageMinHeight = (cellWidth / 4.0);
    CGFloat attachmemtImageMaxWidth  = (cellWidth - 184);
    CGFloat attachmentImageMaxHeight = (cellWidth - 184);
    
    
    CGSize imageSize;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        imageSize = size;
    }
    else
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_message.imageUrl]]];
        //        UIImage *image = [UIImage imageWithContentsOfFile:_message.imageUrl];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize contentSize = [self sizeWithImageOriginSize:imageSize
                                               minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                               maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight )];
    return contentSize;
}


- (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

-(void)setVoice{
    
    //计算时间
    CGRect rect = [NSObject getRectWith:_message.voiceTime width:150 font:[UIFont systemFontOfSize:SSChatVoiceTimeFont] spacing:0 Row:0];
    CGFloat timeWidth  = rect.size.width;
    CGFloat timeHeight = rect.size.height;
    
    //根据时间设置按钮实际长度
    CGFloat timeLength = SSChatVoiceMaxWidth - SSChatVoiceMinWidth;
    CGFloat changeLength = timeLength/60;
    CGFloat currentLength = changeLength*_message.voiceDuration+SSChatVoiceMinWidth;
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y, currentLength, SSChatVoiceHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _voiceTimeLabRect = CGRectMake(_bubbleBackViewRect.size.width-timeWidth-10, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(20, (_bubbleBackViewRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
        
    }else{
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-currentLength, self.headerImgRect.origin.y, currentLength, SSChatVoiceHeight);
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _voiceTimeLabRect = CGRectMake(10, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(_bubbleBackViewRect.size.width-SSChatVoiceImgSize-20, (_bubbleBackViewRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom;
    
}


-(void)setMap{
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatMapWidth, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom;
    
}

//短视频
-(void)setVideo{
    
    //    CGFloat imgWidth  = CGImageGetWidth(_message.videoImage.CGImage);
    //    CGFloat imgHeight = CGImageGetHeight(_message.videoImage.CGImage);
    CGFloat imgWidth  = 100;
    CGFloat imgHeight = 100;
    
    CGFloat imgActualHeight = SSChatImageMaxSize;
    CGFloat imgActualWidth =  SSChatImageMaxSize * imgWidth/imgHeight;
    
    if(imgActualWidth>SSChatImageMaxSize){
        imgActualWidth = SSChatImageMaxSize;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y, imgActualHeight, imgActualWidth);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-imgActualWidth, self.headerImgRect.origin.y, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + SSChatCellTopOrBottom;
    
}



//显示支付定金订单信息
-(void)setOrderValue1{
    
    
}

//显示直接购买订单信息
-(void)setOrderValue2{
    
    
}


//撤销的消息
-(void)setRecallMessage{
    
    
}


//删除的消息
-(void)setRemoveMessage{
    
    
    
}







@end
