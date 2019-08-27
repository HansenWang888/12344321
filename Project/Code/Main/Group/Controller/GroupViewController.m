//
//  GroupViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupViewController.h"
#import "MessageNet.h"
#import "ChatViewController.h"
#import "CreateGroupChatController.h"
#import "MessageItem.h"
//#import "SqliteManage.h"
#import "BANetManager_OC.h"

#import "FYMenu.h"

#import "Recharge2ViewController.h"
#import "ShareViewController.h"
#import "BecomeAgentViewController.h"
#import "HelpCenterWebController.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "AgentCenterViewController.h"


#import "MsgHeaderView.h"

#import "EnterPwdBoxView.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "UIImageView+WebCache.h"

#import "SLMarqueeControl.h"
#import "GridCell.h"
#import "GameMainCell.h"
#define kViewTag 666


@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource,CWCarouselDatasource, CWCarouselDelegate>
@property (nonatomic, strong) NSMutableArray * runloopArray;
@property (nonatomic, strong) BannerModel* bannerModel;
@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIView *animationView;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) MessageNet *model;
@property(nonatomic,strong) SLMarqueeControl *scrollBarView;

@property(nonatomic, strong) NSMutableArray *menuItems;
@property(nonatomic,strong) EnterPwdBoxView *entPwdView;
@property(nonatomic,assign) EnumActionTag clickTag;
@property(nonatomic,strong) GridCell *gridV;
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    _clickTag = EnumActionTag0;
    _runloopArray = [NSMutableArray array];
    
    [self initSubviews];
    [self initLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_r"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
}

-(void)enterFore {
    //    [self performSelector:@selector(getData) withObject:nil afterDelay:1.0];
    
//    if(self.scrollBarView) {
//        [self.scrollBarView start];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
    [self.carousel controllerWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.carousel controllerWillDisAppear];
}

#pragma mark ----- Data
- (void)initData{
    _model = [MessageNet shareInstance];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CDDidReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
}

#pragma mark ----- Layout
- (void)finishedPostBannerLayout:(CGFloat)changeY{
    if (self.scrollBarView) {
        [self.scrollBarView setSd_y:changeY+3];
        [self initLayout];
    }else{
        [self.gridV setSd_y:changeY+3];
        [self initLayout];
    }
}
- (void)initLayout{
//    [self.view layoutIfNeeded];
    if (self.scrollBarView) {
        [self.gridV setSd_y:CGRectGetMaxY(self.scrollBarView.frame)+3];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gridV.mas_bottom).offset(3);
        }];
    }else{
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gridV.mas_bottom).offset(3);
        }];
    }
    
}

#pragma mark ----- subView
- (void)initSubviews {
    self.navigationItem.title = @"群组";
    __weak MessageNet *weakModel = _model;
    [self initScrollBarView];
    
    self.gridV = [[GridCell alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, [GridCell cellHeightWithModel])];
    [self.gridV richElementsInCellWithModel:[FunctionManager findGamesGrids]];
    [self.view addSubview:self.gridV];
    [self.gridV actionBlock:^(NSDictionary *dataModel) {
        if ([dataModel[kType] integerValue]==self->_clickTag) {
            return ;
        }else{
            self->_clickTag = [dataModel[kType] integerValue];
            weakModel.page = 1;
            [self getData];
        }
    }];
    
    self.view.backgroundColor = BaseColor;
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.rowHeight = 70;
    [_tableView YBGeneral_configuration];
    //    _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    //    _tableView.separatorColor = TBSeparaColor;
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            weakModel.page ++;
            [strongSelf getData];
        }
    }];
    
    _tableView.StateView = [StateView StateViewWithHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
    }];
    //SVP_SHOW;
    [NET_REQUEST_MANAGER requestSystemNoticeWithSuccess:^(id object) {
        [self announcementBar];
        [self.tableView reloadData];
    } fail:^(id object) {
        NSLog(@"%@",object);
    }];
    weakModel.page = 1;
    [self getData];
    
}

#pragma mark 收到消息重新刷新
- (void)CDDidReceiveMessageNotification:(NSNotification *)notification{
    [self reloadTableState];
}

- (void)reloadTableState{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
//    [_tableView.StateView hidState];
    [self->_tableView reloadData];
    if(_model.isNetError&&!_model.isEmpty){
        [_tableView.StateView showNetError];
    }
    else if(!_model.isNetError&&_model.isEmpty){
        [_tableView.StateView showEmpty];
    }
    else if(!_model.isNetError&&!_model.isEmpty){
        [_tableView.StateView hidState];
    }
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
                [self->_tableView reloadData];
//        [UIView performWithoutAnimation:^{
//
//                [self->_tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//
//
//        }];
//    });
}

#pragma mark -  获取所有群组列表
/**
 获取所有群组列表
 */
- (void)getData{
    __weak __typeof(self)weakSelf = self;
    if (_clickTag == EnumActionTag0) {
        [_model getGroupListWithSuccessBlock:^(NSDictionary *dic) {
            SVP_DISMISS;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf reloadTableState];
        } failureBlock:^(id fail) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf reloadTableState];
        }];
    }else{
        [_model getGameListWithRequestParams:@(_clickTag) successBlock:^(NSArray *arr) {
            SVP_DISMISS;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf reloadTableState];
        } failureBlock:^(id fail) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf reloadTableState];
        }];
    }
    
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeGroup WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        if (model.data.skAdvDetailList.count>0) {
            self.bannerModel = model;
            
            //            self.animationView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH-0, kGETVALUE_HEIGHT(1010, 315, SCREEN_WIDTH))];
            
            //            self.animationView = [[UIView alloc] initWithFrame:CGRectMake(-60,0, SCREEN_WIDTH+120, kGETVALUE_HEIGHT(1200, 280, SCREEN_WIDTH+120))];
            
            self.animationView = [[UIView alloc] initWithFrame:CGRectMake(7,0, SCREEN_WIDTH-14, kGETVALUE_HEIGHT(1010, 290, SCREEN_WIDTH-14))];
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
            
            //            carousel.layer.masksToBounds = YES;
            //            carousel.layer.cornerRadius = 8;
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
#pragma mark UITableViewDataSource
#pragma mark - SectonHeader
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier =@"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (_clickTag) {
        case EnumActionTag0:
            if ([_model.dataList[indexPath.row] isKindOfClass:[CDTableModel class]]) {
                [tableView setSeparatorColor:TBSeparaColor];
                return [tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.row]];
                
            }else{
                if (cell == nil)
                {
//                    [tableView setSeparatorColor:[UIColor clearColor]];
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
                return cell;
            }
            break;
            
        default:
            {
                if ([_model.dataList[indexPath.row] isKindOfClass:[BannerItem class]]) {
                    GameMainCell *cell = [GameMainCell cellWith:tableView];
                    BannerItem* itemData = _model.dataList[indexPath.row];
                    [cell richElementsInCellWithModel:itemData];
                    [cell actionBlock:^(id data) {
                        if ([data isKindOfClass:[BannerItem class]]) {
                            [self handleGameCell:data];
                        }
                    }];
                    return cell;
                }else{
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    }
                    
                    
                    return cell;
                }
                }
            break;
    }
            
    
}

- (void)handleGameCell:(BannerItem*)item{
    if (_clickTag == EnumActionTag5) {
        NSInteger tag = [item.advLinkUrl integerValue];
        if(tag == 1){
            NSString *urlHead = [AppModel shareInstance].commonInfo[@"big.wheel.lottery.url"];
            if(urlHead.length > 0){
                NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
                vc.navigationItem.title = item.name;
                vc.hidesBottomBarWhenPushed = YES;
                //[vc loadWithURL:url];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            //        WheelViewController *vc = [[WheelViewController alloc] init];
            //        vc.hidesBottomBarWhenPushed = YES;
            //        [self.navigationController pushViewController:vc animated:YES];
        }else if(tag == 2){
            NSString *urlHead = [AppModel shareInstance].commonInfo[@"fruit.slot.url"];
            if(urlHead.length > 0){
                NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
                vc.navigationItem.title = item.name;
                vc.hidesBottomBarWhenPushed = YES;
                //[vc loadWithURL:url];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
    }else{
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    }
    
    
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_clickTag) {
        case EnumActionTag0:
            return (_model.isNetError||_model.isEmpty)?0.1f:70;
            break;
            
        default:
        {
            return (_model.isNetError||_model.isEmpty)?0.1f:[GameMainCell cellHeightWithModel];
            
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_clickTag==0) {
            
        
        CDTableModel *model = _model.dataList[indexPath.row];
        MessageItem *item = [MessageItem mj_objectWithKeyValues:model.obj];
        //    SVP_SHOW;
        __weak __typeof(self)weakSelf = self;
        [[MessageNet shareInstance] checkGroupId:item.groupId Completed:^(BOOL complete) {
            //         SVP_DISMISS;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (complete) {
                [strongSelf groupChat:item isNew:NO];
            } else {
                if (item.password != nil && item.password.length > 0) {
                    [strongSelf passwordBoxView:item];
                } else {
                    [strongSelf joinGroup:item password:nil];
                }
            }
        }];
        
    }
}

- (void)joinGroup:(MessageItem *)item password:(NSString *)password {
    // 加入群组
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [[MessageNet shareInstance] joinGroup:item.groupId password:password successBlock:^(NSDictionary *dict) {
        SVP_DISMISS;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            [strongSelf groupChat:item isNew:YES];
        } else {
            if ([[dict objectForKey:@"errorcode"] integerValue] == 19) {
                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
                SVP_ERROR_STATUS(msg);
                [strongSelf groupChat:item isNew:YES];
            } else if ([[dict objectForKey:@"errorcode"] integerValue] == 25) {
                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
                SVP_ERROR_STATUS(msg);
                [strongSelf getData];
            } else {
                [[FunctionManager sharedInstance] handleFailResponse:dict];
            }
            
        }
        
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

#pragma mark - 输入密码框
- (void)passwordBoxView:(MessageItem *)item {
    EnterPwdBoxView *entPwdView = [[EnterPwdBoxView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    __weak __typeof(self)weakSelf = self;
    _entPwdView = entPwdView;
    
    // 查看详情
    entPwdView.joinGroupBtnBlock = ^(NSString *password){
        [weakSelf enterPwdView:item password:password];
    };
    
    [entPwdView showInView:self.view];
}

- (void)enterPwdView:(MessageItem *)item password:(NSString *)password {
    if (password.length == 0) {
        SVP_ERROR_STATUS(@"请输入密码");
        return;
    }
    [self.entPwdView disMissView];
    [self joinGroup:item password:password];
}



- (void)groupChat:(id)obj isNew:(BOOL)isNew{
    ChatViewController *vc = [ChatViewController groupChatWithObj:obj];
    vc.isNewMember = isNew;
    vc.chatType = FYConversationType_GROUP;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    FYMenu *menu = [[FYMenu alloc] initWithItems:self.menuItems];
    menu.menuCornerRadiu = 5;
    menu.showShadow = NO;
    menu.minMenuItemHeight = 48;
    menu.titleColor = [UIColor darkGrayColor];
    menu.menuBackGroundColor = [UIColor whiteColor];
    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
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

@end
