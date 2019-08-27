//
//  ActivityMainViewController.m
//  Project
//
//  Created by fangyuan on 2019/3/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityMainViewController.h"
#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"
#import "UIImageView+WebCache.h"

@interface ActivityMainViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
    BOOL _pauseAni;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *aniObjArray;

@end

@implementation ActivityMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"活动奖励";
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = BaseColor;

    float rate = 357/1010.0;

    self.aniObjArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = (SCREEN_WIDTH - 40) * rate + 40 + 8;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-20);
    }];
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf requestData];
    }];

    [self requestData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(update) userInfo:nil repeats:YES];

}

-(void)update{
    if(_pauseAni)
        return;
    NSMutableArray *newArray = [NSMutableArray array];
    for (UIView *view in self.aniObjArray) {
        CGPoint point = [view.superview convertPoint:view.center toView:self.view];
        if(point.y < 0 || point.y > self.view.frame.size.height)
            continue;
        [newArray addObject:view];
    }
    if(newArray.count == 0)
        return;
    NSInteger random = arc4random()%newArray.count;
    if(random >= newArray.count)
        random = newArray.count - 1;
    UIView *view = newArray[random];
    if([view isKindOfClass:[UIImageView class]]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuang1"]];
        imgView.alpha = 0.9;
        [view addSubview:imgView];
        imgView.frame = CGRectMake(view.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        [UIView animateWithDuration:0.7 animations:^{
            imgView.frame = CGRectMake(-imgView.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 8;
        [cell addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell);
            make.top.equalTo(cell).offset(4);
            make.bottom.equalTo(cell).offset(-4);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [view addSubview:imgView];
        imgView.backgroundColor = COLOR_X(230, 230, 230);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
            make.bottom.equalTo(cell).offset(-40-4);
        }];
        imgView.tag = 1;
        [self.aniObjArray addObject:imgView];
        
        UIView *dotView = [[UIView alloc] init];
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = 3;
        dotView.backgroundColor = COLOR_X(255, 80, 80);
        [view addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.bottom.equalTo(view.mas_bottom).offset(-20+3);
            make.width.height.equalTo(@6);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dotView.mas_right).offset(10);
            make.bottom.equalTo(view);
            make.height.equalTo(@40);
        }];
        titleLabel.font = [UIFont systemFontOfSize2:15];
        titleLabel.textColor = COLOR_X(80, 80, 80);
        titleLabel.tag = 2;
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    
    UIImageView *imgView = [cell viewWithTag:1];
    UILabel *titleLabel = [cell viewWithTag:2];
    [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    titleLabel.text = dic[@"mainTitle"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSInteger type = [dic[@"type"] integerValue];
    if(type == RewardType_bzsz || type == RewardType_ztlsyj || type == RewardType_yqhycz || type == RewardType_czjl || type == RewardType_zcdljl){//6000豹子顺子奖励 5000直推流水佣金 1110邀请好友充值 1100充值奖励 2100注册登录奖励
        ActivityDetail1ViewController *vc = [[ActivityDetail1ViewController alloc] init];
        vc.infoDic = dic;
        vc.imageUrl = dic[@"bodyImg"];
        vc.title = dic[@"mainTitle"];
        vc.hiddenNavBar = YES;
        vc.top = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(type == RewardType_fbjl
            ||type == RewardType_qbjl
            ||type == RewardType_jjj){// 3000发包奖励 4000抢包奖励//7000救济金
        ActivityDetail2ViewController *vc = [[ActivityDetail2ViewController alloc] init];
        vc.infoDic = dic;
        vc.title = dic[@"mainTitle"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        SVP_ERROR_STATUS(@"未知类型活动");
        ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
        vc.imageUrl = ![FunctionManager isEmpty:dic[@"bodyImg"]]?dic[@"bodyImg"]:@"";
        vc.hiddenNavBar = YES;
        vc.title = dic[@"mainTitle"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)requestData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER getActivityListWithSuccess:^(id object) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf requestDataBack:object];
    } fail:^(id object) {
        [weakSelf.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestDataBack:(NSDictionary *)dict{
    _dataArray = dict[@"data"][@"records"];
    if(_dataArray.count == 0){
        SVP_ERROR_STATUS(@"暂无数据");
        return;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController.navigationBarHidden == YES)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _pauseAni = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _pauseAni = YES;
}
@end
