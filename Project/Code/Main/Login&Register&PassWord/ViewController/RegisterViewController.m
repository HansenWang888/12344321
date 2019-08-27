//
//  RegisterViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"
#import "CDAlertViewController.h"
#import "LoginRegisterModel.h"
#import "LoginRegisterHV.h"
#import "LoginRegisterSFV.h"
#import "RSA.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,ActionSheetDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *cells;
@property(nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign)NSInteger sexType;
@property (nonatomic, copy) NSString *accountNum;
@property (nonatomic, copy) NSString *pw;
@property(nonatomic,strong)UIButton *codeBtn;
//@property(nonatomic,strong)UIButton *vertifyImgBtn;
@property (nonatomic,strong) FLAnimatedImageView *vertifyImgBtn;
@property (nonatomic ,copy) NSData *imageCaptchaData;

@property(nonatomic,strong)UIButton *genderBtn;
@property(nonatomic,strong)UIButton *dateBtn;
@property (nonatomic, strong) UIButton *timeBtn;
@end

@implementation RegisterViewController

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
    _sexType = 0;
    _dateString = @"";
    _cells = [NSMutableArray array];
    _dataList = [NSMutableArray arrayWithCapacity:13];
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER checkRegisterWithDic:nil success:^(id object) {
        SVP_DISMISS;
        LoginRegisterModel* model = [LoginRegisterModel mj_objectWithKeyValues:object];
        [weakSelf.dataList addObjectsFromArray:[model getRegisterTypes]];
//        [weakSelf.tableView reloadData];
        
        [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:[RSA randomlyGenerated16BitString] type:GetSmsCodeFromVCRegister success:^(id object) {
            SVP_DISMISS;
//            weakSelf.imageCaptcha = [UIImage imageWithData: object];
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
    
//    self.navigationItem.title = @"注册";
    
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
    
    LoginRegisterHV* hv = [[LoginRegisterHV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157) WithModel:@(GetSmsCodeFromVCRegister)];
    _tableView.tableHeaderView = hv;
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    _tableView.tableFooterView = fotView;
    
    
    UIButton *btn = [UIButton new];
    [fotView addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_backToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = HEXCOLOR(0xffca13);
    [btn delayEnable];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fotView.mas_left).offset(0);
        make.right.equalTo(fotView.mas_right).offset(0);
        make.bottom.equalTo(fotView.mas_bottom).offset(0);
        make.height.equalTo(@(51));
    }];
}
- (void)action_backToLoginVC{
    [self.navigationController popViewControllerAnimated:false];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = _dataList[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        NSArray *list = _dataList[indexPath.section];
        NSInteger type = [list[indexPath.row][kType] integerValue];
        
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
        //        cell.imageView.image = [UIImage imageNamed:list[indexPath.row][kImg]];
        iv.image = [UIImage imageNamed:list[indexPath.row][kImg]];
        cell.tag = type;
        [_cells addObject:
          @{
            @{list[indexPath.row][kSubTit]:list[indexPath.row][kIsOn]}:cell
            
            }];
        if (type == EnumActionTag1) {
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
                make.top.right.centerY.equalTo(bgView);
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag9) {
            if(self.imageCaptchaData!=nil){
                _vertifyImgBtn = [FLAnimatedImageView new];
                [cell.contentView addSubview:_vertifyImgBtn];
                _vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
                [_vertifyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.centerY.equalTo(bgView);
                    make.width.equalTo(@(86));
                }];
            }
        }
        if (type == EnumActionTag11) {
            _genderBtn = [UIButton new];
            _genderBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:_genderBtn];
            [_genderBtn setTitle:(_sexType == 0)?@"男":@"女" forState:UIControlStateNormal];
            [_genderBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            _genderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            
            //            [_vertifyImgBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.centerY.equalTo(bgView);
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag12) {
            
            _dateBtn = [UIButton new];
            _dateBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:_dateBtn];
            [_dateBtn setTitle:[_dateString isEqualToString:  @""]? @"选择日期 >" : _dateString forState:UIControlStateNormal];
            [_dateBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            _dateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            
            //            [_vertifyImgBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.centerY.equalTo(bgView);
                make.width.equalTo(@(90));
            }];
        }
        UITextField* textField = [UITextField new];
        textField.tag = 9000;
        [cell.contentView addSubview:textField];
        textField.placeholder = list[indexPath.row][kTit];
        textField.secureTextEntry =
        (type == EnumActionTag2
         ||
         type == EnumActionTag3)
        ?YES:NO;
        textField.userInteractionEnabled =
        (type == EnumActionTag11
         ||
         type == EnumActionTag12)
        ?NO:YES;
        textField.font = [UIFont systemFontOfSize2:15];
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyDone;
        if(type == EnumActionTag0){
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
        CGFloat r =
        (type == EnumActionTag1
         ||
         type == EnumActionTag11
         ||
         type == EnumActionTag12)
        ?116:15;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(68);
            //            make.top.bottom.equalTo(cell.contentView);
            make.centerY.equalTo(bgView);
            make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==  _dataList.count -1) {
        LoginRegisterSFV* sfv = [[LoginRegisterSFV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 111) WithModel:@(GetSmsCodeFromVCRegister)];
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
    UIView* sfv = [UIView new];
    sfv.backgroundColor = [UIColor whiteColor];
    return sfv;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==  _dataList.count -1) {
        return 111;
    }
    return 0.1f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = _dataList[indexPath.section];
    NSInteger type = [list[indexPath.row][kType] integerValue];
    if (type == EnumActionTag11) {
        
        ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[@"男",@"女"]];
        sheet.titleLabel.text = @"请选择性别";
//        sheet.tag = type;
        sheet.delegate = self;
        [sheet showWithAnimationWithAni:YES];
        
    }
    if (type == EnumActionTag12) {
        __weak typeof(self) weakSelf = self;
        [CDAlertViewController showDatePikerDate:^(NSString *date) {
            weakSelf.dateString = date;
            [weakSelf.dateBtn setTitle:date forState:UIControlStateNormal];
//            [weakSelf updateType:type date:date];
        }];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    for (int i = 0; i<_cells.count; i++) {
        NSDictionary* cellDic = _cells[i];
        UITableViewCell* cell = cellDic.allValues.firstObject;
        
        //        NSDictionary* paramDic = cellDic.allKeys.firstObject;
        //        NSString* param = paramDic.allKeys.firstObject;
        //        NSString* isOptional = paramDic.allValues.firstObject;
        UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
        [tf resignFirstResponder];
    }
}

#pragma mark ActionSheetDelegate
-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
//    if(actionSheet.tag == EnumActionTag11){
        if(index == 2)
            return;
        _sexType = index;
        [_genderBtn setTitle:(_sexType == 0)?@"男":@"女" forState:UIControlStateNormal];
//    }
}

#pragma mark action
- (void)action_submit{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<_cells.count; i++) {
//        NSArray *list = _dataList[i];
//
//        for (int j = 0; j<list.count; j++) {
//            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//            UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        NSDictionary* cellDic = _cells[i];
        UITableViewCell* cell = cellDic.allValues.firstObject;
        
        NSDictionary* paramDic = cellDic.allKeys.firstObject;
        NSString* param = paramDic.allKeys.firstObject;
        NSString* isOptional = paramDic.allValues.firstObject;
            switch (cell.tag) {
                case EnumActionTag0:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *account = tf.text;
                    
                    if (account.length < 8 ||
                        account.length > 11) {
                        SVP_ERROR_STATUS(@"请输入正确的手机号");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:account}];
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
                    if (vertifyCode.length < 3) {
                        SVP_ERROR_STATUS(@"请入正确的验证码");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:vertifyCode}];
                }
                    break;
                case EnumActionTag2:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *pw = tf.text;
                    if (pw.length > 16 ||
                        pw.length < 6) {
                        SVP_ERROR_STATUS(@"请输入6-16位密码");
                        return;
                    }
                    _pw = pw;
//                    NSData *data = [pw dataUsingEncoding:NSUTF8StringEncoding];
//                    data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
//                    data = [GTMBase64 encodeData:data];
//                    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [dic addEntriesFromDictionary:@{param:pw}];
                }
                    break;
                case EnumActionTag3:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *cpw = tf.text;
                    if (cpw.length > 16 ||
                        cpw.length < 6) {
                        SVP_ERROR_STATUS(@"请输入6-16位密码");
                        return;
                    }
                    if (![cpw isEqualToString:_pw]) {
                        SVP_ERROR_STATUS(@"密码不一致");
                        return;
                    }
//                    [dic addEntriesFromDictionary:@{list[j][kSubTit]:cpw}];
                }
                    break;
                    
                case EnumActionTag4:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入邀请码");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                    
                case EnumActionTag5:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入QQ号");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag6:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入微信号");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag7:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入邮箱");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag8:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入真实姓名");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag9:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入图形验证码");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag10:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请输入用户名");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag11:
                {
                    
                    [dic addEntriesFromDictionary:@{param:@(_sexType)}];
                }
                    break;
                case EnumActionTag12:
                {
                    if (_dateString.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(@"请选择出生日期");
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:_dateString}];
                }
                    break;
                default:
                    break;
            }
        }
    
    
    
    [self.view endEditing:YES];
    
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER registerWithDic:dic success:^(id object) {
        SVP_SUCCESS_STATUS(@"注册成功");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)action_getCode{
    
    for (int i = 0; i<_cells.count; i++) {
        //        NSArray *list = _dataList[i];
        //
        //        for (int j = 0; j<list.count; j++) {
        //            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
        //            UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        NSDictionary* cellDic = _cells[i];
        UITableViewCell* cell = cellDic.allValues.firstObject;
        
//        NSDictionary* paramDic = cellDic.allKeys.firstObject;
//        NSString* param = paramDic.allKeys.firstObject;
//        NSString* isOptional = paramDic.allValues.firstObject;
        
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
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_accountNum type:GetSmsCodeFromVCRegister success:^(id object) {
        SVP_SUCCESS_STATUS(@"发送成功，请注意查收短信");
        [weakSelf.codeBtn beginTime:60];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)feedback{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = @"联系客服";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if(textField == _textField[0])
//        [_textField[1] becomeFirstResponder];
//    else if(textField == _textField[1])
//        [_textField[2] becomeFirstResponder];
//    else if(textField == _textField[2])
//        [_textField[3] becomeFirstResponder];
//    else if(textField == _textField[3])
//        [_textField[4] becomeFirstResponder];
//    else
//        [textField resignFirstResponder];
//    return YES;
//}

@end
