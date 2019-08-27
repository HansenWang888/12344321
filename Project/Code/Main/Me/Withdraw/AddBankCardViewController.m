//
//  AddBankCardViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddBankCardViewController.h"

@interface AddBankCardViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    UITextField *_textField[4];
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *bankList;
@property(nonatomic,strong)NSString *bankId;
@property(nonatomic,strong)NSString *bankCode;
@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加银行卡";
    self.view.backgroundColor = BaseColor;
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.tableFooterView = [self footView];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.bankList = [ud objectForKey:@"bankList"];
    
    [self requestBankList];
}

-(void)requestBankList{
    WEAK_OBJ(weakObj, self);
    [NET_REQUEST_MANAGER requestBankListWithSuccess:^(id object) {
        NSArray *arr = [object objectForKey:@"data"];
        weakObj.bankList = arr;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:arr forKey:@"bankList"];
        [ud synchronize];
    } fail:^(id object) {
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cId = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cId];
        NSInteger row = indexPath.row;
        if(row == 0)
            cell.textLabel.text = @"持卡人";
        else if(row == 1)
            cell.textLabel.text = @"卡号";
        else if(row == 2)
            cell.textLabel.text = @"开户行";
        else if(row == 3)
            cell.textLabel.text = @"开户地址";
        cell.textLabel.font = [UIFont systemFontOfSize2:16];
        cell.textLabel.textColor = Color_0;
        _textField[row] = [UITextField new];
        [cell.contentView addSubview:_textField[row]];
        _textField[row].font = [UIFont systemFontOfSize2:16];
        _textField[row].textAlignment = NSTextAlignmentRight;
        _textField[row].delegate = self;
        
        if(row == 0)
            _textField[row].placeholder = @"请输入持卡人";
        else if(row == 1)
            _textField[row].placeholder = @"请输入银行卡号";
        else if(row == 2)
            _textField[row].placeholder = @"请选择开户银行";
        else if(row == 3)
            _textField[row].placeholder = @"请输入开户地址";
        
        [_textField[row] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(120));
            make.right.equalTo(cell.contentView).offset(-15);
            make.top.bottom.equalTo(cell.contentView);
        }];
        if(row == 3){
            _textField[row].returnKeyType = UIReturnKeyDone;
        }else if(row == 2){
            _textField[row].userInteractionEnabled = NO;
        }else if(row == 1){
            _textField[row].keyboardType = UIKeyboardTypeNumberPad;
        }
        else
            _textField[row].returnKeyType = UIReturnKeyNext;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TBSeparaColor;
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(17);
            make.height.equalTo(@0.5);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSInteger row = indexPath.row;
    if(row == 2){
        [self selectBank];
    }
}

-(UIView *)footView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MBTNColor;
    [btn delayEnable];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.right.equalTo(view.mas_right).offset(-16);
        make.height.equalTo(@(44));
        make.top.equalTo(view.mas_top).offset(10);
    }];
    return view;
}

-(void)submitAction{
    NSString *userName = _textField[0].text;
    NSString *cardId = _textField[1].text;
    NSString *bankName = _textField[2].text;
    NSString *address = _textField[3].text;
    if(userName.length <2){
        SVP_ERROR_STATUS(@"请输入持卡人姓名");
        return;
    }
    if(cardId.length <8){
        SVP_ERROR_STATUS(@"请输入卡号");
        return;
    }
    if(bankName.length <2){
        SVP_ERROR_STATUS(@"请选择开户行");
        return;
    }
    if(address.length <2){
        SVP_ERROR_STATUS(@"请输入开户地址");
        return;
    }
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER addBankCardWithUserName:userName cardNO:cardId bankId:self.bankId bankCode:self.bankCode address:address success:^(id object) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCard" object:nil];
        SVP_SUCCESS_STATUS(@"添加成功");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
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

#pragma mark action
- (void)selectBank{
    [self.view endEditing:YES];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.bankList) {
        NSString *bankName = dic[@"title"];
        [arr addObject:bankName];
    }
    ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:arr isShowFliterTextFiled:YES];
    sheet.titleLabel.text = @"请选择银行";
    sheet.selectDataBlock = ^(NSArray* arr , NSInteger indexRow) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",arr[indexRow]];
        NSArray *flilterAarr = [self.bankList filteredArrayUsingPredicate:predicate];
        if (flilterAarr.count>0) {
            
        NSDictionary* dic = flilterAarr.firstObject;
//        for (NSDictionary* dic in self.bankList) {
            NSString *bankName = dic[@"title"];
//            if ([bankName isEqualToString:arr[indexRow]]) {
                NSInteger bankId = [dic[@"id"] integerValue];
            self.bankCode = [NSString stringWithFormat:@"%@",dic[@"code"]];
                self.bankId = INT_TO_STR(bankId);
                self->_textField[2].text = bankName;
//            }
//        }
        }
    };
    
    [sheet showWithAnimationWithAni:YES];
}

@end
