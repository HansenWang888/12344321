//
//  SettingViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "SettingViewController.h"
#import "ForgotViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_rowList;
    UISwitch *_sw;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _rowList = @[@[@"账号",@"手机号",@"声音"],@[@"重设密码",@"重设支付密码"]];
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
    self.view.backgroundColor = BaseColor;
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.rowHeight = 50;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = _rowList[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"result"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"result"];
        cell.textLabel.font = [UIFont systemFontOfSize2:16];
        cell.textLabel.textColor = Color_0;
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row ==1) {
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.font = [UIFont systemFontOfSize2:15];
                label.textColor = Color_6;
                label.text = (indexPath.row == 0)?[AppModel shareInstance].userInfo.userId:[AppModel shareInstance].userInfo.mobile;
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView.mas_right).offset(-15);
                }];
            }
            if (indexPath.row == 2) {
                
                _sw = [UISwitch new];
                [cell.contentView addSubview:_sw];
                _sw.on = ([AppModel shareInstance].turnOnSound == NO)?YES:NO;//[AppModel shareInstance].turnOnSound;
                [_sw addTarget:self action:@selector(action_setSound) forControlEvents:UIControlEventValueChanged];
                [_sw mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-12);
                    make.centerY.equalTo(cell.contentView);
                }];
            }
        }
        if(indexPath.section == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
            cell.accessoryType = UITableViewCellAccessoryNone;
      }
    cell.textLabel.text = _rowList[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0){
            CDPush(self.navigationController, CDVC(@"ForgotViewController"), YES);
        }else if (indexPath.row == 1){
            CDPush(self.navigationController, CDVC(@"SetPayPasswordController"), YES);
        }
    }
}

#pragma mark action
- (void)action_setSound{
    [AppModel shareInstance].turnOnSound = (_sw.on== NO)?YES:NO;;
    [[AppModel shareInstance] saveAppModel];
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
