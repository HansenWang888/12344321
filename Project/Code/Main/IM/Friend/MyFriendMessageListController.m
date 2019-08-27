//
//  MyFriendController.m
//  Project
//
//  Created by Mike on 2019/6/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "MyFriendMessageListController.h"
#import "ChatViewController.h"
#import "FYMenu.h"

#import "MessageItem.h"
#import "EasyOperater.h"
#import "SystemAlertViewController.h"

#import "ShareViewController.h"
#import "Recharge2ViewController.h"
#import "BecomeAgentViewController.h"
#import "HelpCenterWebController.h"
#import "AgentCenterViewController.h"
#import "CreateGroupChatController.h"
#import "VVAlertModel.h"
#import "PushMessageModel.h"
#import "MessageSingle.h"
#import "SqliteManage.h"

#import "CWCarousel.h"
#import "UIImageView+WebCache.h"

#import "MyFriendMessageListCell.h"
#import "WHC_ModelSqlite.h"
#import "FYContacts.h"
#import "BANetManager_OC.h"


#define kViewTag 666

@interface MyFriendMessageListController ()<UITableViewDelegate,UITableViewDataSource,CWCarouselDatasource, CWCarouselDelegate>
@property (nonatomic, strong) BannerModel* bannerModel;
@property (nonatomic, strong) CWCarousel *carousel;
@property(nonatomic, strong) NSMutableArray *menuItems;

@property (nonatomic, strong) UIView *animationView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UILabel *promptLabel;

//
@property (nonatomic,assign) BOOL isDisappearController;

@end

@implementation MyFriendMessageListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友消息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initSubviews];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.hidden = YES;
    promptLabel.text = @"您还没有消息！";
    promptLabel.font = [UIFont systemFontOfSize:22];
    promptLabel.textColor = [UIColor darkGrayColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:promptLabel];
    _promptLabel = promptLabel;
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
    }];
    
    
    
    if (self.friendType == 3) {
        if ([AppModel shareInstance].myCustomerServiceListDict.count == 0) {
            [self queryContactsData];
        } else {
            [self getServiceMembers];
        }
    } else {
//        [self getMyFriendList];
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_r"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateValue:)name:kUnreadMessageNumberChange object:@"MyFriendListNotification"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUpdateMyFriendOrServiceMembers)name:kUpdateMyFriendOrServiceMembersMessageList object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];

}

- (void)onUpdateMyFriendOrServiceMembers {
     [self getMyFriendList];
}

#pragma mark - 计算验证未读消息
- (void)calculateUnreadMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.friendType == 3) {
            return;
//            [AppModel shareInstance].customerServiceUnReadTotal = 0;
        } else {
            [AppModel shareInstance].friendUnReadTotal = 0;
        }
        for (NSInteger index = 0; index < self.dataSource.count; index++) {
            FYContacts *model =  self.dataSource[index];
            
            NSString *queryId = [NSString stringWithFormat:@"%@-%@",model.sessionId,[AppModel shareInstance].userInfo.userId];
            PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
            if (pmModel) {
                if (self.friendType == 3) {
//                    [AppModel shareInstance].customerServiceUnReadTotal += pmModel.number;
                } else {
                    [AppModel shareInstance].friendUnReadTotal += pmModel.number;
                }
            }
        }
    });
}




#pragma mark - 获取好友会话列表
- (void)getMyFriendList {

    self.dataSource = [NSMutableArray array];
//    NSString *queryTest = [NSString stringWithFormat:@"select * from FYContacts where accountUserId='%@'",[AppModel shareInstance].userInfo.userId];
//    NSArray *whereMyFriendByArrayTest = [WHC_ModelSqlite query:[FYContacts class] sql:queryTest];
    
    NSString *query = [NSString stringWithFormat:@"select * from FYContacts where contactsType = 2 and accountUserId='%@' order by isTopTime desc,lastTimestamp desc,lastCreate_time desc limit 999999",[AppModel shareInstance].userInfo.userId];
    NSArray *whereMyFriendByArray = [WHC_ModelSqlite query:[FYContacts class] sql:query];
    for (NSInteger index = 0; index < whereMyFriendByArray.count; index++) {
        FYContacts *model = (FYContacts *)whereMyFriendByArray[index];
        [self.dataSource addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self.tableView.StateView showEmpty];
        } else {
            [self.tableView.StateView hidState];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self calculateUnreadMessages];
    });
    
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)enterFore {
    [self performSelector:@selector(getData) withObject:nil afterDelay:1.0];
    NSLog(@"进入前台");
}

#pragma mark 收到消息重新刷新
- (void)updateValue:(NSNotification *)noti {
        NSString *info = [noti object];
        if ([info isEqualToString:@"MyFriendListNotification"] && !self.isDisappearController) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataSource.count == 0) {
                    [self.tableView.StateView showEmpty];
                } else {
                    [self.tableView.StateView hidState];
                }
                [self.tableView reloadData];
            });
        }
}

// 
- (void)initSubviews {
    
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
    
    __weak __typeof(self)weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //         [strongSelf getData];
        if (self.friendType == 3) {
            [strongSelf queryContactsData];
        } else {
            [strongSelf getMyFriendList];
        }
        
    }];

}


/**
 查询通讯录数据
 */
- (void)queryContactsData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/friend/getContact"];
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"code"] != nil && [[response objectForKey:@"code"] integerValue] == 0) {
            [strongSelf loadLocalData:[response objectForKey:@"data"]];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)loadLocalData:(NSDictionary *)dataDict
{
    self.dataSource = [NSMutableArray array];
    NSArray *serviceMembersArray = (NSArray *)[dataDict objectForKey:@"serviceMembers"];
    
    for (int i = 0; i < serviceMembersArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:serviceMembersArray[i]];
        contact.contactsType = 3;
        [self.dataSource addObject:contact];
    }
    
    FYContacts *meiqiaModel = [[FYContacts alloc] init];
    meiqiaModel.name = @"在线客服";
    meiqiaModel.nick = @"在线客服";
    meiqiaModel.avatar = @"msg4";
    [self.dataSource addObject:meiqiaModel];
    
    [self.tableView reloadData];
    
}

#pragma mark - 获取客服会话列表
- (void)getServiceMembers {
    self.dataSource = [NSMutableArray array];
    
    NSMutableDictionary *myServiceListDictTemp = [[NSMutableDictionary alloc] init];
    NSArray *myCustomerServiceListArray = [[AppModel shareInstance].myCustomerServiceListDict allValues];
    for (NSInteger index = 0; index < myCustomerServiceListArray.count; index++) {
        FYContacts *model = (FYContacts *)myCustomerServiceListArray[index];
            [self.dataSource insertObject:model atIndex:0];
        [myServiceListDictTemp setObject:model forKey:model.userId];
    }
    [AppModel shareInstance].myCustomerServiceListDict = [myServiceListDictTemp copy];
    
    FYContacts *meiqiaModel = [[FYContacts alloc] init];
    meiqiaModel.name = @"在线客服";
    meiqiaModel.nick = @"在线客服";
    meiqiaModel.avatar = @"msg4";
    [self.dataSource addObject:meiqiaModel];
    
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
    self.isDisappearController = NO;
    if (self.friendType == 2) {
        [self getMyFriendList];
    } else {
        [self getServiceMembers];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isDisappearController = YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return section==0?0:self.dataSource.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.section == 0) {
    //          return Nil;
    //    } else {
    //        static NSString *CellIdentifier = @"MyFriendMessageListCell";
    //
    //        MyFriendMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //        if(cell == nil) {
    //            cell = [MyFriendMessageListCell cellWithTableView:tableView reusableId:CellIdentifier];
    //        }
    //
    //        FYContacts *contact = (FYContacts *)[self.dataSource objectAtIndex:indexPath.row];
    //        cell.model = contact;
    //        return cell;
    //    }
    
    static NSString *CellIdentifier = @"MyFriendMessageListCell";
    
    MyFriendMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [MyFriendMessageListCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    
    FYContacts *contact = (FYContacts *)[self.dataSource objectAtIndex:indexPath.row];
    cell.model = contact;
    return cell;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.friendType == 2) {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FYContacts *contact = (FYContacts *)[self.dataSource objectAtIndex:indexPath.row];
    NSString *whereStr = [NSString stringWithFormat:@"sessionId='%@'",contact.sessionId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WHC_ModelSqlite delete:[FYMessage class] where:whereStr];
        [WHC_ModelSqlite delete:[FYContacts class] where:whereStr];
    });
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
    [self updateUnreadMessageSessionId:contact.sessionId];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if (indexPath.section==0) {
     CDTableModel *model = self.dataSource[indexPath.row];
     MessageItem *item = [model.obj isKindOfClass:[NSDictionary class]] ? [MessageItem mj_objectWithKeyValues:model.obj] : (MessageItem *)model.obj;
     if ([item.chatgName isEqualToString:@"通知消息"]) {
     CDPush(self.navigationController, CDVC(@"NotifViewController"), YES);
     return;
     }
     }
     */
    
    FYContacts *model = self.dataSource[indexPath.row];
    if (self.friendType == 3 && [model.name isEqualToString:@"在线客服"]) {
        [self webCustomerService];
    } else {
        [self goto_groupChat:model];
    }
}
#pragma mark - 更新未读消息
/**
 更新未读消息
 */
- (void)updateUnreadMessageSessionId:(NSString *)sessionId {
    
    FYChatConversationType conType;
    if (self.friendType == 2) {
        conType = FYConversationType_PRIVATE;
    } else {
        conType = FYConversationType_CUSTOMERSERVICE;
    }
    [[FYIMManager shareInstance] updateGroup:sessionId number:0 lastMessage:@"暂无未读消息" messageCount:0 left:0 chatType: conType];
}

- (void)webCustomerService {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = @"在线客服";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - goto好友聊天界面
- (void)goto_groupChat:(FYContacts *)model {
    ChatViewController *vc = [ChatViewController privateChatWithModel:model];
    vc.toContactsModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 广告横幅
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [EasyOperater remove];
}
-(void)showMenu{
    if([EasyOperater isExist]){
        [EasyOperater remove];
    }else
        [[EasyOperater sharedInstance] show];
}

#pragma mark - 导航栏列表
// 导航栏弹出
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



#pragma mark - 系统公告栏
- (void)scrollBarViewAction {
    [self announcementBar];
}

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

#pragma mark - 通知列表
- (void)getData {
    __weak __typeof(self)weakSelf = self;
    
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeMsg WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            self.bannerModel = model;
            
            self.animationView = [[UIView alloc] initWithFrame:CGRectMake(7,0, SCREEN_WIDTH-14, kGETVALUE_HEIGHT(505, 107, SCREEN_WIDTH-14))];
            
            self.animationView.tag = 200;
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
            [carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
            [carousel freshCarousel];
            self.carousel = carousel;
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.animationView.mas_bottom).offset(3);
            }];
            
        }else{
            //            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
            //            weakSelf.tableView.tableHeaderView = view;
            for (UIView* view in [self.view subviews]) {
                if (view.tag == 200) {
                    [view removeFromSuperview];
                }
            }
            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
        }
    } fail:^(id object) {
        //        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        //        weakSelf.tableView.tableHeaderView = view;
        for (UIView* view in [self.view subviews]) {
            if (view.tag == 200) {
                [view removeFromSuperview];
            }
        }
        [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
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
    BannerItem* item = self.bannerModel.data.skAdvDetailList[index];
    [imgView sd_setImageWithURL:[NSURL URLWithString:item.advPicUrl] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    return cell;
}

@end

