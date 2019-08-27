//
//  DiscoveryViewController.m
//  WeiCaiProj
//
//  Created by fy on 2018/12/25.
//  Copyright © 2018 hzx. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "MemberCell.h"
#import "AlertViewCus.h"
#import "WheelViewController.h"
#import "WebViewController2.h"
#import "WebViewController.h"

@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    _dataArray = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setBackgroundImage:[[FunctionManager sharedInstance] imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[FunctionManager sharedInstance] imageWithColor:COLOR_X(200, 200, 200) andSize:CGSizeMake(10, 0.5)]];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back2"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_X(60, 60, 60)}];
    
    self.navigationItem.title = @"发现";
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - 50)  style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 64;
    _tableView.separatorColor = TBSeparaColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"discover_sgyxj" forKey:@"icon"];
    [dic1 setObject:@"水果游戏机" forKey:@"title"];
    [dic1 setObject:@"1" forKey:@"tag"];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"discover_xydzp" forKey:@"icon"];
    [dic2 setObject:@"幸运大转盘" forKey:@"title"];
    [dic2 setObject:@"2" forKey:@"tag"];

    NSArray *array = [NSArray arrayWithObjects:dic2,dic1, nil];
    [_dataArray addObject:array];

    
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"discover_yeb" forKey:@"icon"];
    NSString *s = [[FunctionManager sharedInstance] getApplicationName];
    s = [s stringByReplacingOccurrencesOfString:@"红包" withString:@""];
    s = [NSString stringWithFormat:@"%@余额宝",s];
    [dic3 setObject:s forKey:@"title"];
    [dic3 setObject:@"3" forKey:@"tag"];
//    if([[FunctionManager sharedInstance] appType] == AppType_XZHB)
//        [dic3 setObject:@"小猪余额宝" forKey:@"title"];
//    else if([[FunctionManager sharedInstance] appType] == AppType_TTHB)
//        [dic3 setObject:@"天天余额宝" forKey:@"title"];
//    else if([[FunctionManager sharedInstance] appType] == AppType_WWHB)
//        [dic3 setObject:@"旺旺余额宝" forKey:@"title"];
//    else if([[FunctionManager sharedInstance] appType] == AppType_WBHB)
//        [dic3 setObject:@" 5 8 余额宝" forKey:@"title"];
//    else if([[FunctionManager sharedInstance] appType] == AppType_CSHB)
//        [dic3 setObject:@"测试余额宝" forKey:@"title"];
//    else if([[FunctionManager sharedInstance] appType] == AppType_QQHB)
//        [dic3 setObject:@"全球余额宝" forKey:@"title"];
    
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] init];
    [dic4 setObject:@"discover_dzpk" forKey:@"icon"];
    [dic4 setObject:@"休闲小游戏" forKey:@"title"];
    [dic4 setObject:@"4" forKey:@"tag"];
    
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] init];
    [dic5 setObject:@"discover_cqssc" forKey:@"icon"];
    [dic5 setObject:@"桌球小游戏" forKey:@"title"];
    [dic5 setObject:@"5" forKey:@"tag"];
    
    array = [NSArray arrayWithObjects:dic3,dic4,dic5, nil];
    [_dataArray addObject:array];
    
    NSMutableDictionary *dic6 = [[NSMutableDictionary alloc] init];
    [dic6 setObject:@"discover_h8ty" forKey:@"icon"];
    [dic6 setObject:@"红包欢乐斗" forKey:@"title"];
    [dic6 setObject:@"6" forKey:@"tag"];
    
    NSMutableDictionary *dic7 = [[NSMutableDictionary alloc] init];
    [dic7 setObject:@"discover_mgdz" forKey:@"icon"];
    [dic7 setObject:@"一直被模仿" forKey:@"title"];
    [dic7 setObject:@"7" forKey:@"tag"];
    
    NSMutableDictionary *dic8 = [[NSMutableDictionary alloc] init];
    [dic8 setObject:@"discover_agsx" forKey:@"icon"];
    [dic8 setObject:@"从未被超越" forKey:@"title"];
    [dic8 setObject:@"8" forKey:@"tag"];
    
    array = [NSArray arrayWithObjects:dic6,dic7,dic8, nil];
    [_dataArray addObject:array];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.itemIcon.layer.masksToBounds = YES;
        cell.itemIcon.layer.cornerRadius = 9.0;
        cell.itemIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSArray *arr = _dataArray[indexPath.section];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    cell.itemIcon.image = [UIImage imageNamed:dic[@"icon"]];
    cell.itemLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
    NSInteger tag = [dic[@"tag"] integerValue];
    if(tag == 2){
        NSString *urlHead = [AppModel shareInstance].commonInfo[@"big.wheel.lottery.url"];
        if(urlHead.length > 0){
            NSString *url = [NSString stringWithFormat:@"%@?token=%@",urlHead,[AppModel shareInstance].userInfo.token];
            WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
            vc.navigationItem.title = dic[@"title"];
            vc.hidesBottomBarWhenPushed = YES;
            //[vc loadWithURL:url];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
//        WheelViewController *vc = [[WheelViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 1){
        NSString *urlHead = [AppModel shareInstance].commonInfo[@"fruit.slot.url"];
        if(urlHead.length > 0){
            NSString *url = [NSString stringWithFormat:@"%@?token=%@",urlHead,[AppModel shareInstance].userInfo.token];
            WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
            vc.navigationItem.title = dic[@"title"];
            vc.hidesBottomBarWhenPushed = YES;
            //[vc loadWithURL:url];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
}
@end
