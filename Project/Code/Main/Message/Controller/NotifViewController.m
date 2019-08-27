//
//  NotifViewController.m
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "NotifViewController.h"
#import "NotifMessageNet.h"
#import "NotifDetailViewController.h"

@interface NotifViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NotifMessageNet *_model;
}

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _model = [NotifMessageNet new];
}


#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"通知中心";

    __weak NotifMessageNet *weakModel = _model;
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 81;
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakModel.page ++;
        [weakSelf getData];
    }];
    SVP_SHOW;
    weakModel.page = 1;
    [weakSelf getData];
}

- (void)getData{

}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDTableModel *model = _model.dataList[indexPath.row];
    NotifDetailViewController *vc = [NotifDetailViewController detailVc:model.obj];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
