//
//  EnvelopeViewController.m
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "SendRedEnvelopeController.h"
#import "EnvelopeMessage.h"
#import "EnvelopeNet.h"
#import "MessageItem.h"
#import "NetRequestManager.h"
#import "BANetManager_OC.h"
#import "NSString+RegexCategory.h"
#import "NotificationMessageModel.h"
#import "SendRPTextCell.h"

@interface SendRedEnvelopeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField *_textField[3];
    UILabel *_titLabel[3];
    UILabel *_unitLabel[3];
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *rowList;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,strong) UIButton *submit;
@property (nonatomic ,strong) MessageItem *message;
@property (nonatomic ,strong) UILabel *promptLabel;
@property (nonatomic ,assign) NSInteger textFieldObjectIndex;

@property (nonatomic,strong) NSString *moneyStr;
@property (nonatomic,strong) NSString *countStr;
@property (nonatomic,strong) NSString *mineStr;

@end

@implementation SendRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
    [self initNotif];
    
    [self.tableView registerClass:[SendRPTextCell class] forCellReuseIdentifier:@"SendRPTextCell"];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField[0] becomeFirstResponder];
}
#pragma mark ----- Data
- (void)initData {
    NSLog(@"%@",self.CDParam);
    _message = (MessageItem *)self.CDParam;
    
    if (self.isFu) {
        _rowList = @[@[@{@"title":@"总金额",@"right":@"元",@"placeholder":[NSString stringWithFormat:@"%@-%@",self.message.simpMinMoney,self.message.simpMaxMoney]},@{@"title":@"红包个数",@"right":@"个",@"placeholder":@"填写红包个数"}]];
        return;
    }
    
    if (_message.type == 1) {
        _rowList = @[@[@{@"title":@"总金额",@"right":@"元",@"placeholder":[NSString stringWithFormat:@"%@-%@",self.message.minMoney,self.message.maxMoney]},@{@"title":@"红包个数",@"right":@"个",@"placeholder":@"填写红包个数"}],@[@{@"title":@"雷数",@"right":@"",@"placeholder":@"范围0-9"}]];
    } else if (_message.type == 2) {
        _rowList = @[@[@{@"title":@"总金额",@"right":@"元",@"placeholder":[NSString stringWithFormat:@"%@-%@",self.message.minMoney,self.message.maxMoney]},@{@"title":@"红包个数",@"right":@"个",@"placeholder":@"填写红包个数"}]];
    }
}



#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initNotif{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}



#pragma mark ----- subView
- (void)initSubviews{
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"发红包";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [btn addTarget:self action:@selector(action_cancle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *l = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = l;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.separatorColor = TBSeparaColor;
    _tableView.rowHeight = 60;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _tableView.tableHeaderView = headView;
    
    _moneyLabel = [UILabel new];
    [headView addSubview:_moneyLabel];
    _moneyLabel.font = [UIFont systemFontOfSize:40];
    _moneyLabel.textColor = Color_0;
    _moneyLabel.text = @"￥0";
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.equalTo(headView.mas_top).offset(30);
    }];
    
    
    _promptLabel = [UILabel new];
    [headView addSubview:_promptLabel];
    _promptLabel.font = [UIFont systemFontOfSize:14];
    _promptLabel.textColor = [UIColor redColor];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.equalTo(self.moneyLabel.mas_bottom);
    }];
    
    
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _tableView.tableFooterView = fotView;
    
    _submit = [UIButton new];
    [fotView addSubview:_submit];
    _submit.layer.cornerRadius = 8;
    _submit.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    _submit.layer.masksToBounds = YES;
    _submit.backgroundColor = MBTNColor;
    _submit.enabled = NO;
    _submit.alpha = 0.7;
    
    [_submit setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submit addTarget:self action:@selector(action_sendRedpacked) forControlEvents:UIControlEventTouchUpInside];
    [_submit delayEnable];
    [_submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@(44));
        make.top.equalTo(fotView.mas_top).offset(7);
    }];
    //    _submit.alpha = 0.5;
    
    UILabel *bot = [UILabel new];
    [fotView addSubview:bot];
    bot.font = [UIFont systemFontOfSize2:12];
    bot.textColor = COLOR_X(140, 140, 140);
    
    if (_message.type == 2) {
        bot.text = kMessCowRefundMessage;
    } else {
        bot.text = [NSString stringWithFormat:@"未领取的红包，将于%0.2f分钟后发起退款", [self.message.rpOverdueTime floatValue]/60];
    }
    
    
    [bot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self -> _submit);
        make.top.equalTo(self ->_submit.mas_bottom).offset(9);
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize2:13];
    label.textColor = COLOR_X(140, 140, 140);
    
    if (self.isFu) {
        label.text = [NSString stringWithFormat:@"红包发包范围: %@-%@元",self.message.simpMinMoney,self.message.simpMaxMoney];
    } else if (!self.isFu && _message.type == 1) {
        label.text = (section == 0)? [NSString stringWithFormat:@"红包发包范围: %@-%@元",self.message.minMoney,self.message.maxMoney]:@"雷数范围0-9";
    } else if (!self.isFu && _message.type == 2) {
        label.text = (section == 0)? [NSString stringWithFormat:@"红包发包范围: %@-%@元",self.message.minMoney,self.message.maxMoney]:[NSString stringWithFormat:@"红包个数: %@-%@元",self.message.minCount,self.message.maxCount];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(20);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = _rowList[section];
    return list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SendRPTextCell *cell = [SendRPTextCell cellWithTableView:tableView reusableId:@"SendRPTextCell"];
    //    cell.backgroundColor = [UIColor blueColor];
    cell.object = self;
    cell.titleLabel.text = _rowList[indexPath.section][indexPath.row][@"title"];
    cell.titleLabel.textColor = Color_0;
    cell.deTextField.placeholder = _rowList[indexPath.section][indexPath.row][@"placeholder"];
    cell.unitLabel.text = _rowList[indexPath.section][indexPath.row][@"right"];;
    cell.unitLabel.textColor = Color_0;
    cell.deTextField.userInteractionEnabled = YES;
    cell.deTextField.tag = indexPath.section * 1000 + indexPath.row;
    cell.isUpdateTextField = NO;
    
   if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.isFu) {
            cell.deTextField.placeholder = [NSString stringWithFormat:@"%@-%@",self.message.simpMinCount,self.message.simpMaxCount];
        } else {
            if(_message.type == 1) {
                cell.titleLabel.textColor = COLOR_X(140, 140, 140);
                cell.deTextField.text = [NSString stringWithFormat:@"%@",self.message.maxCount];
                cell.deTextField.userInteractionEnabled = NO;
                cell.deTextField.textColor = COLOR_X(140, 140, 140);
                cell.isUpdateTextField = YES;
                cell.unitLabel.textColor = COLOR_X(140, 140, 140);
            } else if(_message.type == 2) {
                if (self.message.maxCount.integerValue == self.message.minCount.integerValue) {
                    cell.titleLabel.textColor = COLOR_X(140, 140, 140);
                    cell.deTextField.text = [NSString stringWithFormat:@"%@",self.message.maxCount];
                    cell.deTextField.userInteractionEnabled = NO;
                    cell.deTextField.textColor = COLOR_X(140, 140, 140);
                    cell.isUpdateTextField = YES;
                    cell.unitLabel.textColor = COLOR_X(140, 140, 140);
                } else {
                    cell.deTextField.placeholder = [NSString stringWithFormat:@"%@-%@",self.message.minCount,self.message.maxCount];
                }
            }
        }
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

#pragma mark action
- (void)action_cancle {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToBottom" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 发红包
- (void)action_sendRedpacked {
    
    NSString *money = self.moneyStr;
    NSString *packetNum = self.countStr;
    NSString *bombNum = [self.mineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * regex        = @"(^[0-9]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (money.length == 0) {
        SVP_ERROR_STATUS(@"请输入总金额");
        return;
    }
    if (packetNum.length == 0) {
        SVP_ERROR_STATUS(@"请输入红包个数");
        return;
    }
    
    if(![pred evaluateWithObject:packetNum]){
        SVP_ERROR_STATUS(@"红包个数请输入整数");
        return;
    }
    
    if(![pred evaluateWithObject:money]){
        SVP_ERROR_STATUS(@"金额请输入整数");
        return;
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (!self.isFu && _message.type == 1) {
        if (bombNum.length == 0) {
            SVP_ERROR_STATUS(@"请输入雷数");
            return;
        }
        if(![pred evaluateWithObject:bombNum]){
            SVP_ERROR_STATUS(@"雷数请输入整数");
            return;
        }
        [dic setObject:bombNum forKey:@"bombNum"];
    }
    
    _submit.enabled = NO;
    [self redpackedRequest:money packetNum:packetNum extDict:dic];
    
}

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum extDict:(NSDictionary *)extDict {

    NSDictionary *parameters = @{
                                 @"ext":extDict,
                                 @"groupId":self.message.groupId,
                                 @"userId":[AppModel shareInstance].userInfo.userId,
                                 @"type":self.isFu ? @(0) : @(_message.type),
                                 @"money":money,
                                 @"count":@(packetNum.integerValue)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"redpacket/redpacket/send"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"=================== 红包发送成功 ===================");
        
        SVP_DISMISS;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            [strongSelf action_cancle];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
        strongSelf.submit.enabled = YES;
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submit.enabled = YES;
        SVP_DISMISS;
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == (1000+0)) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 1) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
    }
    return YES;
}

#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)text{
    
    UITextField *textFieldObj = (UITextField *)text.object;
    self.textFieldObjectIndex = textFieldObj.tag;
    if (textFieldObj.tag == 0) {
        self.textFieldObjectIndex = 0;
    } else if (textFieldObj.tag == 1) {
        self.textFieldObjectIndex = 1;
    } else if (textFieldObj.tag == 1000) {
        self.textFieldObjectIndex = 2;
    }
    

    if(!self.isFu && _message.type == 1) {
        self.countStr = self.message.maxCount;
    }
    if(!self.isFu && _message.type == 2) {
        if (self.message.maxCount.integerValue == self.message.minCount.integerValue) {
            self.countStr = self.message.maxCount;
        }
    }
    
    if (textFieldObj.tag == 0) {
        self.moneyStr = textFieldObj.text;
    } else if (textFieldObj.tag == 1) {
        self.countStr = textFieldObj.text;
    } if (textFieldObj.tag == 1000+0) {
        self.mineStr = textFieldObj.text;
    }
    
    NSInteger moneyone = [self.moneyStr integerValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%ld",moneyone];
    BOOL money  = [self moneyAction:moneyone];
    
    NSInteger countTemp = [self.countStr integerValue];
    BOOL count  = [self countAction:countTemp];
    
    BOOL lel = self.mineStr.length <= 0 ? NO : [self leiNum:[self.mineStr integerValue]];


    if ((self.isFu && money && count) || (!self.isFu && _message.type == 1 && money && lel) || (_message.type == 2 && money && count)) {
        self.submit.enabled = YES;
        self.submit.alpha = 1.0;
        self.promptLabel.text = @"";
    }  else {
        self.submit.enabled = NO;
        self.submit.alpha = 0.7;
    }
    
}

- (BOOL)moneyAction:(CGFloat)money {
    
    NSInteger max = 0;
    NSInteger min = 0;
    if (self.isFu) {
        max = [self.message.simpMaxMoney integerValue];
        min = [self.message.simpMinMoney integerValue];
    } else {
        max = [self.message.maxMoney integerValue];
        min = [self.message.minMoney integerValue];
    }
    
    if ((money > max) | (money < min)) {
        if (self.textFieldObjectIndex == 0) {
            if (self.isFu) {
                self.promptLabel.text = [NSString stringWithFormat:@"红包发包范围:%@-%@", self.message.simpMinMoney,self.message.simpMaxMoney];
            } else {
                self.promptLabel.text = [NSString stringWithFormat:@"红包发包范围:%@-%@", self.message.minMoney,self.message.maxMoney];
            }
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 0) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}

- (BOOL)countAction:(CGFloat)count {
    
    NSInteger max = 0;
    NSInteger min = 0;
    if (self.isFu) {
        max = [self.message.simpMaxCount integerValue];
        min = [self.message.simpMinCount integerValue];
    } else {
        max = [self.message.maxCount integerValue];
        min = [self.message.minCount integerValue];
    }
    
    if ((count > max) | (count < min)) {
        
        if (self.textFieldObjectIndex == 1) {
            if (self.isFu) {
                self.promptLabel.text = [NSString stringWithFormat:@"红包个数范围:%@-%@", self.message.simpMinCount,self.message.simpMaxCount];
            } else {
                self.promptLabel.text = [NSString stringWithFormat:@"红包个数范围:%@-%@", self.message.minCount,self.message.maxCount];
            }
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 1) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}

- (BOOL)leiNum:(CGFloat)number {
    CGFloat max = 9;
    CGFloat min = 0;
    if ((number > max) | (number < min)) {
        if (self.textFieldObjectIndex == 1000) {
            self.promptLabel.text = @"雷数范围:0-9";
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 2) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
