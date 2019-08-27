//
//  SSChatDatas.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//


#import "SSChatDatas.h"
#import "EnvelopeMessage.h"
#import "NSTimer+SSAdd.h"

#define headerImg1  @"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
#define headerImg2  @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg"
#define headerImg3  @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg"

@implementation SSChatDatas

//处理接收的消息数组
+(NSMutableArray *)receiveMessages:(NSArray *)messages{
    
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dic in messages){
        FYMessagelLayoutModel *layout = [SSChatDatas getMessageWithData:dic];
        [array addObject:layout];
    }
    return array;
}

//接受一条消息
+(FYMessagelLayoutModel *)receiveMessage:(id)message{
    return [SSChatDatas getMessageWithData:message];
}

//消息内容生成消息模型
+(FYMessagelLayoutModel *)getMessageWithData:(id)data {
    
    FYMessage *message;
    if ([data isKindOfClass:[FYMessage class]]) {
        message = data;
    } else {
        message = [FYMessage mj_objectWithKeyValues:data];
    }
    //    FYMessage *message = [FYMessage mj_objectWithKeyValues:dic];
    
    if (message.messageFrom != FYChatMessageFromSystem) {
        
        if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            message.messageFrom = FYMessageDirection_SEND;
        } else {
            message.messageFrom  = FYMessageDirection_RECEIVE;
        }
        
        //    message.textColor    = SSChatTextColor;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userKey = [NSString stringWithFormat:@"%@%@", message.sessionId, [AppModel shareInstance].userInfo.userId];
        if([user valueForKey:userKey] == nil){
            [user setValue:@(message.timestamp/1000) forKey:userKey];
            message.showTime = YES;
        }else{
            [message showTimeWithLastShowTime:[[user valueForKey:userKey] doubleValue] currentTime:message.timestamp/1000];
            if(message.showTime){
                [user setValue:@(message.timestamp/1000) forKey:userKey];
            }
        }
        
        // 默认气泡图片
        if(message.messageFrom == FYMessageDirection_SEND){
            message.backImgString = @"icon_qipao1";
        }else{
            message.backImgString = @"icon_qipao2";
        }
    }

    
    if((message.messageType == FYMessageTypeText && message.messageFrom != FYChatMessageFromSystem) || message.messageType == FYMessageTypeReportAwardInfo){
        message.cellString   = SSChatTextCellId;
    } else if(message.messageType == FYMessageTypeRedEnvelope){
        message.cellString   = FYRedEnevlopeCellId;
        if ([data isKindOfClass:[NSDictionary class]]) {
            EnvelopeMessage *reMessage = [EnvelopeMessage mj_objectWithKeyValues:[message.text mj_JSONObject]];
            message.redEnvelopeMessage  = reMessage;
        }
    } else if(message.messageType == FYMessageTypeNoticeRewardInfo){
        message.cellString   = CowCowVSMessageCellId;
        NSDictionary *dict = [message.text mj_JSONObject];
        message.cowcowRewardInfoDict  = dict;
    } else if(message.messageFrom == FYChatMessageFromSystem) {
        message.cellString   = NotificationMessageCellId;
        message.showTime = NO;
    } else if(message.messageType == FYMessageTypeImage) {  // 图片
        message.cellString   = SSChatImageCellId;
        if (message.isReceivedMsg) {
            NSDictionary *imageDict = (NSDictionary *)[message.text mj_JSONObject];
            message.imageUrl  = imageDict[@"url"];
        }
    }
    
    FYMessagelLayoutModel *layout = [[FYMessagelLayoutModel alloc]initWithMessage:message];
    return layout;
    
}




// 发送一条消息
+(void)sendMessage:(FYMessage *)message messageBlock:(MessageBlock)messageBlock {
    
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:nil];
    
    long time = [NSTimer getLocationTimeStamp];
    
    switch (message.messageType) {
        case FYMessageTypeText:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
        }
            break;
        case FYMessageTypeImage:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
            
        }
            break;
        case FYMessageTypeVoice:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:@(time) forKey:@"date"];
            //            [messageDic setValue:@(messageType) forKey:@"type"];
            //            [messageDic setValue:messageId forKey:@"messageId"];
            //            [messageDic setValue:sessionId forKey:@"sessionId"];
            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case FYMessageTypeMap:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:@(time) forKey:@"date"];
            //            [messageDic setValue:@(messageType) forKey:@"type"];
            //            [messageDic setValue:messageId forKey:@"messageId"];
            //            [messageDic setValue:sessionId forKey:@"sessionId"];
            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case FYMessageTypeVideo:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:@(time) forKey:@"date"];
            //            [messageDic setValue:@(messageType) forKey:@"type"];
            //            [messageDic setValue:messageId forKey:@"messageId"];
            //            [messageDic setValue:sessionId forKey:@"sessionId"];
            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case FYMessageTypeRedEnvelope:{
            [messageDic setValue:@(time) forKey:@"createTime"]; // 时间
            //            [messageDic setValue:dict[@"chatType"] forKey:@"chatType"];  // 1 群聊   2  p2p
            //            [messageDic setValue:@(messageType) forKey:@"msgType"];
            //            [messageDic setValue:messageId forKey:@"id"];  // 消息ID
            //            [messageDic setValue:sessionId forKey:@"chatId"];  // 群ID
        }
            break;
            
        default:
            break;
    }
    
    FYMessagelLayoutModel *layout = [SSChatDatas getMessageWithData:message];
    NSProgress *pre = [[NSProgress alloc]init];
    
    messageBlock(layout,nil,pre);
}


@end
