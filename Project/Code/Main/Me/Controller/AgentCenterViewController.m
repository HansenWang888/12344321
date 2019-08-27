//
//  AgentCenterViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AgentCenterViewController.h"
#import "BecomeAgentViewController.h"
#import "ReportFormsViewController.h"
#import "RecommendedViewController.h"
#import "ShareViewController.h"
#import "CopyViewController.h"

@implementation CellItemView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.tag = 1;
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-11);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize2:15];
        label.textColor = COLOR_X(80, 80, 80);
        label.tag = 2;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(24);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@0.5);
        }];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btn];
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setIcon:(NSString *)icon{
    UIImageView *imageView = [self viewWithTag:1];
    imageView.image = [UIImage imageNamed:icon];
}

-(void)setTitle:(NSString *)title{
    UILabel *label = [self viewWithTag:2];
    label.text = title;
}

@end


@interface AgentCenterViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *menuArray;
@property(nonatomic,strong)CellItemView *item1;
@end

@implementation AgentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"代理中心";
    self.menuArray = [NSMutableArray array];
    NSDictionary *dic = nil;
    if([AppModel shareInstance].userInfo.agentFlag)
        dic = @{@"icon":@"agent_sqdl",@"title":@"您已是代理",@"tag":@"1"};
    else
        dic = @{@"icon":@"agent_sqdl",@"title":@"申请代理",@"tag":@"1"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_dlgz",@"title":@"代理规则",@"tag":@"2"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_tgjc",@"title":@"推广文案",@"tag":@"3"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_xjwj",@"title":@"下级玩家",@"tag":@"4"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_wdbb",@"title":@"我的报表",@"tag":@"5"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_fxzq",@"title":@"分享赚钱",@"tag":@"6"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_gw",@"title":@"保存下载官网",@"tag":@"7"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_dz",@"title":@"保存下载地址",@"tag":@"8"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_wy",@"title":@"保存下载网页",@"tag":@"9"};
    [self.menuArray addObject:dic];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    
    UIView *headView = [self headView];
    [self.scrollView addSubview:headView];
    NSInteger h = headView.frame.size.height;
    NSInteger perNum = 3;
    NSInteger width = SCREEN_WIDTH/perNum;
    NSInteger height = width * 0.6666;
    for (NSInteger i = 0; i < self.menuArray.count; i ++) {
        NSInteger m = i%perNum;
        NSInteger n = i/perNum;
        CellItemView * item = [[CellItemView alloc] initWithFrame:CGRectMake(m * width, h + n * height, width, height)];
        [self.scrollView addSubview:item];
        NSDictionary *dic = self.menuArray[i];
        item.title = dic[@"title"];
        item.icon = dic[@"icon"];
        item.infoDic = self.menuArray[i];
        [item.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
            self.item1 = item;
    }
    
    if([AppModel shareInstance].userInfo.agentFlag == NO){
        [self performSelector:@selector(becomeAgent) withObject:nil afterDelay:0.5];
    }
}

-(void)becomeAgent{
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    WEAK_OBJ(weakSelf, self);
    [view showWithText:@"您还不是代理，是否申请代理？" button1:@"取消" button2:@"提交" callBack:^(id object) {
        NSInteger index = [object integerValue];
        if(index == 1){
            [weakSelf toBeAgent];
        }
    }];
}

-(void)btnAction:(UIButton *)btn{
    CellItemView *item = (CellItemView *)btn.superview;
    NSDictionary *dic = item.infoDic;
    NSInteger tag = [[dic objectForKey:@"tag"] integerValue];
    if(tag == 1){
        if([AppModel shareInstance].userInfo.agentFlag){
//            SVP_SUCCESS_STATUS(@"您已经是代理");
            AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
            [view showWithText:@"您已经是代理" button:@"好的" callBack:nil];
            return;
        }
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        WEAK_OBJ(weakSelf, self);
        [view showWithText:@"是否提交申请？" button1:@"取消" button2:@"提交" callBack:^(id object) {
            NSInteger index = [object integerValue];
            if(index == 1){
                [weakSelf toBeAgent];
            }
        }];
    }else if(tag == 2){
        BecomeAgentViewController *vc = [[BecomeAgentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.hiddenNavBar = YES;
        vc.imageUrl = [AppModel shareInstance].commonInfo[@"agent_rule"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 4){
        PUSH_C(self, RecommendedViewController, YES);
    }else if(tag == 5){
        ReportFormsViewController *vc = [[ReportFormsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userId = [AppModel shareInstance].userInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 6){
        PUSH_C(self, ShareViewController, YES);
    }else if(tag == 7 || tag == 8 || tag == 9){
        NSString *url = [NSString stringWithFormat:@"%@?code=%@",[AppModel shareInstance].commonInfo[@"website.address"],[AppModel shareInstance].userInfo.invitecode];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if(tag == 3){
        CopyViewController *vc = [[CopyViewController alloc] init];
        vc.title = dic[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)toBeAgent{
    __weak __typeof(self)weakSelf = self;
    [[NetRequestManager sharedInstance] askForToBeAgentWithSuccess:^(id object) {
        NSString* str = [object objectForKey:@"alterMsg"];
        if (![FunctionManager isEmpty:str]) {
            AlertTipPopUpView* popupView = [[AlertTipPopUpView alloc]init];
            [popupView showInApplicationKeyWindow];
            [popupView richElementsInViewWithModel:str actionBlock:^(id data) {
                
            }];
        }
        
        [weakSelf requestUserinfo];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestUserinfo{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        if([AppModel shareInstance].userInfo.agentFlag)
            weakSelf.item1.title = @"您已是代理";
    } fail:^(id object) {
        
    }];
}
-(UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    view.backgroundColor = BaseColor;
    
    float rate = 980/320.0;
    NSInteger height = (SCREEN_WIDTH - 30)/rate + 30;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    containView.backgroundColor = [UIColor whiteColor];
    [view addSubview:containView];
    
    CGRect rect = view.frame;
    rect.size.height = height + 10;
    view.frame = rect;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"agentBanner"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [containView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containView).offset(15);
        make.right.bottom.equalTo(containView).offset(-15);
    }];
    return view;
}
@end
