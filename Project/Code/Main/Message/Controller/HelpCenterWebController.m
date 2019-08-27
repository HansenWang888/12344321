//
//  HelpCenterWebController.m
//  Project
//
//  Created by Mike on 2019/3/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "HelpCenterWebController.h"

@interface HelpCenterWebController ()
@property(nonatomic,strong)NSMutableArray *guideArray;
@end

@implementation HelpCenterWebController

    - (instancetype)initWithUrl:(NSString *)url{
        self = [super init];
        if (self) {
            NSString *url = [NSString stringWithFormat:@"%@/dist/#/index/helpCenter?accesstoken=%@&tenant=%@", [AppModel shareInstance].commonInfo[@"website.address"], [AppModel shareInstance].userInfo.token,kNewTenant];
            _url = url;
        }
        return self;
    }
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    self.isForceEscapeWebVC = YES;
    UIButton *regisBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    regisBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [regisBtn setTitle:@"玩法规则" forState:UIControlStateNormal];
    [regisBtn addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    [regisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:regisBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 新手引导页
- (void)guideAction{
    
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
    vc.navigationItem.title = @"玩法规则";
    vc.hidesBottomBarWhenPushed = YES;
    //[vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
//    SVP_SHOW;
//    WEAK_OBJ(weakSelf, self);
//    [NET_REQUEST_MANAGER getGuideImageListWithSuccess:^(id object) {
//        SVP_DISMISS;
//        NSArray *arr = object[@"data"];
//        weakSelf.guideArray = [NSMutableArray array];
//        for (NSDictionary *dic in arr) {
//            [weakSelf.guideArray addObject:dic[@"content"]];
//        }
//        [weakSelf showGuide];
//    } fail:^(id object) {
//        [[FunctionManager sharedInstance] handleFailResponse:object];
//    }];
}

-(void)showGuide{
    if(self.guideArray.count == 0){
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    self.webView.userInteractionEnabled = NO;
    GuideView *guideView = [[GuideView alloc] initWithArray:self.guideArray target:self selector:@selector(funa)];
    [guideView showWithAnimationWithAni:YES];
    [self.webView reload];

}

-(void)funa{
    self.webView.userInteractionEnabled = YES;
}
@end
