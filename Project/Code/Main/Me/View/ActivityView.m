//
//  ActivityView.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityView.h"
#import "ActivityCell.h"
#import "ActivityCell2.h"
#import "ActivityCell3.h"
#import "ImageDetailViewController.h"
#import "AlertViewCus.h"
#import "FirstRewardDetailViewController.h"

@implementation ActivityView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _tableView = [UITableView normalTable];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_X(245, 245, 245);
    _tableView.backgroundView = view;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 120;
    _tableView.tableHeaderView = [self headView];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData];
    }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self initData];
    [_tableView reloadData];
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [self getData];
}
-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestActivityListWithUserId:self.userId success:^(id object) {
        weakSelf.dataArray = object[@"data"];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } fail:^(id object) {
        [weakSelf.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)initData{
    //    NSDictionary *dic1 = @{@"title":@"发包满额奖励",@"num":@"0"};
    //    [self.dataArray addObject:dic1];
    //
    //    NSDictionary *dic2 = @{@"title":@"抢包满额奖励",@"num":@"0"};
    //    [self.dataArray addObject:dic2];
    //
    //    NSDictionary *dic3 = @{@"title":@"直推流水佣金",@"num":@"0"};
    //    [self.dataArray addObject:dic3];
    //
    //    NSDictionary *dic4 = @{@"title":@"邀请好友佣金",@"num":@"0"};
    //    [self.dataArray addObject:dic4];
    //
    //    NSDictionary *dic5 = @{@"title":@"豹子顺子奖励",@"num":@"0"};
    //    [self.dataArray addObject:dic5];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    NSMutableDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    NSDictionary *promotDic = dic[@"skPromot"];
    NSArray *arr = dic[@"skPromotItemList"];
    NSInteger type = [promotDic[@"type"] integerValue];
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if(type == 3000 || type == 4000)
            cell = [[ActivityCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        else
            cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell initView];
        [cell.xiangQingBtn addTarget:self action:@selector(xiangQingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    float a = [dic[@"moneySum"] floatValue];

    
    cell.titleLabel.text = promotDic[@"mainTitle"];
    [cell.numBtn setTitle:dic[@"reward"] forState:UIControlStateNormal];
    BOOL isGet = [dic[@"hasReceive"] boolValue];
    if(!isGet){
        cell.getBtn.selected = NO;
        cell.getBtn.userInteractionEnabled = YES;
    }else{
        cell.getBtn.selected = YES;
        cell.getBtn.userInteractionEnabled = NO;
    }
    if(self.hiddenGetRewardBtn)
        cell.getBtn.hidden = YES;
    else
        [cell.getBtn addTarget:self action:@selector(getReword:) forControlEvents:UIControlEventTouchUpInside];

    if(type == 3000 || type == 4000){
        ActivityCell2 *cell2 = (ActivityCell2 *)cell;
        [cell2 setPointArray:arr andCurrentMoney:a];
    }else{
        float b = a;
        id thresholdMax = dic[@"thresholdMax"];
        if([thresholdMax isKindOfClass:[NSNull class]]){
            
        }else if([thresholdMax isKindOfClass:[NSString class]]){
            if(![thresholdMax isEqualToString:@"0"])
                b = [thresholdMax floatValue];
        }
        else if([thresholdMax isKindOfClass:[NSNumber class]])
            b = [thresholdMax floatValue];
        float rate = 0;
        if(b > 0)
            rate = a/b;
        cell.rate = rate;
    }
    return cell;
}

-(UIView *)headView{
    float rate = 358/200.0;
    float width = SCREEN_WIDTH/2.0;
    float height = width/rate;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"activity6"] forState:UIControlStateNormal];
    [view addSubview:btn1];
    btn1.tag = 1;
    btn1.frame = CGRectMake(0, 0, width, height);
    [btn1 addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"activity5"] forState:UIControlStateNormal];
    [view addSubview:btn2];
    btn2.tag = 2;
    btn2.frame = CGRectMake(width, 0, width, height);
    [btn2 addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

-(void)getReword:(UIButton *)btn{
    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:btn];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    self.selectIndex = path.row;
    WEAK_OBJ(weakSelf, self);
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    [view showWithText:@"是否领取奖励？" button1:@"取消" button2:@"领取" callBack:^(id object) {
        NSInteger index = [object integerValue];
        if(index == 1)
            [weakSelf getReword2];
    }];
}

-(void)getReword2{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:self.selectIndex];
    BOOL isGet = [dic[@"hasReceive"] boolValue];
    if(isGet)
        return;
    NSDictionary *promotDic = dic[@"skPromot"];
    NSString *type = promotDic[@"type"];
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER getRewardWithActivityType:type userId:[AppModel shareInstance].userInfo.userId success:^(id object) {
        SVP_SUCCESS_STATUS(object[@"data"]);
        [weakSelf getData];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)xiangQingAction:(UIButton *)btn{
    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:btn];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dic = [_dataArray objectAtIndex:path.row];
    NSDictionary *promotDic = dic[@"skPromot"];
    NSString *img = promotDic[@"img"];
    
    ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
    vc.imageUrl = img;
    vc.hiddenNavBar = YES;
    vc.title = @"活动详情";
    vc.hidesBottomBarWhenPushed = YES;
    [[[FunctionManager sharedInstance] currentViewController].navigationController pushViewController:vc animated:YES];
}

-(void)headAction:(UIButton *)btn{
    //[self xiangQingAction:nil];
    NSInteger tag = btn.tag;
    FirstRewardDetailViewController *vc = [[FirstRewardDetailViewController alloc] init];
    vc.userId = self.userId;
    vc.hiddenNavBar = YES;
    if(tag == 1){
        vc.rewardType = 1100;
        vc.title = @"我的首充奖励";
    }
    else{
        vc.rewardType = 1200;
        vc.title = @"我的二充奖励";
    }
    vc.hidesBottomBarWhenPushed = YES;
    [[[FunctionManager sharedInstance] currentViewController].navigationController pushViewController:vc animated:YES];
}

-(void)showTimeSelectView{
}
@end
