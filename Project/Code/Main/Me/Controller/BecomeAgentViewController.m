//
//  BecomeAgentViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/15.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BecomeAgentViewController.h"

@interface BecomeAgentViewController ()

@end

@implementation BecomeAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理规则";
    // Do any additional setup after loading the view.
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(@56);
//    }];
    
//    UIButton *loginBtn = [UIButton new];
//    [view addSubview:loginBtn];
//    loginBtn.layer.cornerRadius = 8;
//    loginBtn.layer.masksToBounds = YES;
//    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
//    if([AppModel shareInstance].user.agentFlag){
//        [loginBtn setTitle:@"已经是代理" forState:UIControlStateNormal];
//        loginBtn.backgroundColor = COLOR_X(160, 160, 160);
//    }
//    else{
//        [loginBtn setTitle:@"申请代理" forState:UIControlStateNormal];
//        loginBtn.backgroundColor = MBTNColor;
//    }
//    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [loginBtn addTarget:self action:@selector(toBeAgent) forControlEvents:UIControlEventTouchUpInside];
//    [loginBtn delayEnable];
//    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left).offset(30);
//        make.right.equalTo(view.mas_right).offset(-30);
//        make.height.equalTo(@(44));
//        make.centerY.equalTo(view.mas_centerY);
//    }];
//
//    CGRect rect = self.scrollView.frame;
//    rect.size.height -= 56;
//    self.scrollView.frame = rect;
}

-(void)toBeAgent{
    SVP_SHOW;
    [NET_REQUEST_MANAGER askForToBeAgentWithSuccess:^(id object) {
        SVP_SUCCESS_STATUS(object[@"data"]);
        //[weakSelf performSelector:@selector(back) withObject:nil afterDelay:1.0];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
