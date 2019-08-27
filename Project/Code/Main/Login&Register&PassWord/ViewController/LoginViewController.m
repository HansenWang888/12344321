//
//  LoginViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "UIView+AZGradient.h"
#import "WXManage.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "NetRequestManager.h"
#import "LoginBySMSViewController.h"
#import "AddIpViewController.h"
#import "SSKeychain.h"
#import "SAMKeychain.h"
#import "RSA.h"
#import "LoginRegisterModel.h"
#import "LoginRegisterHV.h"
#import "LoginRegisterSFV.h"
@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ActionSheetDelegate>{
    NSMutableDictionary *_wxRegister;
}
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *accountNum;
@property(nonatomic,strong)UIButton *codeBtn;
//@property(nonatomic,strong)UIButton *vertifyImgBtn;
@property (nonatomic,strong) FLAnimatedImageView *vertifyImgBtn;
@property (nonatomic ,copy) NSData *imageCaptchaData;
@property (nonatomic, strong) UIButton *timeBtn;
@end

@implementation LoginViewController

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
    _wxRegister = [[NSMutableDictionary alloc]init];
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    
    
    
    _dataList = [NSMutableArray arrayWithCapacity:4];
    
    [NET_REQUEST_MANAGER checkLoginWithDic:nil success:^(id object) {
        SVP_DISMISS;
        LoginRegisterModel* model = [LoginRegisterModel mj_objectWithKeyValues:object];
        [weakSelf.dataList addObjectsFromArray:[model getLoginTypes]];
//        [weakSelf.tableView reloadData];
        [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:[RSA randomlyGenerated16BitString] type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
            SVP_DISMISS;
            //weakSelf.imageCaptcha = [UIImage imageWithData: object];
            weakSelf.imageCaptchaData = object;
            [weakSelf.tableView reloadData];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
            [weakSelf.tableView reloadData];
        }];
        
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
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
}
#pragma mark ----- subView
- (void)initSubviews{
//    self.navigationItem.title = @"登录";
    
//    UIButton *regisBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    regisBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [regisBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [regisBtn addTarget:self action:@selector(action_register) forControlEvents:UIControlEventTouchUpInside];
//    [regisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:regisBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    [self.view az_setGradientBackgroundWithColors:@[HexColor(@"#fdbd11"),HexColor(@"#fe3465")] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
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
    
    LoginRegisterHV* hv = [[LoginRegisterHV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157) WithModel:@(GetSmsCodeFromVCLoginBySMS)];
    _tableView.tableHeaderView = hv;
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    _tableView.tableFooterView = fotView;
    
    UIButton *loginBtn = [UIButton new];
    [fotView addSubview:loginBtn];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = HEXCOLOR(0xffca13);
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forState:UIControlStateNormal];
//    [loginBtn az_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe3366),HEXCOLOR(0xff733d)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [loginBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(action_register) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn delayEnable];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fotView.mas_left).offset(0);
        make.right.equalTo(fotView.mas_right).offset(0);
        make.bottom.equalTo(fotView.mas_bottom).offset(0);
        make.height.equalTo(@(51));
    }];
    
    
    UILabel *versionLabel = [UILabel new];
    [self.view addSubview:versionLabel];
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    #ifdef DEBUG
        versionLabel.text = [NSString stringWithFormat:@"debug v%@",[[FunctionManager sharedInstance] getApplicationVersion]];
    #else
        versionLabel.text = [NSString stringWithFormat:@"v%@",[[FunctionManager sharedInstance] getApplicationVersion]];
    #endif
    versionLabel.textColor = COLOR_X(200, 200, 200);
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    }];
    
    [self addChangeEnvirmentButton];
}

#pragma mark - 添加切换环境按钮
- (void)addChangeEnvirmentButton {
    
#if DEBUG
    
    UIButton *btn = [UIButton buttonWithType:0];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.size.offset(50);
    }];
    [btn addTarget:self action:@selector(envirmentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tenantBtn = [UIButton buttonWithType:0];
    [self.view addSubview:tenantBtn];
    [tenantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.size.offset(50);
    }];
    [tenantBtn addTarget:self action:@selector(tenantBtnClick) forControlEvents:UIControlEventTouchUpInside];
#endif
    
}
- (void)envirmentBtnClick {
    
    [self accountSwitch];
    
}
- (void)tenantBtnClick {
    
    [NetworkConfig showChangeTenantVC];
}

-(void)feedback{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = @"联系客服";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)action_wxLogin {
    
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
        iv.image = [UIImage imageNamed:_dataList[indexPath.row][kImg]];
        NSInteger type = [_dataList[indexPath.row][kType] integerValue];
        cell.tag = type;
        if (type == EnumActionTag1) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = HEXCOLOR(0xfe3565);//[UIColor colorWithHexString:@""];
            [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.top.right.equalTo(bgView);
                
//                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.centerY.equalTo(bgView);
//                make.height.equalTo(@(36));
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag3) {
            if(self.imageCaptchaData!=nil){
                _vertifyImgBtn = [FLAnimatedImageView new];
                [cell.contentView addSubview:_vertifyImgBtn];
                _vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
                [_vertifyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(cell.contentView.mas_right).offset(-15);
                    make.top.right.equalTo(bgView);
//                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.centerY.equalTo(bgView);
//                    make.height.equalTo(@(36));
                    make.width.equalTo(@(86));
                }];
            }
//            _vertifyImgBtn = [UIButton new];
//            [cell.contentView addSubview:_vertifyImgBtn];
//            [_vertifyImgBtn setTitle:@"图形验证码" forState:UIControlStateNormal];
//            [_vertifyImgBtn setTitleColor:HEXCOLOR(0x7d7d7d) forState:UIControlStateNormal];
//            _vertifyImgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
////            _vertifyImgBtn.layer.cornerRadius = 6;
////            _vertifyImgBtn.layer.masksToBounds = YES;
////            _codeBtn.backgroundColor = COLOR_X(244, 112, 35);//[UIColor colorWithHexString:@""];
//
////            [_vertifyImgBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
//
//            [_vertifyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(cell.contentView.mas_right).offset(-15);
//                make.centerY.equalTo(cell.contentView.mas_centerY);
//                make.height.equalTo(@(30));
//                make.width.equalTo(@(86));
//            }];
        }
        UITextField* textField = [UITextField new];
        textField.tag = 9000;
        [cell.contentView addSubview:textField];
        textField.font = [UIFont systemFontOfSize2:15];
        textField.placeholder = _dataList[indexPath.row][kTit];
        textField.secureTextEntry = type == 2?YES:NO;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        if(type == EnumActionTag0){
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyNext;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *mobile = [ud objectForKey:@"mobile"];
            if(mobile == nil){
                NSArray *arr = [SAMKeychain accountsForService:@"com.fy.ser"];
                if(arr.count > 0){
                    NSDictionary *dic = arr[0];
                    mobile = dic[@"acct"];
                    
                }
            }
            if (![FunctionManager isEmpty:mobile]) {
                textField.text = mobile;
            }
        }
        else{
            textField.returnKeyType = UIReturnKeyDone;
        }
        
        CGFloat r =
        (type == EnumActionTag1||
         type == EnumActionTag3)
        ?116:15;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(68);
//            make.top.bottom.equalTo(cell.contentView);
           make.centerY.equalTo(bgView); make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LoginRegisterSFV* sfv = [[LoginRegisterSFV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 111) WithModel:@(GetSmsCodeFromVCLoginBySMS)];
    sfv.backgroundColor = [UIColor whiteColor];
    [sfv actionBlock:^(id data) {
        UIButton* uploadImgBtn = data;
        switch (uploadImgBtn.tag) {
            case EnumActionTag0:
                [self action_login];
                break;
            case EnumActionTag1:
                [self action_forgot];
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
    for (int i = 0; i<_dataList.count; i++) {
        //        EnumActionTag type = [_dataList[i][kType] integerValue];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *account = tf.text;
                if (account.length < 8 || account.length > 11) {
                    SVP_ERROR_STATUS(@"请输入正确的手机号");
                    return;
                }
                _accountNum = account;
            }
                break;
            
            default:
                break;
        }
    }
    
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_accountNum type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
        SVP_SUCCESS_STATUS(@"发送成功，请注意查收短信");
        [weakSelf.codeBtn beginTime:60];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}
- (void)action_login{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<_dataList.count; i++) {
//        EnumActionTag type = [_dataList[i][kType] integerValue];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *account = tf.text;
                if([account isEqualToString:@"88866610"]){
                    [self accountSwitch];
                    return;
                }
                
                if (account.length < 8 || account.length > 11) {
                    SVP_ERROR_STATUS(@"请输入正确的手机号");
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:account}];
            }
                break;
            case EnumActionTag1:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *vertifyCode = tf.text;
                if (vertifyCode.length == 0) {
                    SVP_ERROR_STATUS(@"请输入验证码");
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:vertifyCode}];
            }
                break;
            case EnumActionTag2:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *pw = tf.text;
                if (pw.length < 6) {
                    SVP_ERROR_STATUS(@"请输入6位以上密码");
                    return;
                }
                NSData *data = [pw dataUsingEncoding:NSUTF8StringEncoding];
                data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
                data = [GTMBase64 encodeData:data];
                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:s}];
            }
                break;
            case EnumActionTag3:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *vertifyImg = tf.text;
                if (vertifyImg.length == 0) {
                    SVP_ERROR_STATUS(@"请输入图形验证码");
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:vertifyImg}];
            }
                break;
            default:
                break;
        }
    }
    
    [self.view endEditing:YES];
    
    if ([AppModel shareInstance].commonInfo == nil||
        [AppModel shareInstance].appClientIdInCommonInfo==nil) {
        
        [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
            SVP_SHOW;
            [NET_REQUEST_MANAGER requestTokenWithDic:dic success:^(id object) {
                SVP_DISMISS;
                if([object isKindOfClass:[NSDictionary class]]){
                    if ([object objectForKey:@"code"] && [[object objectForKey:@"code"] integerValue] == 0) {
                    [self saveMobileAndPW];
                    }
                    [self getUserInfo];
                }
            }  fail:^(id object) {
                [[FunctionManager sharedInstance] handleFailResponse:object];
            }];
        } fail:^(id object) {
            SVP_ERROR_STATUS(@"网络请求初始化接口失败，稍后重试...");
        }];
        
    }else{
        
//        ApiRequest.loadData(target: ApiManger.postloginList(dic), cache: true, success: { (json) in
//            let decoder = JSONDecoder()
//            let model = try? decoder.decode(LoginRegisterModel.self, from: json )
//
////            self.assembleBanners(banners: (model?.data.returnData?.rankinglist)!, page: page)
////            success(self.sections)
//
//        }, failure: nil)
        SVP_SHOW;
        [NET_REQUEST_MANAGER requestTokenWithDic:dic success:^(id object) {
            SVP_DISMISS;
            if([object isKindOfClass:[NSDictionary class]]){
                NSDictionary* dic = object[@"data"];
                if (![FunctionManager isEmpty:dic[@"userId"]]) {
                    [self saveMobileAndPW];
                }
                [self getUserInfo];
            }
        }  fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    for (int i = 0; i<_dataList.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
        [tf resignFirstResponder];
    }
}
-(void)saveMobileAndPW{
    for (int i = 0; i<_dataList.count; i++) {
//        EnumActionTag tag = [_dataList[i][kType] integerValue];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                self.accountNum = tf.text;
                
                SetUserDefaultKeyWithObject(@"mobile", self.accountNum);
                UserDefaultSynchronize;
                
            }
                break;
            case EnumActionTag2:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *pw = tf.text;
                [SSKeychain setPassword:pw forService:@"password" account:self.accountNum];
                
            }
                break;
            
            default:
                break;
        }
    }
    
}

/**
 获取用户信息
 */
- (void)getUserInfo {
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
//        [[AppModel shareInstance] reSetRootAnimation:YES];
        [[AppModel shareInstance] reSetTabBarAsRootAnimation];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    [NET_REQUEST_MANAGER requestAppConfigWithSuccess:nil fail:nil];
}


- (void)accountSwitch {
    [self.view endEditing:YES];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择服务器地址" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *arr = [[AppModel shareInstance] ipArray];
    
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        NSString *bankName = dic[@"url"];
        [newArr addObject:bankName];
    }
    [newArr addObject:@"添加ip"];
    ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:newArr];
    sheet.titleLabel.text = @"请选择地址";
    sheet.delegate = self;
    [sheet showWithAnimationWithAni:YES];
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    NSArray *arr = [[AppModel shareInstance] ipArray];
    if(index > arr.count)
    return;
    if(index == arr.count){
        AddIpViewController *vc = [[AddIpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:INT_TO_STR(index) forKey:@"serverIndex"];
        [ud synchronize];
        SVP_SUCCESS_STATUS(@"切换成功，重启生效");
        [[FunctionManager sharedInstance] performSelector:@selector(exitApp) withObject:nil afterDelay:1.0];
    }
}


-(void)action_loginBySMS{
    LoginBySMSViewController *vc = [[LoginBySMSViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)action_forgot{
    CDPush(self.navigationController, CDVC(@"ForgotViewController"), false);
}

- (void)action_register{
    CDPush(self.navigationController, CDVC(@"RegisterViewController"), false);
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if(textField == _textField[0])
//        [_textField[2] becomeFirstResponder];
//    else
//        [textField resignFirstResponder];
//    return YES;
//}

@end
