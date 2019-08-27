//
//  ReportFormsViewController.m
//  Project
//
//  Created by fy on 2019/1/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportFormsViewController.h"

@implementation ReportFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的报表";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"今天" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"translation"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [btn addTarget:self action:@selector(showTimeSelectView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
    self.rightBtn = btn;
    
    ReportFormsView *view = [[ReportFormsView alloc] init];
    view.userId = self.userId;
    view.rightBtn = self.rightBtn;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.reportFormsView = view;
}

-(void)showTimeSelectView{
    [self.reportFormsView showTimeSelectView];
}
@end
