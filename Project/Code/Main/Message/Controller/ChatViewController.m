//
//  ChatViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EnvelopeMessage.h"
#import "MessageNet.h"
#import "EnvelopeTipCell.h"
#import "EnvelopeTipMessage.h"
#import "SendRedEnvelopeController.h"
#import "MessageItem.h"
#import "GroupInfoViewController.h"
#import "WebViewController.h"
#import "IQKeyboardManager.h"
#import "EnvelopeNet.h"
#import "BANetManager_OC.h"
#import "SqliteManage.h"
#import "RedEnvelopeAnimationView.h"

#import "RedEnvelopeDetListController.h"
#import "CowCowVSMessageCell.h"
#import "ImageDetailViewController.h"
#import "NotificationMessageModel.h"
#import "NotificationMessageCell.h"
#import "WithdrawMainViewController.h"
#import "BecomeAgentViewController.h"
#import "ShareViewController.h"
#import "AlertViewCus.h"
#import "Recharge2ViewController.h"
#import "HelpCenterWebController.h"
#import "CustomerServiceAlertView.h"
#import "AgentCenterViewController.h"

#import "FYContacts.h"
#import "FriendChatInfoController.h"


@interface ChatViewController ()<FYSystemBaseCellDelegate>

@property (nonatomic, strong) MessageItem *messageItem;
// 红包详情模型
@property (nonatomic,strong) EnvelopeNet *enveModel;
// 抢红包视图
@property (nonatomic,strong) RedEnvelopeAnimationView *redpView;
// 红包动画是否结束
@property (nonatomic,assign) BOOL isAnimationEnd;
// 抢红包结果数据
@property (nonatomic,assign) id response;
// 消息ID
@property (nonatomic, copy) NSString *messageId;
// 定时器
@property (nonatomic,strong) NSTimer *timerView;
// 聊天定时器
@property (nonatomic,strong) NSTimer *chatTimer;
@property (nonatomic,assign) BOOL isChatTimer;


@property(nonatomic, strong) UIBarButtonItem *leftBtn;
@property(nonatomic, strong) NSArray *rightBtnArray;
//
@property (nonatomic,assign) BOOL isCreateRpView;
@property (nonatomic,assign) BOOL isVSViewClick;
// 播放音乐
@property (nonatomic,strong) AVAudioPlayer *player;

// 消息体数据
//@property (nonatomic,strong) RCMessageModel *messageModel;
@property (nonatomic,copy) NSString *bankerId;


@end


// 群组类
@implementation ChatViewController

static ChatViewController *_chatVC;

// 群聊
+ (ChatViewController *)groupChatWithObj:(MessageItem *)obj {
    
    _chatVC = [[ChatViewController alloc] initWithConversationType:FYConversationType_GROUP
                                                          targetId:obj.groupId];
    //设置会话的类型，如单聊、群聊、聊天室、客服、公众服务会话等
    _chatVC.messageItem = obj;
    //设置聊天会话界面要显示的标题
    NSString *title = obj.chatgName;
    NSRange range = [title rangeOfString:@"("];
    if(range.length == 0)
        range = [title rangeOfString:@"（"];
    if(range.length > 0)
        title = [title substringToIndex:range.location];
    if(title.length == 0)
        title = @"群组";
    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    }else
        _chatVC.title = title;
  
    
    return _chatVC;
}

// 单聊
+ (ChatViewController *)privateChatWithModel:(FYContacts *)model {
    _chatVC = [[ChatViewController alloc] initWithConversationType:FYConversationType_PRIVATE
                                                          targetId:model.sessionId];
    //设置聊天会话界面要显示的标题
    NSString *title = model.nick;
    NSRange range = [title rangeOfString:@"("];
    if(range.length == 0)
        range = [title rangeOfString:@"（"];
    if(range.length > 0)
        title = [title substringToIndex:range.location];
    if(title.length == 0)
        title = @"";
    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    }else
        _chatVC.title = title;
    return _chatVC;
}

+ (ChatViewController *)currentChat {
    return _chatVC;
}



- (void)notifyUpdateUnreadMessageCount {
    // 解决点击 更多... 取消返回不了的bug
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItems = self.rightBtnArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = BaseColor;
    
    //    [self initSubviews];
    [self setNavUI];
    [self initLayout];
    [self addFloatBUttons];
    self.enveModel = [EnvelopeNet shareInstance];
    
    
    // 多条消息提示
    //    self.enableUnreadMessageIcon = YES;
    //    self.enableNewComingMessageIcon = YES;
    [self updateUnreadMessage];
    
    self.leftBtn = self.navigationItem.leftBarButtonItem;
    self.rightBtnArray = self.navigationItem.rightBarButtonItems;
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    __weak __typeof(self)weakSelf = self;
    if (weakSelf.chatType == FYConversationType_GROUP) {

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addOrDeleteMembers:) name:@"addOrDeleteMembers" object:nil];
    }
    
    if (self.isNewMember) {
        [self sendWelcomeMessage:self.sessionId];
    }
}
#pragma mark - 添加悬浮的玩法 加盟 按钮
- (void)addFloatBUttons {
    //   群聊才有
    if (self.chatType != FYConversationType_GROUP) {
        return;
    }
    NSArray *images = @[@"chat-recharge",@"chat-playWay", @"chat-union"];
    NSArray *titles = @[@"充值",@"玩法",@"加盟"];
 
    CGFloat navH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat btnTop = navH + 44;
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10 + idx;
        [btn setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.top.mas_equalTo(btnTop + 20 + 70 * idx);
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];

        [btn addTarget:self action:@selector(floatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize2:12];
        lab.textColor = UIColor.lightGrayColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = titles[idx];
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.top.mas_equalTo(btn.mas_bottom).offset(5);
        }];

    }];
}

- (void)floatBtnClick:(UIButton *)sender {
    
    NSArray *array = @[@"Recharge2ViewController",@"WebViewController",@"AgentCenterViewController"];
    UIViewController *vc = [NSClassFromString(array[sender.tag % 10]) new];
    if (sender.tag == 11) {
        vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//删除好友
- (void)addOrDeleteMembers:(NSNotification *)not{
    NSDictionary *dict = not.object;
    NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
    NSInteger command = [dict[@"command"] integerValue];
    NSLog(@"%@",msg);
    if (command == 33 ){
        SVP_ERROR_STATUS(msg);
        [self performSelectorOnMainThread:@selector(onBack) withObject:nil waitUntilDone:YES];

    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - subView
- (void)initSubviews {
    [self chatBarControl];
}

- (void)setNavUI {
    
    if (self.chatType == FYConversationType_GROUP) {
        UIButton *redpiconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [redpiconBtn setImage:[UIImage imageNamed:@"redPacketIcon"] forState:UIControlStateNormal];
        redpiconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [redpiconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [redpiconBtn addTarget:self action:@selector(goto_sendRedEnvelopeEnt) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *exItem = [[UIBarButtonItem alloc]initWithCustomView:redpiconBtn];
        
        UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [info setImage:[UIImage imageNamed:@"group-info"] forState:UIControlStateNormal];
        
        [info addTarget:self action:@selector(goto_GroupInfo) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
        if (self.messageItem.officeFlag){
            
            self.navigationItem.rightBarButtonItems = @[infoItem,exItem];
        }else{
            self.navigationItem.rightBarButtonItems = @[infoItem];
        }
        
    } else if (self.chatType == FYConversationType_PRIVATE) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group-info"] style:UIBarButtonItemStyleDone target:self action:@selector(goto_userInfo)];
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    }

}
- (void)onBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - VS 视图查看详情 goto

// 点击VS牛牛Cell消息背景视图
- (void)didTapVSCowcowCell:(FYMessage *)model {
    if (self.isVSViewClick) {
        return;
    }
    self.isVSViewClick = YES;
    
    self.bankerId = [[model.cowcowRewardInfoDict objectForKey:@"userId"] stringValue];
    //    [self vsViewGetRedPacketDetailsData:[model.cowcowRewardInfoDict objectForKey:@"id"]];
    NSString *redId = [[model.cowcowRewardInfoDict objectForKey:@"id"] stringValue];
    [self goto_RedPackedDetail:redId isCowCow:NO];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager]setEnable:NO];
    self.extendedLayoutIncludesOpaqueBars = YES;  // 防止导航栏下移64
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
//    self.hidesBottomBarWhenPushed = NO;
}




#pragma mark - Layout
- (void)initLayout {
    
}


- (void)chatBarControl {
    
}


#pragma mark - 聊天功能扩展拦
//多功能视图点击回调  图片10  视频11  位置12
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag {
    
        NSLog(@"%ld",tag);
    [self.view endEditing:YES];
    if (tag == 2000) { //福利红包
        SendRedEnvelopeController *vc = [[SendRedEnvelopeController alloc] init];
        vc.isFu = YES;
        vc.CDParam = _messageItem;
        UINavigationController *navvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navvc animated:YES completion:nil];
        
    } else if (tag == 2001){ // 加盟
        AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 2002){  // 红包
        UINavigationController *vc;
        if (_messageItem.type == 3) {
            vc = [[UINavigationController alloc]initWithRootViewController:CDPVC(@"NoRobSendRPController", _messageItem)];
        } else {
            vc = [[UINavigationController alloc]initWithRootViewController:CDPVC(@"SendRedEnvelopeController", _messageItem)];
        }
        [self presentViewController:vc animated:YES completion:nil];
    } else if (tag == 2003){
        UIViewController *vc = [[Recharge2ViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tag == 2004){// 玩法
        if (self.messageItem.officeFlag) {
            ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
            vc.imageUrl = self.messageItem.howplayImg;
            vc.hiddenNavBar = YES;
            vc.title = @"玩法";
            [self.navigationController pushViewController:vc animated:YES];
        }else{//自建群的玩法
            WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
            vc.navigationItem.title = @"玩法规则";
            vc.hidesBottomBarWhenPushed = YES;
            //[vc loadWithURL:url];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tag == 2005){   // 群规
        [self groupRuleView];
    } else if (tag == 2006){  // 帮助
        // 输入扩展功能板View
        //        [super fyChatFunctionBoardClickedItemWithTag:tag];
        HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 2007){  // 客服
        [self actionShowCustomerServiceAlertView:nil];
    } else if (tag == 2008){ // 照片
//        if ([self.messageItem.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {

            if (self.chatType == FYConversationType_GROUP) {
                if ([AppModel shareInstance].userInfo.innerNumFlag
                    ||[AppModel shareInstance].userInfo.groupowenFlag || !self.messageItem.officeFlag) {
                    [super fyChatFunctionBoardClickedItemWithTag:10];
                }
            }else{
                
                [super fyChatFunctionBoardClickedItemWithTag:10];
            }
//        }
        
        //         [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        
        //        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    } else if (tag == 2009){ // 拍照
//        if ([self.messageItem.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            if (self.chatType == FYConversationType_GROUP) {
                if ([AppModel shareInstance].userInfo.innerNumFlag
                    ||[AppModel shareInstance].userInfo.groupowenFlag ||!self.messageItem.officeFlag) {
                    [super fyChatFunctionBoardClickedItemWithTag:11];
                }
            }else{
                
                [super fyChatFunctionBoardClickedItemWithTag:11];
            }
//        }
        
//        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    } else if(tag == 2010){  // 赚钱
        PUSH_C(self, ShareViewController, YES);
    } else if(tag == 2020){  // 玩法规则
        WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
        vc.navigationItem.title = @"玩法规则";
        vc.hidesBottomBarWhenPushed = YES;
        //[vc loadWithURL:url];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        
    }
    
}

#pragma mark -  群规
- (void)groupRuleView {
    ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
    vc.imageUrl = self.messageItem.ruleImg;
    vc.hiddenNavBar = YES;
    vc.title = @"群规";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - override Cell点击事件
// cell点击事件
- (void)didTapMessageCell:(FYMessage *)model {
    [super didTapMessageCell:model];
    [self.view endEditing:YES];
    
    if (model.messageType  == FYMessageTypeRedEnvelope) {
        // 发送者ID
        self.bankerId = model.messageSendId;
        if (self.isCreateRpView) {
            return;
        }
        self.isCreateRpView = YES;
        [self getRedPacketDetailsData:model];
    }
}

#pragma mark 获取红包详情
/**
 获取红包详情
 
 @param messageModel RCMessageModel
 */
- (void)getRedPacketDetailsData:(FYMessage *)messageModel {
    
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [_enveModel getRedpDetSendId:messageModel.redEnvelopeMessage.redpacketId successBlock:^(NSDictionary *success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SVP_DISMISS;
        if ([[success objectForKey:@"code"] integerValue] == 0) {
            if ([messageModel.redEnvelopeMessage.cellStatus integerValue] == 1) {
                [strongSelf goto_RedPackedDetail:strongSelf.enveModel isCowCow:YES];
            } else {
                [strongSelf actionShowRedPackedView:messageModel];
            }
        } else {
            strongSelf.isCreateRpView = NO;
            [[FunctionManager sharedInstance] handleFailResponse:success];
        }
        
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isCreateRpView = NO;
        SVP_DISMISS;
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
    
}

//- (void)vsViewGetRedPacketDetailsData:(NSString *)redpId {
//
//    SVP_SHOW;
//    __weak __typeof(self)weakSelf = self;
//    [_enveModel getRedpDetSendId:redpId successBlock:^(NSDictionary *success) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        SVP_DISMISS;
//        if ([[success objectForKey:@"code"] integerValue] == 0) {
//            [strongSelf goto_RedPackedDetail:strongSelf.enveModel];
//        } else {
//            [[FunctionManager sharedInstance] handleFailResponse:success];
//        }
//    } failureBlock:^(NSError *error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        SVP_DISMISS;
//        strongSelf.isVSViewClick = NO;
//        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [[FunctionManager sharedInstance] handleFailResponse:error];
//    }];
//}

#pragma mark - 好友聊天信息页
- (void)goto_FriendChatInfo:(FYContacts *)contacts {
    [self.view endEditing:YES];
    FriendChatInfoController *vc = [[FriendChatInfoController alloc] init];
    vc.contacts = contacts;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击头像事件
// 点击头像事件
//- (void)didTapCellPortrait:(NSString *)userId {
-(void)didTapCellChatHeaderImg:(UserInfo *)userInfo {
    
    if (self.chatType == FYConversationType_PRIVATE || self.chatType == FYConversationType_CUSTOMERSERVICE) {
        // 聊天信息页
//        [self goto_FriendChatInfo:userInfo];
        return;
    }
    
    [self.view endEditing:YES];
    if ([userInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        return;
    }
    [self.sessionInputView addMentionedUser:userInfo];
}


// 长按头像
-(void)didLongPressCellChatHeaderImg:(UserInfo *)userInfo {
    [self.view endEditing:YES];
    
    // 自己
    if ([userInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        return;
    }
    
    //    if ([self.messageItem.userId isEqualToString:[AppModel shareInstance].userInfo.userId] ) {
    //       [self.sessionInputView addMentionedUser:userInfo];
    //    }
    
    // 群主
    if ([AppModel shareInstance].userInfo.innerNumFlag) {
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:[NSString stringWithFormat:@"昵称：%@\nID：%@",userInfo.nick,userInfo.userId] button:@"好的" callBack:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 抢红包
//- (void)action_tapCustom:(RCMessageModel *)messageModel {
- (void)action_tapCustom:(FYMessage *)messageModel {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"redpacket/redpacket/grab"];
    NSDictionary *parameters = @{
                                 @"packetId":messageModel.redEnvelopeMessage.redpacketId
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    self.response = nil;
    _timerView = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadTimer:) userInfo:nil repeats:NO];
    
    //    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        SVP_DISMISS;
        //        NSLog(@"post 请求数据结果： *** %@", response);
        
        strongSelf.response = response;
        strongSelf.messageId = messageModel.messageId;
        [strongSelf redPackedStatusJudgmentResponse:response];
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        SVP_DISMISS;
        [strongSelf uploadTimer:nil];
        [[FunctionManager sharedInstance] handleFailResponse:error];
        [strongSelf.redpView disMissRedView];
    } progressBlock:nil];
    
}


- (AVAudioPlayer *)player {
    if (!_player) {
        // 1. 创建播放器对象
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"success.mp3" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        //        _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}



-(void)uploadTimer:(NSTimer*)timer {
    self.isAnimationEnd = YES;
    
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
    
    if (_timerView != nil) {
        [_timerView invalidate];
    }
}


#pragma mark -  抢包视图动画结束
/**
 红包动画判断
 */
- (void)redpackedAnimationJudgment {
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
}


#pragma mark -  抢包后红包状态判断
- (void)redPackedStatusJudgmentResponse:(id)response {
    
    if (self.isAnimationEnd == NO) {
        return;
    }
    
    NSInteger code = [[response objectForKey:@"code"] integerValue];
    if ([response objectForKey:@"code"] && code == 0) {
        // 正常
        [self.redpView disMissRedView];
        [self goto_RedPackedDetail:self.enveModel isCowCow:YES];
        [self updateRedPackedStatus:self.messageId cellStatus:@"1"];
        
#pragma mark - 声音
        NSString *switchKeyStr = [NSString stringWithFormat:@"%@-%@", [AppModel shareInstance].userInfo.userId,_messageItem.groupId];
        // 读取
        BOOL  isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
        if (!isSwitch && ![AppModel shareInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
            [self.player play];
#endif
        }
        
    } else {
        NSInteger code = [[response objectForKey:@"errorcode"] integerValue];
        [self.redpView updateView:_enveModel.redPackedInfoDetail response:response rpOverdueTime:self.messageItem.rpOverdueTime];
        if (code == 11) {
            // 红包已抢完
            [self updateRedPackedStatus:self.messageId cellStatus:@"2"];
        } else if (code == 12) {
            // 已抢过红包
            [self updateRedPackedStatus:self.messageId cellStatus:@"1"];
        } else if (code == 13) {
            // 余额不足
        } else if (code == 14) {
            // 通讯异常，请重试
        } else if (code == 15) {
            // 单个红包金额不足0.01
        } else if (code == 16) {
            // 红包已逾期
            [self updateRedPackedStatus:self.messageId cellStatus:@"3"];
        } else if (code == 17) {
        } else {
        }
        
    }
    
}



/**
 抢红包视图
 
 @param messageModel 红包信息
 */
- (void)actionShowRedPackedView:(FYMessage *)messageModel {
    self.isAnimationEnd = NO;
    RedEnvelopeAnimationView *view = [[RedEnvelopeAnimationView alloc]initWithFrame:self.view.bounds];
    [view updateView:_enveModel.redPackedInfoDetail response:nil rpOverdueTime:self.messageItem.rpOverdueTime];
    self.redpView = view;
    
    __weak __typeof(self)weakSelf = self;
    
    // 开红包
    view.openBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf action_tapCustom:messageModel];
    };
    // 查看详情
    view.detailBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goto_RedPackedDetail:strongSelf.enveModel isCowCow:YES];
    };
    // 视图消失
    view.animationBlock = ^{
        //        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"1"];
        return ;
    };
    // 动画结束Block
    view.animationEndBlock = ^{
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        strongSelf.isAnimationEnd = YES;
        //        [strongSelf redpackedAnimationJudgment];
        return ;
    };
    // View消失Block
    view.disMissRedBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isCreateRpView = NO;
        return ;
    };
    
    NSInteger status = [[_enveModel.redPackedInfoDetail objectForKey:@"status"] integerValue];
    NSInteger left = [[_enveModel.redPackedInfoDetail objectForKey:@"left"] integerValue];
    
    if (status == 2) {
        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"3"];
    }
    if (status == 1 && left == 0) {
        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"2"];
    }
    
    [view showInView:self.view];
}

/**
 更新红包状态
 
 @param messageId 消息ID
 @param cellStatus 红包状态 0 没有点击(红包没抢)  1 已点击(红包已抢)  2 已点击(红包已抢完） 3 已点击(红包已过期)
 */
- (void)updateRedPackedStatus:(NSString *)messageId cellStatus:(NSString *)cellStatus {
    
    for (FYMessagelLayoutModel *modelLayout in self.dataSource) {
        if (messageId == modelLayout.message.messageId) {
            modelLayout.message.redEnvelopeMessage.cellStatus = cellStatus;
            [[FYIMManager shareInstance] setRedEnvelopeMessage:messageId redEnvelopeMessage:modelLayout.message.redEnvelopeMessage];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark -  goto红包详情
- (void)goto_RedPackedDetail:(id)obj isCowCow:(BOOL)isCowCow {
    [self.view endEditing:YES];
    self.isVSViewClick = NO;
    RedEnvelopeDetListController *vc = [[RedEnvelopeDetListController alloc] init];
    vc.isCowCow = isCowCow;
    vc.isRightBarButton = YES;
    
    NSString *redPackedId;
    if ([obj isKindOfClass:[EnvelopeNet class]]) {
        EnvelopeNet *model = (EnvelopeNet *)obj;
        redPackedId = [model.redPackedInfoDetail[@"id"] stringValue];
    } else {
        redPackedId = (NSString *)obj;
    }
    vc.redPackedId = redPackedId;
    vc.bankerId = self.bankerId;
    vc.returnPackageTime = [_messageItem.rpOverdueTime floatValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark goto发红包入口
/**
 发红包入口
 */
-(void)goto_sendRedEnvelopeEnt {
    [self.view endEditing:YES];
    
    UINavigationController *vc;
    if (_messageItem.type == 3) {
        vc = [[UINavigationController alloc]initWithRootViewController:CDPVC(@"NoRobSendRPController", _messageItem)];
    } else {
        vc = [[UINavigationController alloc]initWithRootViewController:CDPVC(@"SendRedEnvelopeController", _messageItem)];
    }
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Group info 群信息
/**
 Group Info
 */
- (void)goto_GroupInfo {
    [self.view endEditing:YES];
    GroupInfoViewController *vc = [GroupInfoViewController groupVc:_messageItem];
    vc.block = ^(NSString *text) {
        self.navigationItem.title = text;
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 用户聊天信息
/**
 user Info
 */
- (void)goto_userInfo {
    [self.view endEditing:YES];
    [self goto_FriendChatInfo:self.toContactsModel];
}


// 返回前一个页面的方法
- (void)leftBarButtonItemPressed:(id)sender{
    //    [super leftBarButtonItemPressed:sender];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    
    if(!parent){
        _chatVC = nil;
        
    }
}


#pragma mark - 即将发送消息
- (FYMessage *)willSendMessage:(FYMessage *)message {
    
    return message;
}


-(void)chatTimerStop {
    if (_chatTimer!=nil) {
        [_chatTimer invalidate];
        self.isChatTimer = NO;
    }
}


-(void)chatTimer:(NSTimer*)timer {
    //    NSLog(@"test......name=%@",timer.userInfo);
    [self chatTimerStop];
}


#pragma mark - 客服弹框
- (void)actionShowCustomerServiceAlertView:(NSString *)messageModel {
    
    NSString *imageUrl = [AppModel shareInstance].commonInfo[@"customer.service.window"];
    if (imageUrl.length == 0) {
        [self goto_WebCustomerService];
        return;
    }
    CustomerServiceAlertView *view = [[CustomerServiceAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    [view updateView:@"常见问题" imageUrl:imageUrl];
    
    __weak __typeof(self)weakSelf = self;
    
    // 查看详情
    view.customerServiceBlock = ^{
        [weakSelf goto_WebCustomerService];
    };
    [view showInView:self.view];
}
- (void)goto_WebCustomerService {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = @"在线客服";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sendWelcomeMessage:(NSString *)groupId {
    NSString *content = [NSString stringWithFormat:@"大家好，我是%@", [AppModel shareInstance].userInfo.nick];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
    [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
    [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
    
    NSDictionary *parameters = @{
                                 @"user":userDict,  // 发送者用户信息
                                 @"from":[AppModel shareInstance].userInfo.userId,      // 发送者ID
                                 @"cmd":@"11",      // 聊天命令
                                 @"chatId":groupId,   // 群ID
                                 @"chatType":@(FYConversationType_GROUP),  // 1 群聊   2  p2p
                                 @"msgType":@(FYMessageTypeText),   // 0 文本 6 红包  7 报奖信息
                                 @"content":content // 消息内容
                                 };
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}

@end


