//
//  SuperViewController.m
//  Project
//
//  Created by fy on 2018/12/28.
//  Copyright © 2018 CDJay. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BaseColor;
//
//    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];//navback
//    [backBtn addTarget:self action:@selector(removeAndBack) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame=CGRectMake(0,0,44, 44);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 2, 10, 8);
//    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIBarButtonItem * backButtonItem = [[UIBarButtonItem new] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem=backButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController.navigationBarHidden == YES)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)removeAndBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
