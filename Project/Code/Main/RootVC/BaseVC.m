//
//  BaseVC.m
//  Project
//
//  Created by Aalto on 2019/5/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BaseVC.h"
#import "WebViewController.h"

#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"

#import "BaseTabBarController.h"

#import "ChatViewController.h"
#import "EnterPwdBoxView.h"
#import "MessageNet.h"
#import "MessageItem.h"
@interface BaseVC ()
@property(nonatomic,strong) EnterPwdBoxView *entPwdView;
@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)fromBannerPushToVCWithBannerItem:(BannerItem*)item isFromLaunchBanner:(BOOL)isFromLaunchBanner{
    if (![FunctionManager isEmpty:item.advLinkUrl]) {
        [NET_REQUEST_MANAGER requestClickBannerWithAdvSpaceId:item.advSpaceId Id:item.ID success:^(id object) {
            
        } fail:^(id object) {
            
        }];
    }
    NSInteger i = [item.linkType integerValue];
    WEAK_OBJ(weakSelf, self);
    switch (i) {
        case 1:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                WebViewController *vc = [[WebViewController alloc] initWithUrl:item.advLinkUrl];
                vc.navigationItem.title = item.name;
                vc.hidesBottomBarWhenPushed = YES;
                //[vc loadWithURL:url];
                [self.navigationController pushViewController:vc animated:YES];
                if (isFromLaunchBanner) {
                    [vc actionBlock:^(id data) {
                        [[AppModel shareInstance] reSetTabBarAsRootAnimation];
                    }];
                }
            }
        }
            break;
        case 2:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                for (CDTableModel *model in [MessageNet shareInstance].dataList) {
                    MessageItem *data = [MessageItem mj_objectWithKeyValues:model.obj];
                    if ([item.advLinkUrl isEqualToString: data.groupId]) {
                        [weakSelf chatProcessing:data];
                    }
                }
            }
        }
            break;
        case 3:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                
                [NET_REQUEST_MANAGER getActivityListWithSuccess:^(id object) {
                    NSDictionary * dict = object;
                    NSArray* dataArray = dict[@"data"][@"records"];
                    if(dataArray==nil || dataArray.count == 0){
                        [weakSelf locateTabBar:2];
                    }else{
                        [weakSelf pushToActivityVC:dataArray onType:[item.advLinkUrl integerValue]];
                    }
                } fail:^(id object) {
                    [[FunctionManager sharedInstance] handleFailResponse:object];
                }];
                
            }else{
                [weakSelf locateTabBar:2];
            }
        }
            break;
        case 4:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                NSInteger index = [item.advLinkUrl integerValue];
                if (index==1||index==2) {
                    NSString *urlHead = @"";
                    NSString *urlTitle = @"";
                    if (index==1) {
                        urlHead = [AppModel shareInstance].commonInfo[@"big.wheel.lottery.url"];
                        urlTitle = @"幸运大转盘";
                    }else if (index==2){
                        urlHead = [AppModel shareInstance].commonInfo[@"fruit.slot.url"];
                        urlTitle = @"水果游戏机";
                    }
                    if (urlHead.length > 0) {
                        NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                        WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
                        vc.navigationItem.title = urlTitle;
                        vc.hidesBottomBarWhenPushed = YES;
                        //[vc loadWithURL:url];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        [weakSelf locateTabBar:3];
                    }
                    
                }else{
                    [weakSelf locateTabBar:3];
                }
                
                
            }else{
                [weakSelf locateTabBar:3];
            }
        }
            break;
        case 5:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
                vc.imageUrl = item.advLinkUrl;
                vc.hiddenNavBar = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        
        case 6://代理
        case 7://充值
        case 8://提现
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                if ([FunctionManager isPureInt:item.advLinkUrl]) {
                    [weakSelf locateTabBar:[item.advLinkUrl integerValue]];
                }else{
                    UIViewController *vc =[[NSClassFromString([NSString stringWithFormat:@"%@",item.advLinkUrl]) alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        default:
        {
//            if (![FunctionManager isEmpty:item.advLinkUrl]) {
//                if ([FunctionManager isPureInt:item.advLinkUrl]) {
//                    [weakSelf locateTabBar:[item.advLinkUrl integerValue]];
//                }else{
//                    UIViewController *vc =[[NSClassFromString([NSString stringWithFormat:@"%@",item.advLinkUrl]) alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                }
//            }
        }
            break;
    }
    
}

- (void)chatProcessing:(MessageItem*)item{
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
            }else{
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
    _entPwdView = entPwdView;
    [_entPwdView showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    
    
    // 查看详情
    _entPwdView.joinGroupBtnBlock = ^(NSString *password){
        [weakSelf enterPwdView:item password:password];
    };
    
    
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
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushToActivityVC:(NSArray*) dataArray onType:(NSInteger)type{
    
    for (NSDictionary *dic in dataArray) {
        NSInteger index = [dic[@"type"] integerValue];
        if (type == index) {
            
            if(type == RewardType_bzsz || type == RewardType_ztlsyj || type == RewardType_yqhycz || type == RewardType_czjl || type == RewardType_zcdljl){//6000豹子顺子奖励 5000直推流水佣金 1110邀请好友充值 1100充值奖励 2100注册登录奖励
                ActivityDetail1ViewController *vc = [[ActivityDetail1ViewController alloc] init];
                vc.infoDic = dic;
                vc.imageUrl = dic[@"bodyImg"];
                vc.title = dic[@"mainTitle"];
                vc.hiddenNavBar = YES;
                vc.top = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(type == RewardType_fbjl
                     ||type == RewardType_qbjl
                     ||type == RewardType_jjj){// 3000发包奖励 4000抢包奖励
                ActivityDetail2ViewController *vc = [[ActivityDetail2ViewController alloc] init];
                vc.infoDic = dic;
                vc.title = dic[@"mainTitle"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self locateTabBar:2];
            }
            
        }
    }
    
}
- (void)locateTabBar:(NSInteger)index{
    if (self.navigationController.tabBarController.selectedIndex == index) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
    self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
       
        BaseTabBarController *tabBarC = (BaseTabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        tabBarC.selectedIndex = index;
        [tabBarC hadSelectedIndex:index];
//  self.navigationController.tabBarController.selectedIndex=index;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
