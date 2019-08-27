//
//  ActivityViewController.m
//  Project
//
//  Created by fy on 2019/1/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityView.h"

@interface ActivityViewController ()
@property(nonatomic,strong)ActivityView *activityView;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.vcTitle;
    if(self.userId == nil)
        self.userId = [AppModel shareInstance].userInfo.userId;
    ActivityView *view = [[ActivityView alloc] init];
    view.userId = self.userId;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.activityView = view;
}

@end
