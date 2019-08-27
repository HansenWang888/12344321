//
//  WithdrawMainViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "WithdrawMainViewController.h"
#import "WithdrawView.h"
#import "AddBankCardViewController.h"
#import "UIImageView+WebCache.h"
#import "WDDetailViewController.h"

@interface WithdrawMainViewController ()<UITableViewDelegate,UITableViewDataSource,SelectBankDelegate>
@property(nonatomic,strong)WithdrawView *wdView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *historyArray;
@property(nonatomic,strong)NSMutableArray *bankArray;
@property(nonatomic,strong)NSMutableDictionary *selectBankDic;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isAddNewCard;
@end

@implementation WithdrawMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    self.isAddNewCard = NO;
    // Do any additional setup after loading the view.
    self.title = @"提现中心";
    
    self.historyArray = [[NSMutableArray alloc] init];
    
    WithdrawView *wdView = [[[NSBundle mainBundle] loadNibNamed:@"WithdrawView" owner:nil options:nil] lastObject];
    [wdView initView];
    [wdView.selectBankBtn addTarget:self action:@selector(selectBankAction) forControlEvents:UIControlEventTouchUpInside];
    [wdView.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.wdView = wdView;
    self.wdView.bankIconImageView.image = nil;
    self.wdView.bankLabel.text = @"添加银行卡";
    self.wdView.textField.placeholder = [NSString stringWithFormat:@"最低提现额度%zd元",[[AppModel shareInstance].commonInfo[@"cashdraw.money.min"] integerValue]];
    CGRect rr = wdView.frame;
    rr.size.width = SCREEN_WIDTH - 40;
    wdView.frame = rr;
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rr.size.width, wdView.frame.size.height)];
    hview.backgroundColor = [UIColor clearColor];
    [hview addSubview:wdView];
    
    self.tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 66;
    _tableView.tableHeaderView = hview;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    WEAK_OBJ(weakSelf, self);
    self.currentPage = 1;
    [self requestHistoryListWithPage:self.currentPage];
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf requestHistoryListWithPage:++weakSelf.currentPage];
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCard:) name:@"addNewCard" object:nil];
    
    
}

-(void)addNewCard:(NSNotification *)notification{
    self.isAddNewCard = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cId = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cId];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell addSubview:imageView];
        imageView.tag = 1;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.left.equalTo(@15);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.tag = 2;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell).offset(-15);
        }];

        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textColor = COLOR_X(80, 80, 80);
        descLabel.font = [UIFont systemFontOfSize2:15];
        descLabel.tag = 3;
        [cell addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.left.equalTo(imageView.mas_right).offset(15);
            make.centerY.equalTo(cell).offset(-12);
        }];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = COLOR_X(200, 200, 200);
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.tag = 4;
        [cell addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(descLabel.mas_left);
            make.centerY.equalTo(cell).offset(12);
            make.width.equalTo(@140);
        }];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = COLOR_X(200, 200, 200);
        statusLabel.font = [UIFont systemFontOfSize:13];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.tag = 5;
        [cell addSubview:statusLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(245, 245, 245);
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.right.equalTo(cell);
            make.bottom.equalTo(cell.mas_bottom).offset(-0.5);
        }];
    }
    UIImageView *iconView = [cell viewWithTag:1];
    UILabel *moneyLabel = [cell viewWithTag:2];
    UILabel *descLabel = [cell viewWithTag:3];
    UILabel *timeLabel = [cell viewWithTag:4];
    UILabel *statusLabel = [cell viewWithTag:5];
    NSDictionary *dic = self.historyArray[indexPath.row];
    iconView.image = [UIImage imageNamed:@"ccooin"];
    if(dic[@"money"])
        moneyLabel.text = [dic[@"money"] stringValue];
    descLabel.text = dic[@"title"];
    timeLabel.text = dic[@"createTime"];
    NSString *cause = dic[@"cause"];
    if([cause isKindOfClass:[NSNull class]])
        cause = nil;
    if(cause.length > 1)
        statusLabel.text = cause;
    else
        statusLabel.text = dic[@"strStatus"];
    if([statusLabel.text isEqualToString:@"提现已到账"]){
        statusLabel.textColor = COLOR_X(0, 200, 0);
    }else
        statusLabel.textColor = COLOR_X(200, 200, 200);
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-15);
        make.centerY.equalTo(cell).offset(12);
        make.left.equalTo(timeLabel.mas_right).offset(10);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    NSDictionary *dic = [self.historyArray objectAtIndex:indexPath.row];
    WDDetailViewController *vc = [[WDDetailViewController alloc] init];
    vc.infoDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.historyArray.count == 0)
        return 0;
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    if(self.historyArray.count == 0)
        return view;
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textColor = [UIColor blackColor];
    tLabel.text = @"提现记录";
    tLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.height.equalTo(@24);
        make.bottom.equalTo(view.mas_bottom).offset(-5);
    }];
    return view;
}

-(void)selectBankAction{
    [self.view endEditing:YES];
    
    if(self.bankArray == nil||self.bankArray.count==0){
        self.bankArray = [[NSMutableArray alloc] init];
        NSDictionary *dic = @{@"icon":@"",@"title2":@"使用新卡提现"};
        [self.bankArray addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
    }
    
    if(self.bankArray.count == 1){
        PUSH_C(self, AddBankCardViewController, YES);
        return;
    }
    if(self.selectBankDic){
        for (NSMutableDictionary *dic in self.bankArray) {
            if([dic[@"id"] integerValue] == [self.selectBankDic[@"id"] integerValue]){
                [dic setObject:@YES forKey:@"selected"];
            }else
                [dic setObject:@NO forKey:@"selected"];
        }
    }else{
        for (NSMutableDictionary *dic in self.bankArray)
            [dic setObject:@NO forKey:@"selected"];
    }
    SelectBankView *sheet = [[SelectBankView alloc] initWithArray:self.bankArray];
    sheet.delegate = self;
    [sheet showWithAnimationWithAni:YES];
}

-(void)selectBankDelegateWithView:(SelectBankView *)view index:(NSInteger)index{
    if(index == self.bankArray.count - 1){
        PUSH_C(self, AddBankCardViewController, YES);
        return;
    }
    for (NSInteger i = 0;i < self.bankArray.count - 1; i++) {
        NSMutableDictionary *dic = self.bankArray[i];
        [dic setObject:@NO forKey:@"selected"];
    }
    self.selectBankDic = self.bankArray[index];
    [self.selectBankDic setObject:@YES forKey:@"selected"];
    self.wdView.bankLabel.text = self.selectBankDic[@"title2"];
    [self.wdView.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.selectBankDic[@"icon"]]];
    
    NSString *s = [NSString stringWithFormat:@"%@_selectBankDic",[AppModel shareInstance].userInfo.userId];
    [[FunctionManager sharedInstance] archiveWithData:self.selectBankDic andFileName:s];
}

-(void)submit{
    [self.view endEditing:YES];
    NSString *money = self.wdView.textField.text;
    if(money.length == 0){
        SVP_ERROR_STATUS(@"请输入提现金额");
        return;
    }
    money = [NSString stringWithFormat:@"%.02f",[money doubleValue]];
    if([money isEqualToString:@"0.00"]){
        SVP_ERROR_STATUS(@"请输入正确的提现金额");
        return;
    }
    if(![[FunctionManager sharedInstance] checkIsNum:money]){
        SVP_ERROR_STATUS(@"请输入正确的金额");
        return;
    }
    if(self.selectBankDic == nil){
        SVP_ERROR_STATUS(@"请选择银行");
        return;
    }
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    NSString *bankId = self.selectBankDic[@"id"];
    [NET_REQUEST_MANAGER withDrawWithAmount:money userName:self.selectBankDic[@"user"] bankName:self.selectBankDic[@"title"] bankId:bankId address:self.selectBankDic[@"bankRegion"] uppayNO:self.selectBankDic[@"upayNo"] remark:@"" success:^(id object) {
        NSString *msg = [NSString stringWithFormat:@"%@",[object objectForKey:@"alterMsg"]];
        SVP_SUCCESS_STATUS(msg);
        [weakSelf requestBalance];
        

    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    } ];
    
//    [NET_REQUEST_MANAGER withDrawWithAmount:money bankId:bankId success:^(id object) {
//        NSString *msg = [NSString stringWithFormat:@"%@",[object objectForKey:@"alterMsg"]];
//        SVP_SUCCESS_STATUS(msg);
//        [weakSelf requestBalance];
//        [weakSelf requestHistoryListWithPage:1];
//    } fail:^(id object) {
//        [[FunctionManager sharedInstance] handleFailResponse:object];
//    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBankList];
}

-(void)requestBankList{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER getMyBankCardListWithSuccess:^(id object) {
        [weakSelf getBankListData:object[@"data"]];
        if (object[@"data"]!=nil) {
            NSArray* arr = object[@"data"];
            if (arr.count>0) {
                NSArray* arr = object[@"data"];
                [weakSelf getLastWithdrawInfo:arr.firstObject];
            }
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)getBankListData:(NSArray *)array{
    self.bankArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        NSString *title = dic[@"bankName"];
        NSString *uno = dic[@"upayNo"];
        NSString *upayNo = uno;
        if(uno.length > 4)
            upayNo = [uno substringFromIndex:uno.length - 4];
        [dd setObject:title forKey:@"title"];
        [dd setObject:[NSString stringWithFormat:@"%@(%@)",title,upayNo] forKey:@"title2"];
        if(dic[@"img"])
            [dd setObject:dic[@"img"] forKey:@"icon"];
        [dd setObject:dic[@"upaytId"] forKey:@"bankId"];
        [dd setObject:dic[@"id"] forKey:@"id"];
        [dd setObject:dic[@"upayNo"] forKey:@"upayNo"];
        [dd setObject:dic[@"user"] forKey:@"user"];
        [dd setObject:dic[@"bankRegion"] forKey:@"bankRegion"];
        [self.bankArray addObject:dd];
    }
    if(self.isAddNewCard){
        self.selectBankDic = [self.bankArray firstObject];
        self.wdView.bankLabel.text = self.selectBankDic[@"title2"];
        [self.wdView.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.selectBankDic[@"icon"]]];
    }
    NSDictionary *dic = @{@"icon":@"",@"title2":@"使用新卡提现"};
    [self.bankArray addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
}

-(void)requestHistoryListWithPage:(NSInteger)page{//page 1开始
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestDrawRecordListWithPage:page success:^(id object) {
        NSDictionary *data = object[@"data"];
//        weakSelf.currentPage = [data[@"current"] integerValue];
        if(weakSelf.currentPage == 1)
            [weakSelf.historyArray removeAllObjects];
        [weakSelf requestHistoryListBack:data[@"records"]];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestHistoryListBack:(NSArray *)array{
    if(self.historyArray == nil)
        self.historyArray = [NSMutableArray array];
    [self.historyArray addObjectsFromArray:array];
    [_tableView.mj_footer endRefreshing];
    
//    if(self.selectBankDic == nil && self.historyArray.count > 0){
//        NSDictionary *dic = self.historyArray[0];
//        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
//        NSString *title = dic[@"bankName"];
//        NSString *uno = dic[@"bankNo"];
//        NSString *upayNo = uno;
//        if(uno.length > 4)
//            upayNo = [uno substringFromIndex:uno.length - 4];
//        [dd setObject:title forKey:@"title"];
//        [dd setObject:[NSString stringWithFormat:@"%@(%@)",title,upayNo] forKey:@"title2"];
//        if(dic[@"img"])
//            [dd setObject:dic[@"img"] forKey:@"icon"];
//        [dd setObject:dic[@"upaytId"] forKey:@"bankId"];
//        self.selectBankDic = dd;
//
//        self.wdView.bankLabel.text = self.selectBankDic[@"title2"];
//        [self.wdView.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.selectBankDic[@"icon"]]];
//
//        NSString *s = [NSString stringWithFormat:@"%@_selectBankDic",[AppModel shareInstance].user.userId];
//        [[FunctionManager sharedInstance] archiveWithData:self.selectBankDic andFileName:s];
//    }
    [_tableView reloadData];
}

-(void)requestBalance{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        weakSelf.wdView.tipLabel.text = [NSString stringWithFormat:@"当前零钱余额%@元，",[AppModel shareInstance].userInfo.balance];
        [weakSelf requestHistoryListWithPage:1];
    } fail:^(id object) {
        
    }];
}

-(void)getLastWithdrawInfo:(NSDictionary*)dic{
    NSMutableDictionary *dd = [NSMutableDictionary dictionary];
    NSString *title = dic[@"bankName"];
    NSString *uno = dic[@"upayNo"];
    NSString *upayNo = uno;
    if(uno.length > 4)
        upayNo = [uno substringFromIndex:uno.length - 4];
    [dd setObject:title forKey:@"title"];
    [dd setObject:[NSString stringWithFormat:@"%@(%@)",title,upayNo] forKey:@"title2"];
    if(dic[@"img"])
        [dd setObject:dic[@"img"] forKey:@"icon"];
    [dd setObject:dic[@"upaytId"] forKey:@"bankId"];
    [dd setObject:dic[@"id"] forKey:@"id"];
    [dd setObject:dic[@"user"] forKey:@"user"];
    [dd setObject:dic[@"bankRegion"] forKey:@"bankRegion"];
    [dd setObject:dic[@"upayNo"] forKey:@"upayNo"];
    self.selectBankDic = dd;
    self.wdView.bankLabel.text = self.selectBankDic[@"title2"];
    [self.wdView.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.selectBankDic[@"icon"]]];

}
@end
