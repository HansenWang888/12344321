//
//  FYIMSessionViewController.m
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYIMSessionViewController.h"

#import "SSAddImage.h"
#import "FYChatBaseCell.h"
#import "FYSystemBaseCell.h"
#import "SSChatLocationController.h"
#import "SSImageGroupView.h"
#import "SSChatMapController.h"

#import "SSChatDatas.h"

#import "FYSocketManager.h"
#import "WHC_ModelSqlite.h"
#import "NSTimer+SSAdd.h"

#import "NotificationMessageCell.h"
#import "PushMessageModel.h"
#import "MessageSingle.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import "BANetManager_OC.h"

#import "JJPhotoManeger.h"
#import "ZLAlbumListController.h"

@interface FYIMSessionViewController ()<SSChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,FYChatBaseCellDelegate, FYChatManagerDelegate,FYSystemBaseCellDelegate, JJPhotoDelegate>

//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;



//访问相册 摄像头
@property(nonatomic,strong)SSAddImage *mAddImage;
@property (nonatomic ,assign) NSInteger page;
// 是否最底部
@property (nonatomic,assign) BOOL isTableViewBottom;
// 未查看消息数量
@property (nonatomic,assign) NSInteger notViewedMessagesCount;
//
@property (nonatomic,strong) UIButton *bottomMessageBtn;
@property (nonatomic,strong) UILabel *bottomMessageLabel;
@property (nonatomic,strong) UIView *topMessageView;
@property (nonatomic,strong) UILabel *topMessageLabel;
// top 未读消息条数
@property (nonatomic,assign) NSInteger unreadMessageNum;
@property (nonatomic,assign) NSInteger topNumIndex;
// 本地是否还有数据
@property (nonatomic,assign) BOOL isLocalData;

// ****** 相册相关 ******
@property (nonatomic, strong) NSArray *arrDataSources;
@property (nonatomic, strong) NSMutableArray *imagesSizeArr;


@property (nonatomic, strong) ZLPhotoActionSheet *photoActionSheet;

@end

@implementation FYIMSessionViewController

static FYIMSessionViewController *_chatVC;

/*!
 初始化会话页面
 
 @param conversationType 会话类型
 @param targetId         目标会话ID
 
 @return 会话页面对象
 */
- (id)initWithConversationType:(FYChatConversationType)conversationType targetId:(NSString *)targetId {
    if(self = [super init]) {
        _chatType = conversationType;
        _sessionId = targetId;
        _dataSource = [NSMutableArray array];
        _page = 1;
        _notViewedMessagesCount = 0;
        [FYIMMessageManager shareInstance].delegate = self;
        self.delegate = self;
    }
    _chatVC = self;
    return self;
}


+ (FYIMSessionViewController *)currentChat {
    return _chatVC;
}


//不采用系统的旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationItem.title = _titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
   [AppModel shareInstance].chatType = self.chatType;
    self.reloadFinish = YES;
    // 初始化数据
    self.unreadMessageNum = 0;
    self.isLocalData = YES;
    self.imagesSizeArr = [[NSMutableArray alloc] init];
    
    _sessionInputView = [SSChatKeyBoardInputView new];
    _sessionInputView.delegate = self;
    [self.view addSubview:_sessionInputView];
    
    _backViewH = FYSCREEN_Height-SSChatKeyBoardInputViewH-Height_NavBar-kiPhoneX_Bottom_Height;
    
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, Height_NavBar, FYSCREEN_Width, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];
    
    
    [self initTableView];
    [self unreadMessageView];
    [self getUnreadMessageAction];
    
    NSInteger num = kMessagePageNumber -(self.unreadMessageNum % kMessagePageNumber);
    NSInteger numCount = self.unreadMessageNum + num;
    [self getHistoricalData:numCount > kMessagePageNumber ? numCount : kMessagePageNumber];
    //    NSInteger topNumIndex = num - (numCount - self.dataSource.count);
    NSInteger topNumIndex = num;
    _topNumIndex = topNumIndex;
    
//    if (self.unreadMessageNum > kMessagePageNumber) {
//        self.page = numCount / kMessagePageNumber;
//    }
    
    [self scrollToBottom];
    
    
    // 通知 监听消息列表是否需要刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRefreshChatContentData:)
                                                 name:kRefreshChatContentNotification
                                               object:nil];
    
}

#pragma mark - 更新未读消息
/**
 更新未读消息
 */
- (void)updateUnreadMessage {
    
    [[FYIMManager shareInstance] updateGroup:self.sessionId number:0 lastMessage:@"暂无未读消息" messageCount:0 left:0 chatType: self.chatType];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/**
 获取未读消息数量
 */
- (void)getUnreadMessageAction {

    NSString *queryId = [NSString stringWithFormat:@"%@-%@",self.sessionId,[AppModel shareInstance].userInfo.userId];
    PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
    
    self.unreadMessageNum = pmModel.number;
    if (pmModel.number  > kMessagePageNumber) {
        //        self.topMessageView.hidden = NO;
        NSString *mgsStr = (pmModel.number - self.dataSource.count) > 99 ? @"99+条新消息" : [NSString stringWithFormat:@"%zd 条新消息",pmModel.number - self.dataSource.count];
        self.topMessageLabel.text = mgsStr;
    } else {
        //        self.topMessageView.hidden = YES;
        self.topMessageLabel.text = 0;
    }
}


#pragma mark - 获取历史消息 下拉刷新获取数据
- (void)getHistoricalData:(NSInteger)count {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *pageStr = [NSString stringWithFormat:@"%zd,%zd", (self.page -1)*count,count];
        NSString *whereStr = [NSString stringWithFormat:@"sessionId = '%@' and isDeleted = 0", self.sessionId];
        NSArray *messageArray = [WHC_ModelSqlite query:[FYMessage class] where:whereStr order:@"by timestamp desc,create_time desc" limit:pageStr];
        
        if (self.chatType == FYConversationType_PRIVATE || self.chatType == FYConversationType_CUSTOMERSERVICE) {
            if (messageArray.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_tableView.mj_header endRefreshing];
                    self->_tableView.mj_header.hidden = YES;
                });
                return;
            }
        } else {
            if (count != messageArray.count) {
                self.isLocalData = NO;
            }
            
            if (messageArray.count == 0) {
                [self sendGetServerData];
                return;
            }
        }
        
        [self controllerLoadData:messageArray];
        
    });
}

- (void)controllerLoadData:(NSArray *)messageArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger indexCount = 0;
        for (NSInteger index = 0; index < messageArray.count; index++) {
            FYMessage *message = (FYMessage *)messageArray[index];
            //如果这条消息被标记删除 则过滤掉 并且判断时间是否超过七天 如果是 直接从数据库删除
            if (message.isDeleted) {
                NSTimeInterval nowStamp = [NSDate new].timeIntervalSince1970 * 1000;
                if (message.timestamp * 7 < nowStamp ) {
                    [IMMessageModule removeLocalMessageWithMessageId:message.messageId];
                }
                continue;
            }
            
            if (self.dataSource.count == 0) {
                indexCount++;
                [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            } else {
                // 去重复
                BOOL isRepeat = NO;
                for (FYMessagelLayoutModel *layout in self.dataSource) {
                    if([message.messageId isEqualToString:layout.message.messageId]) {
                        isRepeat = YES;
                        break;
                    }
                }
                if (!isRepeat) {
                    indexCount++;
                    [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
                }
                
                //            indexCount++;
                //            [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            }
        }
        
        if (self.page > 0 && self.dataSource.count > 0) {
            
            [self->_tableView.mj_header endRefreshing];
            [self->_tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCount > 0 ? indexCount -1 : 0 inSection:0];
            [self->_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }
    });
}

/**
 下拉获取服务器返回的消息
 
 @param messageArray 消息数组
 */
- (void)downPullGetMessageArray:(NSArray *)messageArray {
    
    NSInteger indexCount = 0;
    for (NSInteger index = 0; index < messageArray.count; index++) {
        FYMessage *message = (FYMessage *)messageArray[messageArray.count - 1 -index];
        NSLog(@"%@",message.isDeleted ? @"YES" :@"NO");
        if (self.dataSource.count == 0) {
            indexCount++;
            [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
        } else {
            // 去重复
            BOOL isRepeat = NO;
            for (FYMessagelLayoutModel *layout in self.dataSource) {
                if([message.messageId isEqualToString:layout.message.messageId]) {
                    isRepeat = YES;
                    break;
                }
            }
            if (!isRepeat) {
                indexCount++;
                [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            }
            
            //                indexCount++;
            //                [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            
        }
    }
    
    [self->_tableView.mj_header endRefreshing];
    
    if (messageArray.count > 0) {
        [self->_tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCount > 0 ? indexCount -1 : 0 inSection:0];
        [self->_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if (messageArray.count == 0) {
        self->_tableView.mj_header.hidden = YES;
    }
    
}

- (void)sendGetServerData {
    FYMessagelLayoutModel *fyMessageLayout = self.dataSource.firstObject;
    [[FYIMMessageManager shareInstance] sendDropdownRequest:self.sessionId endTime:self.dataSource.count == 0 ? -1 : fyMessageLayout.message.timestamp chartType:self.chatType];
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = SSChatCellColor;
    tableView.backgroundView.backgroundColor = SSChatCellColor;
    [_mBackView addSubview:tableView];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    __weak __typeof(self)weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.page++;
        
        if (self.chatType == FYConversationType_PRIVATE || self.chatType == FYConversationType_CUSTOMERSERVICE) {
            [strongSelf getHistoricalData:kMessagePageNumber];
            return;
        }
        NSString *queryId = [NSString stringWithFormat:@"%@-%@",self.sessionId,[AppModel shareInstance].userInfo.userId];
        PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
        if (pmModel.messageCountLeft > 0 || !self.isLocalData) {
            [strongSelf sendGetServerData];
            pmModel.messageCountLeft =  pmModel.messageCountLeft > 50 ? pmModel.messageCountLeft -50 : 0;
        } else {
            [strongSelf getHistoricalData:kMessagePageNumber];
        }
        
    }];
    
    [tableView registerClass:NSClassFromString(@"SSChatTextCell") forCellReuseIdentifier:SSChatTextCellId];
    [tableView registerClass:NSClassFromString(@"SSChatImageCell") forCellReuseIdentifier:SSChatImageCellId];
    [tableView registerClass:NSClassFromString(@"SSChatVoiceCell") forCellReuseIdentifier:SSChatVoiceCellId];
    [tableView registerClass:NSClassFromString(@"SSChatMapCell") forCellReuseIdentifier:SSChatMapCellId];
    [tableView registerClass:NSClassFromString(@"SSChatVideoCell") forCellReuseIdentifier:SSChatVideoCellId];
    [tableView registerClass:NSClassFromString(@"FYRedEnevlopeCell") forCellReuseIdentifier:FYRedEnevlopeCellId];
    [tableView registerClass:NSClassFromString(@"CowCowVSMessageCell") forCellReuseIdentifier:CowCowVSMessageCellId];
    [tableView registerClass:NSClassFromString(@"NotificationMessageCell") forCellReuseIdentifier:NotificationMessageCellId];
}




#pragma mark - 未读消息 和 未读新消息视图
- (void)unreadMessageView {
    
    /*  top 视图
     UIView *topMessageView = [[UIView alloc] init];
     topMessageView.backgroundColor = [UIColor whiteColor];
     topMessageView.layer.cornerRadius = 35/2;
     topMessageView.layer.borderWidth = 0.5;
     topMessageView.layer.borderColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.000].CGColor;
     topMessageView.hidden = YES;
     
     UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewtapClick:)];
     [topMessageView addGestureRecognizer:gesture];
     
     [self.view addSubview:topMessageView];
     _topMessageView = topMessageView;
     
     [topMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.right.mas_equalTo(self.tableView.mas_right).offset(35/2);
     make.top.mas_equalTo(self.tableView.mas_top).offset(18);
     make.size.mas_equalTo(CGSizeMake(150, 35));
     }];
     
     UIImageView *backImageView = [[UIImageView alloc] init];
     backImageView.image = [UIImage imageNamed:@"mess_arrow"];
     [topMessageView addSubview:backImageView];
     
     [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.mas_equalTo(topMessageView.mas_centerY);
     make.left.mas_equalTo(topMessageView.left).offset(12);
     make.size.mas_equalTo(CGSizeMake(9.0, 8.5));
     }];
     
     UILabel *topMessageLabel = [[UILabel alloc] init];
     //    topMessageLabel.text = @"0 条新消息";
     topMessageLabel.font = [UIFont systemFontOfSize:14];
     topMessageLabel.textColor = [UIColor colorWithRed:0.059 green:0.608 blue:1.000 alpha:1.000];
     topMessageLabel.textAlignment = NSTextAlignmentCenter;
     [topMessageView addSubview:topMessageLabel];
     _topMessageLabel = topMessageLabel;
     
     [topMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.mas_equalTo(backImageView.mas_right).offset(15);
     make.centerY.mas_equalTo(topMessageView.mas_centerY);
     }];
     
     */
    
    // ******************************
    
    UIButton *bottomMessageBtn = [[UIButton alloc] init];
    [bottomMessageBtn addTarget:self action:@selector(onNewMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessageBtn setBackgroundImage:[UIImage imageNamed:@"mess_bubble"] forState:UIControlStateNormal];
    [self.view addSubview:bottomMessageBtn];
    _bottomMessageBtn = bottomMessageBtn;
    bottomMessageBtn.hidden = YES;
    
    [bottomMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tableView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mBackView.mas_bottom).offset(-15);
        make.size.equalTo(@(37.5));
    }];
    
    UILabel *bottomMessageLabel = [[UILabel alloc] init];
    //    bottomMessageLabel.text = @"1";
    bottomMessageLabel.font = [UIFont systemFontOfSize:14];
    bottomMessageLabel.textColor = [UIColor whiteColor];
    bottomMessageLabel.textAlignment = NSTextAlignmentCenter;
    [bottomMessageBtn addSubview:bottomMessageLabel];
    _bottomMessageLabel = bottomMessageLabel;
    
    [bottomMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomMessageBtn.mas_centerX);
        make.centerY.mas_equalTo(bottomMessageBtn.mas_centerY).offset(-3);
    }];
}

- (void)onNewMessageBtnClick {
    [self scrollToBottom];
    [self hidBottomUnreadMessageView];
}

- (void)hidBottomUnreadMessageView {
    self.notViewedMessagesCount = 0;
    self.bottomMessageLabel.text = 0;
    self.bottomMessageBtn.hidden = YES;
}

#pragma mark - top未读消息点击事件
-(void)topViewtapClick:(UITapGestureRecognizer *)sender {
    
    if (self.dataSource.count > 0) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.topNumIndex >= 0 ? self.topNumIndex : 0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    self.topMessageView.hidden = YES;
    self.topMessageLabel.text = 0;
}

//处理监听触发事件
-(void)onRefreshChatContentData:(NSNotificationCenter *)notification {
    [self.dataSource removeAllObjects];
    [self->_tableView reloadData];
}

#pragma mark - 接收消息
- (FYMessage *)willAppendAndDisplayMessage:(FYMessage *)message {
    // 更新数据   // 暂时不做
    //    if (message.deliveryState == FYMessageDeliveryStateDeliveried && message.isReceivedMsg == YES) {
    //
    //    }
    
    // 系统消息类型
    
    if (message.messageFrom == FYChatMessageFromSystem) {
        message.sessionId = self.sessionId;
    }
    
    if (message.messageType == FYMessageTypeImage) {
        if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            for (NSInteger index = 0; index < self.dataSource.count; index++) {
                FYMessagelLayoutModel *modelLa = self.dataSource[index];
                if (modelLa.message.isReceivedMsg == NO) {
                    NSTimeInterval timestamp = [message.extras[@"timestamp"] doubleValue];
                    if (timestamp == modelLa.message.timestamp) {
                        if (message.deliveryState == FYMessageDeliveryStateFailed) {
                            modelLa.message.deliveryState = FYMessageDeliveryStateFailed;
                            break;
                        } else if (message.deliveryState == FYMessageDeliveryStateDeliveried) {
                            [self.dataSource removeObject:modelLa];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新数据源
        [self.dataSource addObject:[SSChatDatas receiveMessage:message]];
        // UI更新代码
        [self delayReload];
    });
    
    //    if(self.reloadFinish){
    //        self.reloadFinish = NO;
    //        [self performSelector:@selector(delayReload) withObject:nil afterDelay:0.2];
    //    }
    return message;
}

-(void)delayReload{
    FYMessagelLayoutModel *message = [self.dataSource lastObject];
    [self.tableView reloadData];
    if ([message.message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId] || self.isTableViewBottom) {
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
    }
    
    // 未读新消息
    if (!self.isTableViewBottom) {
        self.notViewedMessagesCount++;
        NSString *mgsStr = self.notViewedMessagesCount > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",self.notViewedMessagesCount];
        self.bottomMessageLabel.text = mgsStr;
        self.bottomMessageBtn.hidden = NO;
    }
    self.reloadFinish = YES;
}

#pragma mark - 撤回消息 删除消息

/**
 开始撤回消息
 
 @param model 消息模型
 */
-(void)onWithdrawMessageCell:(FYMessage *)model {
    
    NSDictionary *parameters = @{
                                 @"id":model.messageId,  // 消息ID
                                 @"createTime":@(model.timestamp),
                                 @"chatId":model.sessionId,   // 群ID
                                 @"chatType":@(model.chatType),   // 会话类型
                                 @"cmd":@"15"      // 聊天命令
                                 };
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
    
}

/**
 即将撤回消息（服务器已经发送回来撤回命令 客服端还未处理时）
 
 @param messageId  消息ID
 */
- (void)willRecallMessage:(NSString *)messageId {
    if (messageId.length > 0) {
        [self onDeleteLocalMessage:messageId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}



// 删除消息
-(void)onDeleteMessageCell:(FYMessage *)model indexPath:(NSIndexPath *)indexPath {
    if (model.messageId.length > 0) {
        [self onDeleteLocalMessage:model.messageId];
        [self.tableView reloadData];
    }
}

/**
 删除本地消息方法
 
 @param messageId 消息ID
 */
- (void)onDeleteLocalMessage:(NSString *)messageId {
    for (FYMessagelLayoutModel *modelLayout in self.dataSource) {
        if ([messageId isEqualToString:modelLayout.message.messageId]) {
            [self.dataSource removeObject:modelLayout];
            [self deleteMessageUpdateSql:messageId];
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)deleteMessageUpdateSql:(NSString *)messageId {
    NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", messageId];
    FYMessage *fyMessage = [[WHC_ModelSqlite query:[FYMessage class] where:whereStr] firstObject];
    fyMessage.isDeleted = YES;
    if (fyMessage != nil) {
        [WHC_ModelSqlite update:fyMessage where:whereStr];
    }
    //处理上一条消息的显示
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [IMSessionModule.sharedInstance handleMessageForRecallOrDeletedWithSessionId:fyMessage.sessionId];
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    
    if ((bottomOffset-200) <= height) {
        //在最底部
        self.isTableViewBottom = YES;
        [self hidBottomUnreadMessageView];
    } else {
        self.isTableViewBottom = NO;
    }
}




#pragma mark - 发送消息代理
//发送文本 列表滚动至底部
-(void)onChatKeyBoardInputViewSendText:(NSString *)text {
    FYMessage *model = [[FYMessage alloc] init];
    model.text = text;
    model.deliveryState = FYMessageDeliveryStateDelivering;
    [self sendMessageAction:model];
}


/**
 发送消息所有方法
 */
- (void)sendMessageAction:(FYMessage *)model {
    if ([FYIMMessageManager shareInstance].isConnectFY) {
        
        if (self.chatType == FYConversationType_GROUP) {  // 群聊
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
            [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
            
            NSMutableDictionary *extrasDict = [[NSMutableDictionary alloc] init];
            [extrasDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [extrasDict setObject:self.sessionId forKey:@"sessionId"];
            [extrasDict setObject:@(model.timestamp) forKey:@"timestamp"];
            
            NSDictionary *parameters = @{
                                         @"user":userDict,  // 发送者用户信息
                                         @"extras":extrasDict,
                                         @"from":[AppModel shareInstance].userInfo.userId,      // 发送者ID
                                         @"cmd":@"11",      // 聊天命令
                                         @"chatId":self.sessionId,   // 会话id
                                         @"chatType":@(self.chatType),  // 1 群聊   2  p2p
                                         @"msgType":@(model.messageType),   // 0 文本 6 红包  7 报奖信息
                                         @"content":model.text // 消息内容
                                         };
            [self sendMessageServerDict:parameters];
        } else if (self.chatType == FYConversationType_PRIVATE || self.chatType == FYConversationType_CUSTOMERSERVICE) {  // 单聊
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
            [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
            
            
            NSMutableDictionary *extrasDict = [[NSMutableDictionary alloc] init];
            [extrasDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [extrasDict setObject:self.sessionId forKey:@"sessionId"];
            [extrasDict setObject:@(model.timestamp) forKey:@"timestamp"];
            
            NSMutableDictionary *receiverDict = [[NSMutableDictionary alloc] init];
            [receiverDict setObject:self.toContactsModel.userId forKey:@"userId"];
            [receiverDict setObject:self.toContactsModel.nick forKey:@"nick"];
            [receiverDict setObject:self.toContactsModel.avatar forKey:@"avatar"];
            
            NSDictionary *parameters = @{
                                         @"user":userDict,  // 发送者用户信息
                                         @"from":[AppModel shareInstance].userInfo.userId,      // 发送者ID
                                         @"cmd":@"11",      // 聊天命令
                                         @"chatId":self.sessionId,   // 会话id
                                         @"to": self.toContactsModel.userId,    // 接收人
                                         @"chatType":@(self.chatType),  // 1 群聊   2  p2p  2表示私聊
                                         @"msgType":@(model.messageType),   // 0 文本 1 图片
                                         @"content":model.text,      // msgType为1图片时，存图片地址等参数，由发送端自定义
                                         @"receiver":receiverDict, // 对方用户信息
                                         @"extras":extrasDict
                                         };
            [self sendMessageServerDict:parameters];
        } else {
            NSLog(@"没有这个聊天类型");
        }
        
    } else {
        if (model.messageType == FYMessageTypeImage) {
            model.deliveryState = FYMessageDeliveryStateFailed;
            [[FYIMMessageManager shareInstance] updateMessage:model.messageId];
        }
        NSLog(@"🔴没有连接上socket");
    }
}


// 注意：只能测试时用
- (void)testUse:(NSMutableDictionary *)muDict text:(NSString *)text {
    // 测试
    for (NSInteger index = 0; index < 100; index++) {
        [muDict setObject:[NSString stringWithFormat:@"%@-%zd", text,index] forKey:@"content"];
        [[FYIMMessageManager shareInstance] sendMessageServer:muDict];
    }
}




- (void)sendMessageServerDict:(NSDictionary *)dictPar {
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dictPar];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dictPar];
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendMessage:)]) {
        message = [self.delegate willSendMessage:message];
        if (message != nil) {
            [tempDict setObject:message.text forKey:@"content"];
        } else {
            [tempDict setObject:@"" forKey:@"content"];
        }
    }
    
    // 测试
    //              [self testUse:tempDict text:message.text];
    
    [[FYIMMessageManager shareInstance] sendMessageServer:tempDict];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.topNumIndex) {
        self.topMessageView.hidden = YES;
        self.topMessageLabel.text = 0;
    }
    FYMessagelLayoutModel *model = _dataSource[indexPath.row];
    if (model.message.messageType == FYMessageTypeNoticeRewardInfo || model.message.messageFrom == FYChatMessageFromSystem) {
        
        FYSystemBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:model.message.cellString];
        if (cell == nil) {
            cell = [[FYSystemBaseCell alloc]initWithStyle:0 reuseIdentifier:model.message.cellString];
        }
        cell.delegate = self;
        cell.model = model;
        return cell;
    } else {
        if ([model.message.cellString isEqualToString:@""]) {
            
        }
        FYChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:model.message.cellString];
        if (cell == nil) {
            cell = [[FYChatBaseCell alloc]initWithStyle:0 reuseIdentifier:model.message.cellString];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = model;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(FYMessagelLayoutModel *)_dataSource[indexPath.row] cellHeight];
}

//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];
    
    [_sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];
    [_sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sessionInputView endEditing:YES];
    ///将当前session未读消息数清空
    FYContacts *session = [IMSessionModule.sharedInstance getSessionWithSessionId:self.sessionId];
    if (session) {
        session.unReadMsgCount = 0;
        [IMSessionModule updateSeesion:session];
    }
}

#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
    
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, Height_NavBar, FYSCREEN_Width, height);
        self.tableView.frame = self.mBackView.bounds;
        
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.dataSource.count-1 inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
        
    } completion:^(BOOL finished) {
    }];
    
}

// 滚动到最底部  https://www.jianshu.com/p/03c478adcae7
-(void)scrollToBottom {
    
    if (self.dataSource.count > 0) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    self.notViewedMessagesCount = 0;
    self.isTableViewBottom = YES;
}


// 发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second{
    
    NSDictionary *dic = @{@"voice":voice,
                          @"second":@(second)};
    //    [self sendMessage:dic messageType:FYMessageTypeVoice];
}

#pragma mark - 多功能视图点击回调
//多功能视图点击回调  图片10  视频11  位置12
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag {
    
    if(tag==10 || tag==11){
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];
        if (tag==10) {
            [self loadImage];
        } else if (tag==11) {
            [self takePhoto];
        }
    } else {
        SSChatLocationController *vc = [SSChatLocationController new];
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            //            [self sendMessage:locationDic messageType:FYMessageTypeMap];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)takePhoto
{
    ZLPhotoActionSheet *photoActionSheet = [self getPas];
    if (![ZLPhotoManager haveCameraAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoCameraAuthorityText), kAPPName];
        ShowAlert(message, self);
        return;
    }
    if (![ZLPhotoManager haveMicrophoneAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoMicrophoneAuthorityText), kAPPName];
        ShowAlert(message, self);
        return;
    }
    
    ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
    camera.allowTakePhoto = YES;
    camera.allowRecordVideo = NO;
    camera.sessionPreset = ZLCaptureSessionPreset1280x720;
    camera.videoType = ZLExportVideoTypeMov;
    camera.circleProgressColor = kRGB(80, 180, 234);;
    camera.maxRecordDuration = 10;
    @zl_weakify(self);
    
    
    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        @zl_strongify(self);
//        [photoActionSheet saveImage:image videoUrl:videoUrl];
        if (image) {
            [self sendSelectImage:@[image]];
        }
        
    };
    [self showDetailViewController:camera sender:nil];
}


#pragma - FYChatBaseCellDelegate

#pragma 点击Cell消息背景视图
- (void)didTapMessageCell:(FYMessage *)model {
    NSLog(@"1");
}

#pragma 点击图片 点击短视频
-(void)didChatImageVideoCellIndexPatch:(NSIndexPath *)indexPath layout:(FYMessagelLayoutModel *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    UIImageView *seleedView;
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *picUrlArr = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.dataSource.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        FYChatBaseCell *cell = [_tableView cellForRowAtIndexPath:ip];
        FYMessagelLayoutModel *mLayout = self.dataSource[i];
        
        if (cell == nil) {
            continue;
        }
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == FYMessageTypeImage && mLayout.message.messageFrom != FYChatMessageFromSystem){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = cell.mImgView.image;
            
            [imageArr addObject:cell.mImgView];
            if (mLayout.message.imageUrl) {
                [picUrlArr addObject:mLayout.message.imageUrl];
            }
        } else if (mLayout.message.messageType == FYMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.videoLocalPath;
            item.fromImgView = cell.mImgView;
            //            item.fromImage = mLayout.message.videoImage;
        } else {
            continue;
        }
        
        
        //        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout]) {
            currentIndex = groupItems.count;
            seleedView = cell.mImgView;
        }
        [groupItems addObject:item];
        
    }
    
    //    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    //    [self.navigationController.view addSubview:imageGroupView];
    
    
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showNetworkPhotoViewer:imageArr urlStrArr:picUrlArr selecView:seleedView];
    
    
    //    __block SSImageGroupView *blockView = imageGroupView;
    //    blockView.dismissBlock = ^{
    //        [blockView removeFromSuperview];
    //        blockView = nil;
    //    };
    //
    //    [self.sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    //    UIImageView *view = (UIImageView *)tap.view;
    //    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    //    mg.delegate = self;
    //    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

#pragma FYChatBaseCellDelegate 点击定位
-(void)didChatMapCellIndexPath:(NSIndexPath *)indexPath layout:(FYMessagelLayoutModel *)layout{
    
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 相册
- (void)loadImage {
    [self showWithPreview:NO];
}

- (void)showWithPreview:(BOOL)preview
{
    ZLPhotoActionSheet *a = [self getPas];
    _photoActionSheet = a;
    if (preview) {
        [a showPreviewAnimated:YES];
    } else {
        [a showPhotoLibrary];
    }
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    actionSheet.configuration.allowSelectOriginal = NO;
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    actionSheet.configuration.maxPreviewCount = 20;
    actionSheet.configuration.maxSelectCount = 1;
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    actionSheet.configuration.showSelectedMask = YES;
    actionSheet.configuration.shouldAnialysisAsset = YES;
    actionSheet.configuration.languageType = NO;
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        [self sendSelectImage:images];
    }];
    
    actionSheet.selectImageRequestErrorBlock = ^(NSArray<PHAsset *> * _Nonnull errorAssets, NSArray<NSNumber *> * _Nonnull errorIndex) {
        NSLog(@"图片解析出错的索引为: %@, 对应assets为: %@", errorIndex, errorAssets);
    };
    
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    
    return actionSheet;
}

- (void)sendSelectImage:(NSArray *)images {
    self.arrDataSources = images;
    FYMessage *modelMessage = [[FYMessage alloc] init];
    modelMessage.messageType = FYMessageTypeImage;
    modelMessage.sessionId = self.sessionId;
    modelMessage.messageSendId = [AppModel shareInstance].userInfo.userId;
    modelMessage.user = [AppModel shareInstance].userInfo;
    modelMessage.create_time = [NSDate date];
    
    UIImage *image = (UIImage *)images.firstObject;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(image.size.width) forKey:@"width"];
    [dict setObject:@(image.size.height) forKey:@"height"];
    [dict setObject:image forKey:@"image"];
    modelMessage.selectPhoto = dict;
    
    [self sendMessage:modelMessage];
    [self uploadImage:modelMessage];
}

/**
 点击重发
 
 @param model 消息模型
 */
-(void)onErrorBtnCell:(FYMessage *)model {
    
    [self onDeleteLocalMessage:model.messageId];
    [self sendMessage:model];
    
    if (model.imageUrl.length > 0) {
        [self sendMessageAction:model];
    } else {
        [self uploadImage:model];
    }
    
}

// 发送消息
-(void)sendMessage:(FYMessage *)message {
    
    __weak __typeof(self)weakSelf = self;
    [SSChatDatas sendMessage:message messageBlock:^(FYMessagelLayoutModel *model, NSError *error, NSProgress *progress) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataSource addObject:model];
        [strongSelf.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:strongSelf.dataSource.count-1 inSection:0];
        [strongSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite insert:message];
        });
    }];
}


#pragma mark -  上传图片
/**
 上传图片
 */
- (void)uploadImage:(FYMessage *)model {
    
    BAImageDataEntity *entity = [BAImageDataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"admin/user/upload"];
    entity.needCache = NO;
    //    entity.imageArray = self.arrDataSources;
    if (model.selectPhoto.count) {
        entity.imageArray = @[model.selectPhoto[@"image"]];
    }
    entity.fileNames = @[@"file"];
    entity.imageType =  @"png";
    entity.imageScale =  0.5;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_uploadImageWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (model.selectPhoto.count) {
                [dict setObject:@([model.selectPhoto[@"width"] floatValue]) forKey:@"width"];
                [dict setObject:@([model.selectPhoto[@"height"] floatValue]) forKey:@"height"];
            }
            if (![response objectForKey:@"data"] || [[response objectForKey:@"data"] isEqualToString:@""]) {
                model.deliveryState = FYMessageDeliveryStateFailed;
                [[FYIMMessageManager shareInstance] updateMessage:model.messageId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
                return;
            }
            [dict setObject:[response objectForKey:@"data"] forKey:@"url"];
            model.imageUrl = [response objectForKey:@"data"];
            NSString *dddd =  [dict mj_JSONString];
            model.text = dddd;
            [strongSelf sendMessageAction:model];
            //                [self.imagesSizeArr addObject: dict];
            
            
        } else {
            
            model.deliveryState = FYMessageDeliveryStateFailed;
            [[FYIMMessageManager shareInstance] updateMessage:model.messageId];
            [[FunctionManager sharedInstance] handleFailResponse:response];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
            
        }
    } failurBlock:^(NSError *error) {
        model.deliveryState = FYMessageDeliveryStateFailed;
        [[FYIMMessageManager shareInstance] updateMessage:model.messageId];
        [[FunctionManager sharedInstance] handleFailResponse:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        NSLog(@"聊天图片上传中...");
    }];
}



@end

