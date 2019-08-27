//
//  BillViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "BillViewController.h"
#import "BillHeadView.h"
#import "BillNet.h"
#import "CDAlertViewController.h"
#import "BillTableViewCell.h"
#import "EnvelopeNet.h"
#import "RedEnvelopeDetListController.h"

@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *billTypeList;
@property(nonatomic,strong)BillNet *model;
@property(nonatomic,strong)BillHeadView *headView;
// 发包ID
@property(nonatomic, copy) NSString *sendPId;

@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.billTypeList = [[NSMutableArray alloc] init];
    NSDictionary *dic = @{@"id":@"999",@"title":@"全部"};
    [self.billTypeList addObject:dic];
    [self initData];
    [self initSubviews];
    [self initLayout];
    [self getBillType];
    SVP_SHOW;
    [self getData];
}

#pragma mark ----- Data
- (void)initData{
    _model = [[BillNet alloc]init];
    _model.categoryStr = self.infoDic[@"url"];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    __weak __typeof(self)weakSelf = self;

    __weak BillNet *weakModel = _model;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 119;
    _tableView.separatorColor = TBSeparaColor;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    BOOL isAll = NO;
    NSString *type = self.infoDic[@"url"];
    if(type.length == 0)
        isAll = YES;
    _headView = [BillHeadView headView:isAll];
    _headView.balanceLabel.text = [NSString stringWithFormat:@"%@：0.00元",self.infoDic[@"subTitle"]];
    _headView.billTypeList = self.billTypeList;
    _headView.beginTime = _model.beginTime;
    _headView.endTime = _model.endTime;
    _headView.endChange = ^(id time) {
        [weakSelf datePickerByType:1];
    };
    _headView.beginChange = ^(id time) {
        [weakSelf datePickerByType:0];
    };
    _headView.TypeChange = ^(NSInteger type) {
        NSDictionary *dic = weakSelf.billTypeList[type];
        weakModel.billName = dic[@"name"];
        [weakSelf performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    };
    
    _tableView.tableHeaderView = _headView;
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            [strongSelf getDataByPage:weakModel.page];
        }
    }];
}

-(void)getBillType{
    WEAK_OBJ(weakSelf, self);
    NSString *type = self.infoDic[@"url"];
    if(type.length == 0)
        return;
    [NET_REQUEST_MANAGER requestBillTypeWithType:type success:^(id object) {
        NSArray *arr = object[@"data"];
        [weakSelf.billTypeList addObjectsFromArray:arr];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}
- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}

- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        _headView.beginTime = date;
        _model.beginTime = date;
    }else{
        _headView.endTime = date;
        _model.endTime = date;
    }
    if([_model.endTime compare:_model.beginTime] == NSOrderedAscending){
        SVP_ERROR_STATUS(@"结束时间不能早于开始时间");
        return;
    }
    [self getData];
}

- (void)getData{
    SVP_SHOW;
    [self getDataByPage:0];
}

-(void)getDataByPage:(NSInteger)page{
    WEAK_OBJ(weakSelf, self);
    [_model getBillListWithPage:page success:^(NSDictionary *info) {
        if(weakSelf.model.dataList.count == 0)
            SVP_SUCCESS_STATUS(@"无相关数据");
        else
            SVP_DISMISS;
        NSDictionary *extra = info[@"data"][@"extras"];
        NSString *s = extra[@"money_sum"];
        weakSelf.headView.balanceLabel.text = [NSString stringWithFormat:@"%@：%@元",self.infoDic[@"subTitle"],STR_TO_AmountFloatSTR(s)];
        [weakSelf reload];
    } failure:^(NSError *error) {
        [weakSelf reload];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (void)reload{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    if (_model.isMost) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize2:13];
        label.textColor = Color_9;
        label.text = @"账单";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(15);
            make.top.bottom.equalTo(view);
        }];
        return view;
    }
    else
        return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0)?36:8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDTableModel *model = [_model.dataList objectAtIndex:indexPath.section];
    NSDictionary *dic = model.obj;
    NSMutableString *tStr = [[NSMutableString alloc] initWithString:@""];
    NSString *title = dic[@"title"];
    if(title.length > 0)
        [tStr appendString:dic[@"title"]];
    NSString *intro = dic[@"intro"];
    if([intro isKindOfClass:[NSNull class]])
        intro = @"";
    if(intro.length > 0){
        if(tStr.length > 0){
            [tStr appendFormat:@"(%@)",intro];
        }else
            [tStr appendString:intro];
    }
    if(tStr.length > 0){
        CGSize size = CGSizeMake(SCREEN_WIDTH - 15, 999);
        CGSize titleSize;
        titleSize = [tStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:0];
        return titleSize.height + 108;
    }
    return 125;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _model.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillTableViewCell *cell = (BillTableViewCell *)[tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.section]];
    cell.detailBtn.userInteractionEnabled = NO;
    //[cell.detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDTableModel *model = _model.dataList[indexPath.section];

    switch ([model.obj[@"billtId"] integerValue]) {
        case 3://扫雷抢包
        case 4://扫雷收入
        case 16://豹顺子奖励
        case 17://豹顺子赔付
            
        case 5://扫雷发包
        case 6://扫雷支出
        case 18://逾期退包
        case 34://禁抢群赔付到账
        case 41://禁抢发包
        case 24://niu
        case 25://niu
            {
                self.sendPId = [model.obj[@"userId"] stringValue];
                if (![FunctionManager isEmpty:model.obj[@"bizId"]]) {
//                    [self getRedpDetSendId:model.obj];
                    [self onGotoRedPackedDet:model.obj[@"bizId"]];
                }
            }
            break;
        default:
            {
                return;
            }
            break;
            
    }
    
    
    
    
}

-(void)getRedpDetSendId:(id)obj {
    __weak __typeof(self)weakSelf = self;
    SVP_SHOW;
    [[EnvelopeNet shareInstance] getUnityRedpDetail:obj[@"bizId"] withType:obj[@"billtId"] successBlock:^(NSDictionary *dic) {
        if (([[dic objectForKey:@"code"] integerValue] == 0)) {
            NSDictionary* dcc = dic[@"data"];
            [weakSelf onGotoRedPackedDet:dcc[@"detail"][@"id"]];
            SVP_DISMISS;
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:dic];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

#pragma mark -  goto红包详情
- (void)onGotoRedPackedDet:(NSString*)redId {
    [self.view endEditing:YES];
    RedEnvelopeDetListController *vc = [[RedEnvelopeDetListController alloc] init];
    vc.redPackedId = redId;
    vc.bankerId = self.sendPId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)detailAction:(id)sender{
    //    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:sender];
    //    NSIndexPath *path = [_tableView indexPathForCell:cell];
    //    NSInteger section = path.section;
    //    CDTableModel *model = _model.dataList[section];
    //    NSDictionary *dic = model.obj;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewDidAppear:(BOOL)animated{
//    [self requestBlance];
//}
//
//-(void)requestBlance{
//    WEAK_OBJ(weakSelf, self);
//    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
//        if(weakSelf.headView.balanceLabel)
//            weakSelf.headView.balanceLabel.text = [NSString stringWithFormat:@"金额总计：%@元",[AppModel shareInstance].user.balance];
//    } fail:^(id object) {
//
//    }];
//}

@end
