//
//  ForgotViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "ForgotViewController.h"
#import "LoginRegisterHV.h"
#import "LoginRegisterSFV.h"
#import "WebViewController.h"
@interface ForgotViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *_tableView;
    NSArray *_dataList;
    UITextField *_textField[5];
    UILabel *_sexLabel;
}
@property (nonatomic, strong) UIButton *timeBtn;
@property(nonatomic,strong)UIButton *codeBtn;
@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
#pragma mark ----- Data
- (void)initData{
    _dataList = @[@{@"title":@"请输入手机号",@"img":@"icon_phone"},@{@"title":@"请输入验证码",@"img":@"icon_security"},@{@"title":@"请输入密码",@"img":@"icon_lock"},@{@"title":@"请确认密码",@"img":@"icon_lock"}];
}


#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 35, 0, 35));
    }];
}
- (void)layoutServiceBtn{
    self.timeBtn = [UIButton new];
    [self.view addSubview:self.timeBtn];
    self.timeBtn.tag = EnumActionTag0;
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    //    self.timeBtn.backgroundColor = ApHexColor(@"#000000",0.6);
    //    [self.timeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.timeBtn setImage:[UIImage imageNamed:@"serverIcon"] forState:UIControlStateNormal];
    self.timeBtn.adjustsImageWhenHighlighted = NO;
    self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    self.timeBtn.layer.cornerRadius = 18;
    //    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    //    btn.layer.borderWidth = 1.0f;
    [self.timeBtn addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(self.view.mas_top).offset([FunctionManager isIphoneX]? [FunctionManager statusBarHeight]+20:20);
        //                make.height.equalTo(@23);
                        make.width.equalTo(@75);
    }];
    
    UIButton* goBackBtn = [UIButton new];
    [self.view addSubview:goBackBtn];
    goBackBtn.tag = EnumActionTag0;
    
    [goBackBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    goBackBtn.adjustsImageWhenHighlighted = NO;
    goBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.width.mas_equalTo(75);
       make.centerY.equalTo(self.timeBtn);
    }];
}

-(void)feedback{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = @"联系客服";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:false];
}
#pragma mark ----- subView
- (void)initSubviews{
    
//    self.navigationItem.title = @"重设密码";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    [self.view az_setGradientBackgroundWithColors:@[HexColor(@"#fdbd11"),HexColor(@"#fe3465")] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = BaseColor;
//    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 59.f;
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.separatorColor = TBSeparaColor;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = false;
    
    [self layoutServiceBtn];
    
    LoginRegisterHV* hv = [[LoginRegisterHV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157) WithModel:@(GetSmsCodeFromVCResetPW)];
    _tableView.tableHeaderView = hv;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView* bgView = [UIView new];
        bgView.backgroundColor = HEXCOLOR(0xe7e7e7);
        [cell.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(8, 21, 3, 21));
        }];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        bgView.userInteractionEnabled = true;
        
        UIImageView* iv = [UIImageView new];
        [bgView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(bgView);
        }];
        iv.userInteractionEnabled = false;
        //        cell.imageView.image = [UIImage imageNamed:_dataList[indexPath.row][kImg]];
        iv.image = [UIImage imageNamed:_dataList[indexPath.row][@"img"]];
        if (indexPath.row == 1) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = HEXCOLOR(0xfe3565);
            [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(bgView);
                make.centerY.equalTo(bgView);
                make.width.equalTo(@(86));
            }];
        }
        
        _textField[indexPath.row] = [UITextField new];
        [cell.contentView addSubview:_textField[indexPath.row]];
        _textField[indexPath.row].placeholder = _dataList[indexPath.row][@"title"];
        _textField[indexPath.row].font = [UIFont systemFontOfSize2:15];
        _textField[indexPath.row].clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField[indexPath.row].delegate = self;
        CGFloat r = (indexPath.row == 1)?116:15;
        [_textField[indexPath.row] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(68);
             make.centerY.equalTo(bgView);
            make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
        if(indexPath.row == 0)
            _textField[indexPath.row].keyboardType = UIKeyboardTypePhonePad;
        if(indexPath.row == 2 || indexPath.row == 3){
            _textField[indexPath.row].secureTextEntry = YES;
        }
        if(indexPath.row != 3)
            _textField[indexPath.row].returnKeyType = UIReturnKeyNext;
        else
            _textField[indexPath.row].returnKeyType = UIReturnKeyDone;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LoginRegisterSFV* sfv = [[LoginRegisterSFV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 111) WithModel:@(GetSmsCodeFromVCResetPW)];
    sfv.backgroundColor = [UIColor whiteColor];
    [sfv actionBlock:^(id data) {
        UIButton* uploadImgBtn = data;
        switch (uploadImgBtn.tag) {
            case EnumActionTag0:
                [self action_submit];
                break;
            default:
                break;
        }
        
    }];
    return sfv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 111;
}
#pragma mark action
- (void)action_getCode{
    NSString *phone = _textField[0].text;
    if (phone.length < 8 || ![[FunctionManager sharedInstance] checkIsNum:phone]) {
        SVP_ERROR_STATUS(@"请输入正确的手机号");
        return;
    }
    [_textField[1] becomeFirstResponder];
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_textField[0].text type:GetSmsCodeFromVCResetPW success:^(id object) {
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
        SVP_ERROR_STATUS(@"请输入正确的验证码");
        return;
    }
    if (_textField[2].text.length > 16 || _textField[2].text.length < 6) {
        SVP_ERROR_STATUS(@"请输入6-16位密码");
        return;
    }
    if (_textField[3].text.length > 16 || _textField[3].text.length < 6) {
        SVP_ERROR_STATUS(@"请输入6-16位确认密码");
        return;
    }
    if (![_textField[2].text isEqualToString:_textField[3].text]) {
        SVP_ERROR_STATUS(@"密码不一致");
        return;
    }
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER findPasswordWithPhone:_textField[0].text smsCode:_textField[1].text password:_textField[2].text success:^(id object) {
        SVP_SUCCESS_STATUS(@"重设成功，请重新登录");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _textField[0])
        [_textField[1] becomeFirstResponder];
    else if(textField == _textField[1])
        [_textField[2] becomeFirstResponder];
    else if(textField == _textField[2])
        [_textField[3] becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end
