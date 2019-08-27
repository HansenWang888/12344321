//
//  MessageViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageNet.h"
#import "CreateGroupChatController.h"//创建群聊
//#import <RongIMKit/RongIMKit.h>
#import "ChatViewController.h"
#import "MessageItem.h"
#import "EasyOperater.h"
#import "SystemAlertViewController.h"
#import "CustomerServiceAlertView.h"

#import "FYMenu.h"

#import "ShareViewController.h"
#import "Recharge2ViewController.h"
#import "BecomeAgentViewController.h"
#import "HelpCenterWebController.h"

#import "VVAlertModel.h"
#import "AgentCenterViewController.h"
#import "PushMessageModel.h"
#import "MessageSingle.h"
#import "SqliteManage.h"
#import "MsgHeaderView.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "UIImageView+WebCache.h"
#import "NetworkIndicatorView.h"

#import "MyFriendMessageListController.h"
#import "SLMarqueeControl.h"

#define kViewTag 666

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,CWCarouselDatasource, CWCarouselDelegate>
@property (nonatomic, strong) BannerModel* bannerModel;
@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) MessageNet *model;
@property(nonatomic,strong) SLMarqueeControl *scrollBarView;

@property(nonatomic, strong) NSMutableArray *menuItems;
//
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,assign) BOOL isCurrentController;

@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initData];
    
    [self initSubviews];
    [self initLayout];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_r"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self notification];
   
}
- (void)initSubviews {
    __weak __typeof(self)weakSelf = self;
    __weak MessageNet *weakModel = _model;
    [self initScrollBarView];
    
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = BaseColor;
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [_tableView YBGeneral_configuration];
    //    _tableView.separatorColor = TBSeparaColor;
    //    _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if (!weakModel.isMost) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            weakModel.page++;
            [strongSelf getData];
        }
    }];
    
    _tableView.StateView = [StateView StateViewWithHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData];
    }];
    
    //SVP_SHOW;
    [NET_REQUEST_MANAGER requestSystemNoticeWithSuccess:^(id object) {
        //        [self announcementBar];
        [self.tableView reloadData];
    } fail:^(id object) {
        
    }];
    weakModel.page = 1;
    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addOrDeleteMembers:) name:@"addOrDeleteMembers" object:nil];
    
}

#pragma mark - notification action
- (void)notification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(action_reload) name:kReloadMyMessageGroupList object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateValue:)name:kUnreadMessageNumberChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetwork) name:kNoNetworkNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yesNetwork) name:kYesNetworkNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageViewControllerDisplayNotification object: nil];
    
}
- (void)action_reload {
    [self getData];
}
/** 收到消息重新刷新*/
- (void)updateValue:(NSNotification *)noti {
    if (self.isCurrentController) {
        NSString *info = [noti object];
        if ([info isEqualToString:@"GroupListNotification"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //                [UIView performWithoutAnimation:^{
                //                    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                //                }];
            });
        }
    }
}
-(void)enterFore {
    [self performSelector:@selector(getData) withObject:nil afterDelay:1.0];
    NSLog(@"进入前台");
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
}
/** 无网络警告视图*/
- (void)noNetwork {
    NetworkIndicatorView *view = [[NetworkIndicatorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.tableView.tableHeaderView = view;
}

- (void)yesNetwork {
    self.tableView.tableHeaderView = nil;
}


#pragma mark - 系统公告栏
- (void)announcementBar {
    NSMutableArray *announcementArray = [NSMutableArray array];
    if([AppModel shareInstance].noticeArray.count > 0){
        for (NSDictionary *dic in [AppModel shareInstance].noticeArray) {
            NSString *title = dic[@"title"];
            NSString *content = dic[@"content"];
            VVAlertModel *model = [[VVAlertModel alloc] init];
            model.name = title;
            if (content.length > 0) {
                model.friends = @[content];
            }
            [announcementArray addObject:model];
        }
    } else {
        return;
    }
    SystemAlertViewController *alertVC = [SystemAlertViewController alertControllerWithTitle:@"公告" dataArray:announcementArray];
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (void)scrollBarViewAction {
    [self announcementBar];
}





- (void)initData {
    _model = [MessageNet shareInstance];
}

#pragma mark ----- Layout
- (void)finishedPostBannerLayout:(CGFloat)changeY{
    if (self.scrollBarView) {
        [self.scrollBarView setSd_y:changeY+3];
        [self initLayout];
    }else{
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(changeY+3);
        }];
    }
}
- (void)initLayout {
    if (self.scrollBarView) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.scrollBarView.mas_bottom).offset(3);
        }];
    }else{
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(3);
        }];
    }
}



//添加删除好友
- (void)addOrDeleteMembers:(NSNotification *)not{
    NSDictionary *dict = not.object;
    NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
    NSInteger command = [dict[@"command"] integerValue];
    NSLog(@"%@",msg);
    if (command == 33 || command == 34) {

        if (command == 33) {
            SVP_ERROR_STATUS(msg);
            
        }else{
            SVP_SUCCESS_STATUS(dict[@"msg"]);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [self updateList];
        });
    }
}

#pragma mark - 计算验证未读消息
- (void)calculateUnreadMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [AppModel shareInstance].unReadCount = 0;
        
        for (NSInteger index = 1; index < self.model.myJoinDataList.count; index++) {
            CDTableModel *tableModel = self.model.myJoinDataList[index];
            MessageItem *item = nil;
            if ([tableModel.obj isKindOfClass:[MessageItem class]]) {
                item = (MessageItem *)tableModel.obj;
            } else {
                item = [MessageItem mj_objectWithKeyValues:tableModel.obj];
            }
            
            NSString *queryId = [NSString stringWithFormat:@"%@-%@",item.groupId,[AppModel shareInstance].userInfo.userId];
            PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
            
            [AppModel shareInstance].unReadCount += pmModel.number;
        }
        
        [AppModel shareInstance].friendUnReadTotal = 0;
        NSString *query = [NSString stringWithFormat:@"select * from FYContacts where contactsType = 2 and accountUserId='%@' order by isTopTime desc,lastTimestamp desc,lastCreate_time desc limit 999999",[AppModel shareInstance].userInfo.userId];
        NSArray *whereMyFriendByArray = [WHC_ModelSqlite query:[FYContacts class] sql:query];
        for (NSInteger index = 0; index < whereMyFriendByArray.count; index++) {
            FYContacts *model = (FYContacts *)whereMyFriendByArray[index];
            NSString *queryId = [NSString stringWithFormat:@"%@-%@",model.sessionId,[AppModel shareInstance].userInfo.userId];
            PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
            if (pmModel) {
                [AppModel shareInstance].friendUnReadTotal += pmModel.number;
            }
        }
        
//        [AppModel shareInstance].customerServiceUnReadTotal = 0;
//        NSArray *myCustomerServiceListArray = [[AppModel shareInstance].myCustomerServiceListDict allValues];
//        for (NSInteger index = 0; index < myCustomerServiceListArray.count; index++) {
//            FYContacts *model = (FYContacts *)myCustomerServiceListArray[index];
//            NSString *queryId = [NSString stringWithFormat:@"%@-%@",model.sessionId,[AppModel shareInstance].userInfo.userId];
//            PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
//            if (pmModel) {
//                [AppModel shareInstance].customerServiceUnReadTotal += pmModel.number;
//            }
//        }
        
        [AppModel shareInstance].unReadCount += [AppModel shareInstance].friendUnReadTotal;
//        [AppModel shareInstance].unReadCount += [AppModel shareInstance].customerServiceUnReadTotal;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"updateBadeValue"];
        
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
    [self.carousel controllerWillAppear];
    self.isCurrentController = YES;
    
    [_tableView reloadData];
    [self calculateUnreadMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [EasyOperater remove];
    [self.carousel controllerWillDisAppear];
    self.isCurrentController = NO;
}

-(void)initScrollBarView{
    if([AppModel shareInstance].noticeArray.count > 0&&
       [AppModel shareInstance].noticeAttributedString.length>0){
        
        
        SLMarqueeControl *control = [[SLMarqueeControl alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 40.f)];
        [control richElementsInViewWithModel:[AppModel shareInstance].noticeAttributedString actionBlock:^(id data) {
            [self scrollBarViewAction];
        }];
        control.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:control];
        
        _scrollBarView = control;
        
    }
}



/**
 更新列表
 */
-(void)updateList{
    __weak __typeof(self)weakSelf = self;
    [_model getMyJoinedGroupListSuccessBlock:^(NSDictionary *dic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SVP_DISMISS;
        if ([dic[@"status"] integerValue] >= 1) {
            SVP_ERROR_STATUS(dic[@"error"]);
        } else {
            [strongSelf delayReload];
            if (!strongSelf.isFirst) {
                strongSelf.isFirst = YES;
            }
        }
    } failureBlock:^(NSError *err) {
        [[FunctionManager sharedInstance] handleFailResponse:err];
        [weakSelf reloadTableState];
    }];
}
#pragma mark -  一、获取我加入的群组数据 二、通知列表
- (void)getData {
    __weak __typeof(self)weakSelf = self;
    [_model getMyJoinedGroupListSuccessBlock:^(NSDictionary *dic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SVP_DISMISS;
        if ([dic[@"status"] integerValue] >= 1) {
            SVP_ERROR_STATUS(dic[@"error"]);
        } else {
            [strongSelf delayReload];
            if (!strongSelf.isFirst) {
                strongSelf.isFirst = YES;
            }
        }
    } failureBlock:^(NSError *err) {
        [[FunctionManager sharedInstance] handleFailResponse:err];
        [weakSelf reloadTableState];
    }];
    //轮播图
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeMsg WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            self.bannerModel = model;
            
            //            self.animationView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH-0, kGETVALUE_HEIGHT(1010, 315, SCREEN_WIDTH))];
            
            //            self.animationView = [[UIView alloc] initWithFrame:CGRectMake(-60,0, SCREEN_WIDTH+120, kGETVALUE_HEIGHT(1200, 280, SCREEN_WIDTH+120))];
            
            self.animationView = [[UIView alloc] initWithFrame:CGRectMake(7,0, SCREEN_WIDTH-14, kGETVALUE_HEIGHT(505, 107, SCREEN_WIDTH-14))];
            
            self.animationView.tag = 200;
            //            self.animationView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.animationView];
            if(self.carousel) {
                [self.carousel releaseTimer];
                [self.carousel removeFromSuperview];
                self.carousel = nil;
            }
            CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_Normal];
            CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
                                                            delegate:self
                                                          datasource:self
                                                          flowLayout:flowLayout];
            carousel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.animationView addSubview:carousel];
            NSDictionary *dic = @{@"view" : carousel};
            [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:dic]];
            [self.animationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[view]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:dic]];
            
            carousel.isAuto = YES;
            carousel.autoTimInterval = [model.data.carouselTime intValue];
            carousel.endless = YES;
            carousel.backgroundColor = BaseColor;
            
            /* 自定pageControl */
            
            //            CGRect frame = self.animationView.bounds;
            //
            //                CWPageControl *control = [[CWPageControl alloc] initWithFrame:CGRectMake(0, -10, 300, 20)];
            //                control.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) - 20);
            //                control.pageNumbers = model.data.skAdvDetailList.count;
            //                control.currentPage = 0;
            //                carousel.customPageControl = control;
            
            [carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
            [carousel freshCarousel];
            self.carousel = carousel;
            
            [self finishedPostBannerLayout:CGRectGetMaxY(self.animationView.frame)];
            
        }else{
            for (UIView* view in [self.view subviews]) {
                if (view.tag == 200) {
                    [view removeFromSuperview];
                }
            }
            [self finishedPostBannerLayout:0];
            
        }
    } fail:^(id object) {
        
        for (UIView* view in [self.view subviews]) {
            if (view.tag == 200) {
                [view removeFromSuperview];
            }
        }
        [self finishedPostBannerLayout:0];
        
    }];
    
}
- (NSInteger)numbersForCarousel {
    return self.bannerModel.data.skAdvDetailList.count;
}
#pragma mark - CWCarousel Delegate
- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundView = [[UIView alloc] init];
    cell.contentView.backgroundColor = BaseColor;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.cornerRadius = 8;
    UIImageView *imgView = [cell.contentView viewWithTag:kViewTag];
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgView.tag = kViewTag;
        imgView.backgroundColor = BaseColor;
        [cell.contentView addSubview:imgView];
        
    }
    //    NSString *name = [NSString stringWithFormat:@"%02ld.jpg", index + 1];
    //    UIImage *img = [UIImage imageNamed:name];
    //    if(!img) {
    //        NSLog(@"%@", name);
    //    }
    BannerItem* item = self.bannerModel.data.skAdvDetailList[index];
    [imgView sd_setImageWithURL:[NSURL URLWithString:item.advPicUrl] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    return cell;
}

- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    
    BannerItem* item = self.bannerModel.data.skAdvDetailList[index];
    [self fromBannerPushToVCWithBannerItem:item isFromLaunchBanner:NO];
}


- (void)CWCarousel:(CWCarousel *)carousel didStartScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    //    NSLog(@"开始滑动: %ld", index);
}


- (void)CWCarousel:(CWCarousel *)carousel didEndScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    //    NSLog(@"结束滑动: %ld", index);
}

- (void)delayReload {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadTableState) withObject:nil afterDelay:0.2];
}

- (void)reloadTableState {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_model.isNetError){
        [_tableView.StateView showNetError];
    } else if(_model.isEmptyMyJoin){
        [_tableView.StateView showEmpty];
    } else{
        [_tableView.StateView hidState];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        //        [UIView performWithoutAnimation:^{
        //            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //        }];
    });
}



#pragma mark - SectonHeader
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.myJoinDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView CDdequeueReusableCellWithIdentifier:_model.myJoinDataList[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDTableModel *model = _model.myJoinDataList[indexPath.row];
    
    MessageItem *item = [model.obj isKindOfClass:[NSDictionary class]] ? [MessageItem mj_objectWithKeyValues:model.obj] : (MessageItem *)model.obj;
    if ([item.chatgName isEqualToString:@"通知消息"]) {
        CDPush(self.navigationController, CDVC(@"NotifViewController"), YES);
        return;
    }
    if ([item.chatgName isEqualToString:@"在线客服"]) {
        [self actionShowCustomerServiceAlertView:nil];
        return;
    } else if ([item.chatgName isEqualToString:@"我的好友"]) {
        [self goto_MyFriendMessage:2];
        return;
    }
    [AppModel shareInstance].officeFlag = item.officeFlag;
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    
    [[MessageNet shareInstance] checkGroupId:item.groupId Completed:^(BOOL complete) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (complete) {
            SVP_DISMISS;
            [strongSelf goto_groupChat:item];
        }
        else{
            //            [MessageNet joinGroup:@{@"chatId":item.groupId,@"uid":[AppModel shareInstance].user.userId} Success:^(NSDictionary *info) {
            //                SVP_DISMISS;
            //                [self groupChat:item];
            //            } Failure:^(NSError *error) {
            //                SVP_ERROR(error);
            //            }];
        }
    }];
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [EasyOperater remove];
}


#pragma mark - goto我的好友或客服消息界面
/**
 goto我的好友或客服消息界面
 
 @param type 3 客服  2 我的好友
 */
- (void)goto_MyFriendMessage:(NSInteger)type {
    MyFriendMessageListController *vc = [[MyFriendMessageListController alloc] init];
    vc.friendType = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - goto群组聊天界面
- (void)goto_groupChat:(id)obj {
    ChatViewController *vc = [ChatViewController groupChatWithObj:obj];
    vc.isNewMember = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showMenu{
    if([EasyOperater isExist]){
        [EasyOperater remove];
    }else
        [[EasyOperater sharedInstance] show];
}

#pragma mark - 客服弹框  常见问题
- (void)actionShowCustomerServiceAlertView:(NSString *)messageModel {
    
    NSString *imageUrl = [AppModel shareInstance].commonInfo[@"customer.service.window"];
    if (imageUrl.length == 0) {
        [self webCustomerService];
        return;
    }
    CustomerServiceAlertView *view = [[CustomerServiceAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [view updateView:@"常见问题" imageUrl:imageUrl];
    
    __weak __typeof(self)weakSelf = self;
    
    // 查看详情
    view.customerServiceBlock = ^{
        [weakSelf webCustomerService];
    };
    [view showInView:self.view];
}
- (void)webCustomerService {
    //    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    //    vc.title = @"在线客服";
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self goto_MyFriendMessage:3];
}


#pragma mark - 下拉菜单
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        
        __weak __typeof(self)weakSelf = self;
        
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_recharge"]
                                          title:@"快速充值"
                                         action:^(FYMenuItem *item) {
                                             UIViewController *vc = [[Recharge2ViewController alloc]init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      //                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_share"]
                      //                                          title:@"分享赚钱"
                      //                                         action:^(FYMenuItem *item) {
                      //                                             ShareViewController *vc = [[ShareViewController alloc] init];
                      //                                             vc.hidesBottomBarWhenPushed = YES;
                      //                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                      //                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_agent"]
                                          title:@"代理中心"
                                         action:^(FYMenuItem *item) {
                                             AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_help"]
                                          title:@"帮助中心"
                                         action:^(FYMenuItem *item) {
                                             HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_redp_play"]
                                          title:@"玩法规则"
                                         action:^(FYMenuItem *item) {
                                             WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
                                             vc.navigationItem.title = @"玩法规则";
                                             vc.hidesBottomBarWhenPushed = YES;
                                             //[vc loadWithURL:url];
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_createGroupIcon"]
                                          title:@"创建群组"
                                         action:^(FYMenuItem *item) {
                                             CreateGroupChatController *vc = [[CreateGroupChatController alloc]
                                                                     init];                                       
                                             vc.hidesBottomBarWhenPushed = YES;
                                             
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],

                      nil];
    }
    
    return _menuItems;
}



//导航栏弹出
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    FYMenu *menu = [[FYMenu alloc] initWithItems:self.menuItems];
    menu.menuCornerRadiu = 5;
    menu.showShadow = NO;
    menu.minMenuItemHeight = 48;
    menu.titleColor = [UIColor darkGrayColor];
    menu.menuBackGroundColor = [UIColor whiteColor];
    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
}

@end
