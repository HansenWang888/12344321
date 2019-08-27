//
//  ForgotViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "LoginBySMSViewController.h"
#import "NetRequestManager.h"
@interface LoginBySMSViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *_tableView;
    NSArray *_dataList;
    UITextField *_textField[2];
    UILabel *_sexLabel;
}
@property(nonatomic,strong)UIButton *codeBtn;
@end

@implementation LoginBySMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _dataList = @[@{@"title":@"请输入手机号",@"img":@"icon_phone"},@{@"title":@"请输入验证码",@"img":@"icon_security"}];
}


#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    
    self.navigationItem.title = @"验证码登录";
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 52;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorColor = TBSeparaColor;
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _tableView.tableFooterView = fotView;
    
    UIButton *btn = [UIButton new];
    [fotView addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MBTNColor;
    [btn delayEnable];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(44));
        make.top.equalTo(fotView.mas_top).offset(16);
    }];
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        
        if (indexPath.row == 0) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = COLOR_X(244, 112, 35);//[UIColor colorWithHexString:@""];
            [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
        }
        _textField[indexPath.row] = [UITextField new];
        [cell.contentView addSubview:_textField[indexPath.row]];
        _textField[indexPath.row].placeholder = _dataList[indexPath.row][@"title"];
        _textField[indexPath.row].font = [UIFont systemFontOfSize2:15];
        _textField[indexPath.row].clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField[indexPath.row].delegate = self;
        CGFloat r = (indexPath.row == 0)?116:15;
        [_textField[indexPath.row] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(50);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
        if(indexPath.row == 0)
            _textField[indexPath.row].keyboardType = UIKeyboardTypePhonePad;
        else{
            _textField[indexPath.row].returnKeyType = UIReturnKeyDone;
            _textField[indexPath.row].keyboardType = UIKeyboardTypeNamePhonePad;

        }
    }
    cell.imageView.image = [UIImage imageNamed:_dataList[indexPath.row][@"img"]];
    return cell;
}

#pragma mark action
- (void)action_getCode{
    if (_textField[0].text.length < 8) {
        SVP_ERROR_STATUS(@"请输入正确的手机号");
        return;
    }
    [_textField[1] becomeFirstResponder];
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_textField[0].text type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
        SVP_SUCCESS_STATUS(@"发送成功，请注意查收短信");
        [weakSelf.codeBtn beginTime:60];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)action_submit{
    if (_textField[0].text.length < 8) {
        SVP_ERROR_STATUS(@"请输入正确的手机号");
        return;
    }
    if (_textField[1].text.length < 3) {
        SVP_ERROR_STATUS(@"请入正确的验证码");
        return;
    }
    
    SVP_SHOW;
//    WEAK_OBJ(weakSelf, self);
    NSString *sms = _textField[1].text;
    [NET_REQUEST_MANAGER requestTockenWithPhone:_textField[0].text smsCode:sms success:^(id object) {
        SVP_DISMISS;
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [ud objectForKey:@"mobile"];
    _textField[0].text = mobile;
    if(_textField[0].text.length == 0)
        [_textField[0] becomeFirstResponder];
    else
        [_textField[1] becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _textField[0])
        [_textField[1] becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end
