//
//  UpdateNicknameViewController.m
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "UpdateNicknameViewController.h"

@interface UpdateNicknameViewController (){///<UITableViewDataSource,UITableViewDelegate>
    UITableView *_tableView;
    UITextField *_textField;
}
@end

@implementation UpdateNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    
    self.navigationItem.title = @"昵称";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _tableView.tableHeaderView = headView;
    _tableView.backgroundColor = BaseColor;
    headView.backgroundColor = [UIColor whiteColor];
    _textField = [UITextField new];
    [headView addSubview:_textField];
    _textField.placeholder = @"5字以内（只能输入中文、数字、字母）";
    _textField.text = [AppModel shareInstance].userInfo.nick;
    _textField.font = [UIFont systemFontOfSize2:16];
//    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.bottom.equalTo(headView);
        make.right.equalTo(headView.mas_right).offset(-12);
    }];
}

#pragma mark action
- (void)action_save{//UPDATENAME
    if(_textField.text.length <= 0){
        SVP_ERROR_STATUS(@"请输入昵称");
        return;
    }else if(_textField.text.length > 5){
        SVP_ERROR_STATUS(@"昵称太长");
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATENAME" object:@{@"text":_textField.text}];
    CDPop(self.navigationController, YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

    
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
    
    @end
