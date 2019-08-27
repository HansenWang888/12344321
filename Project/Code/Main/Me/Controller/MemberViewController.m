//
//  MemberViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberHeadView.h"
#import "WXShareModel.h"
#import "WXManage.h"
#import "MemberCell.h"
#import "RecommendedViewController.h"
#import "MakeMoneyViewController.h"
#import "BillViewController.h"
#import "MemberInfoViewController.h"
#import "SettingViewController.h"
#import "TopupViewController.h"
#import "ShareViewController.h"
#import "ReportFormsViewController.h"
#import "ActivityViewController.h"
#import "AlertViewCus.h"
#import "BecomeAgentViewController.h"
#import "WheelViewController.h"
#import "AddBankCardViewController.h"
#import "WithdrawMainViewController.h"
#import "DepositOrderController.h"
#import "WebViewController.h"
#import "HelpCenterWebController.h"
#import "AgentCenterViewController.h"
#import "BillTypeViewController.h"
#import "Recharge2ViewController.h"
#import "YEBVC.h"
@implementation CellData

-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon showArrow:(BOOL)showArrow tag:(NSInteger)tag{
    if(self = [super init]){
        self.title = title;
        self.subTitle = subTitle;
        self.icon = icon;
        self.showArrow = showArrow;
        self.tag = tag;
    }
    return self;
}
@end

@interface MemberViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    MemberHeadView *_headView;
    NSInteger _headHeight;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIImageView *imageBgView;
@property(nonatomic,strong)NSString *shareUrl;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
    [_headView update];
    
    if(self.navigationController.navigationBarHidden == NO)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getUserInfo];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_tableView.tableHeaderView == nil) {
        _tableView.tableHeaderView = _headView;
    }
    
}

#pragma mark ----- Data
- (void)initData{
    self.dataArray = [[NSMutableArray alloc] init];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
    
    CellData *cellData1 = [[CellData alloc] initWithTitle:@"邀请码" subTitle:[AppModel shareInstance].userInfo.invitecode icon:@"my-code" showArrow:NO tag:1];
    [sectionArray addObject:cellData1];
    [self.dataArray addObject:sectionArray];

    sectionArray = [[NSMutableArray alloc] init];
    CellData *cellData2 = [[CellData alloc] initWithTitle:@"充值中心" subTitle:nil icon:@"my-recharge" showArrow:YES tag:2];
    [sectionArray addObject:cellData2];
    CellData *cellData3 = [[CellData alloc] initWithTitle:@"提现中心" subTitle:nil icon:@"my-withdrawals" showArrow:YES tag:3];
    [sectionArray addObject:cellData3];
    [self.dataArray addObject:sectionArray];

    sectionArray = [[NSMutableArray alloc] init];
    CellData *cellData14 = [[CellData alloc] initWithTitle:@"账单记录" subTitle:nil icon:@"my-zdjl" showArrow:YES tag:14];
    [sectionArray addObject:cellData14];
    CellData *cellData10 = [[CellData alloc] initWithTitle:@"帮助中心" subTitle:nil icon:@"my-help" showArrow:YES tag:10];
    [sectionArray addObject:cellData10];
    [self.dataArray addObject:sectionArray];

    NSString *s = [[FunctionManager sharedInstance] getApplicationVersion];
    CellData *cellData5 = [[CellData alloc] initWithTitle:@"版本" subTitle:s icon:@"my-version" showArrow:NO tag:5];
    CellData *cellData6 = [[CellData alloc] initWithTitle:@"设置" subTitle:nil icon:@"my-option" showArrow:YES tag:6];
    CellData *cellData7 = [[CellData alloc] initWithTitle:@"退出" subTitle:nil icon:@"my-exit" showArrow:YES tag:7];
    NSArray *sectionArray2 = [NSArray arrayWithObjects:cellData5,cellData6,cellData7, nil];
    [self.dataArray addObject:sectionArray2];
}

#pragma mark ----- Layout
- (void)initLayout{
    if(SCREEN_HEIGHT >= 812){
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-26);
        }];
    }else{
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-22);
        }];
    }
}

#pragma mark ----- subView
- (void)initSubviews{
    self.navigationItem.title = @"我的";
    
    _headHeight = 200;
    if(SCREEN_HEIGHT >= 812)
        _headHeight += 4;
    self.imageBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headHeight);
    
    _headView = [[MemberHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headHeight)];
    [_headView addTarget:self action:@selector(action_info) forControlEvents:UIControlEventTouchUpInside];
    [_headView.zuanQianBtn addTarget:self action:@selector(zuanQian) forControlEvents:UIControlEventTouchUpInside];
    [_headView.zhangDanBtn addTarget:self action:@selector(becomeAgent) forControlEvents:UIControlEventTouchUpInside];
    [_headView.yuEBaoBtn addTarget:self action:@selector(goToYuEBaoVC) forControlEvents:UIControlEventTouchUpInside];
    _headView.backgroundColor = [UIColor clearColor];

    _tableView = [UITableView groupTable];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    _tableView.rowHeight = 50.f;
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getUserInfo];
    }];
    
    self.imageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBarBg"]];//me_Background
    [_tableView.backgroundView addSubview:self.imageBgView];
    
    if([_tableView.mj_header respondsToSelector:@selector(stateLabel)]){
        UILabel *label = (UILabel *)[_tableView.mj_header performSelector:@selector(stateLabel)];
        label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    }
    if([_tableView.mj_header respondsToSelector:@selector(lastUpdatedTimeLabel)]){
        UILabel *label = (UILabel *)[_tableView.mj_header performSelector:@selector(lastUpdatedTimeLabel)];
        label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    }
}

#pragma mark net
- (void)getUserInfo{
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf update];
        strongSelf.shareUrl = [NSString stringWithFormat:@"%@",[object[@"data"] objectForKey:@"domainUrl"]];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)update{
    [_headView update];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataArray[section];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 8;
    return 3.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellData *cellData = self.dataArray[indexPath.section][indexPath.row];
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)row];
    MemberCell *cell =(MemberCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.itemIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
        }];
        cell.itemIcon.image = [UIImage imageNamed:cellData.icon];
        cell.itemLabel.text = cellData.title;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if(cellData.tag == 1){
            cell.rightArrowImage.hidden = YES;
            UILabel *copyLabel = [[UILabel alloc] init];
            copyLabel.textColor = COLOR_X(245, 116, 35);
            copyLabel.layer.masksToBounds = YES;
            copyLabel.layer.borderColor = copyLabel.textColor.CGColor;
            copyLabel.layer.borderWidth = 0.5;
            copyLabel.textAlignment = NSTextAlignmentCenter;
            copyLabel.layer.cornerRadius = 4.0;
            [cell.contentView addSubview:copyLabel];
            copyLabel.text = @"复制";
            copyLabel.font = [UIFont systemFontOfSize2:13];
            [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-19);
                make.centerY.equalTo(cell.contentView);
                make.width.equalTo(@46);
                make.height.equalTo(@26);
            }];

            [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-74);
            }];
        }
        if(cellData.showArrow)
            cell.rightArrowImage.hidden = NO;
        else cell.rightArrowImage.hidden = YES;
    }
    cell.rightLabel.text = cellData.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    WXShareModel *model = [[WXShareModel alloc]init];
    //    model.title = WXShareTitle;
    //    model.imageIcon = [UIImage imageNamed:@"my-recharge"];
    //    model.link = WXShareLink;
    //    model.content = WXShareDescription;
    //    model.WXShareType = 1;
    //    [[WXManage shareInstance]wxShareObj:model Success:^{
    //    } Failure:^(NSError *error) {
    //    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CellData *data = self.dataArray[indexPath.section][indexPath.row];
    if (data.tag == 1){
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = [AppModel shareInstance].userInfo.invitecode;
        SVP_SUCCESS_STATUS(@"复制成功");
    } else if(data.tag == 2){
//        PUSH_C(self, Recharge2ViewController, YES);
        Recharge2ViewController *vc = [[Recharge2ViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (data.tag == 3){
//        PUSH_C(self, WithdrawMainViewController, YES);
        WithdrawMainViewController *vc = [[WithdrawMainViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(data.tag == 4){
//        PUSH_C(self, RecommendedViewController, YES);
        RecommendedViewController *vc = [[RecommendedViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(data.tag == 5){
        SVP_SHOW;
        [[FunctionManager sharedInstance] checkVersion:YES];
    } else if(data.tag == 6){
//        PUSH_C(self, SettingViewController, YES);
        SettingViewController *vc = [[SettingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if(data.tag == 7){
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"是否退出？" button1:@"取消" button2:@"退出" callBack:^(id object) {
            NSInteger tag = [object integerValue];
            if(tag == 1){
                [self logout];
            }
        }];
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否退出？" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController modifyColor];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[AppModel shareInstance] logout];
//        }];
//        [okAction setValue:Color_0 forKey:@"_titleTextColor"];
//        [alertController addAction:okAction];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        [cancelAction setValue:Color_0 forKey:@"_titleTextColor"];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if(data.tag == 8){
        ReportFormsViewController *vc = [[ReportFormsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userId = [AppModel shareInstance].userInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(data.tag == 9){
        ActivityViewController *vc = [[ActivityViewController alloc] init];
        vc.vcTitle = @"活动中心";
        vc.userId = [AppModel shareInstance].userInfo.userId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(data.tag == 10){
        [self helpCenter];
    } else if(data.tag == 11){
        GuideView *guideView = [[GuideView alloc] initWithArray:@[@"guide0",@"guide1",@"guide2"] target:nil selector:nil];
        [guideView showWithAnimationWithAni:YES];
    } else if(data.tag == 12){
        WheelViewController *vc = [[WheelViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(data.tag == 13){
        NSString *url = [NSString stringWithFormat:@"%@?code=%@",[AppModel shareInstance].commonInfo[@"website.address"],[AppModel shareInstance].userInfo.invitecode];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
//        vc.title = @"下载页";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if(data.tag == 14)
        [self zhangDan];
}

-(void)logout{
    [NET_REQUEST_MANAGER removeTokenWithSuccess:nil fail:nil];
    [[AppModel shareInstance] logout];
}
#pragma mark action
- (void)action_info{
    MemberInfoViewController* miVC = [[MemberInfoViewController alloc]init];
    if (![FunctionManager isEmpty:self.shareUrl]) {
        miVC.shareUrl = self.shareUrl;
    }
    miVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:miVC animated:YES];
//    PUSH_C(self, MemberInfoViewController, YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 余额宝
- (void)goToYuEBaoVC{
    
    YEBVC *vc = [YEBVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)zuanQian{
    //PUSH_C(self, MakeMoneyViewController, YES);
//    PUSH_C(self, ShareViewController, YES);
    ShareViewController *vc = [[ShareViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)zhangDan{
//    PUSH_C(self, BillTypeViewController, YES);
    BillTypeViewController *vc = [[BillTypeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)becomeAgent{
    AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    //    BecomeAgentViewController *vc = [[BecomeAgentViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.hiddenNavBar = YES;
//    vc.imageUrl = @"http://app.520qun.com/img/proxy_info.jpg";
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)helpCenter{
//    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//    [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
//    return;
    
    HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger offsetY = scrollView.contentOffset.y;
    CGRect rect = self.imageBgView.frame;
    //NSInteger width = SCREEN_WIDTH * (1 - offsetY/SCREEN_WIDTH);
    rect.size.height = _headHeight + 20 - offsetY + 35;
//    if(width < SCREEN_WIDTH)
//        width = SCREEN_WIDTH;
//    rect.size.width = width;
//    NSInteger a = SCREEN_WIDTH - width;
//    rect.origin.x = a;
    rect.origin.y = -35;
    self.imageBgView.frame = rect;
}
@end
