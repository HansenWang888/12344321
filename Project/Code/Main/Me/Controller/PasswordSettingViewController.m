//
//  PasswordSettingViewController.m
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "PasswordSettingViewController.h"

@interface PasswordSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_rowList;
}
@end

@implementation PasswordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _rowList = @[@"登录密码",@"支付密码"];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    
    self.navigationItem.title = @"设置";
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50.f;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorColor = TBSeparaColor;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rowList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize2:14];
        cell.textLabel.textColor = Color_3;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _rowList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *vc = (indexPath.row == 0)?@"ForgotViewController":@"PayWordSettingViewController";
    CDPush(self.navigationController, CDVC(vc), YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
