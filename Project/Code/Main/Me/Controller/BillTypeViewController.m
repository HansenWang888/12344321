//
//  BillTypeViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "BillTypeViewController.h"
#import "BillViewController.h"

@interface BillTypeViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation BillTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账单记录";
    self.dataArray = [[NSMutableArray alloc] init];
    [self initData];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    NSInteger width = SCREEN_WIDTH/2.0;
    NSInteger height = 86;
    
    NSInteger bottom = 0;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        NSDictionary *dict = self.dataArray[i];
        NSInteger a = i%2;
        NSInteger b = i/2;
        UIButton *btn = [self itemWithDic:dict frame:CGRectMake(a *width, b * height, width, height)];
        [self.scrollView addSubview:btn];
        bottom = btn.frame.origin.y + btn.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initData{
    [self.dataArray addObject:@{@"icon":@"billType1",@"title":@"全部记录",@"url":@"",@"tag":@"1",@"subTitle":@""}];
    [self.dataArray addObject:@{@"icon":@"billType2",@"title":@"奖励记录",@"url":@"reward",@"tag":@"2",@"subTitle":@"累计奖励收入"}];
    [self.dataArray addObject:@{@"icon":@"billType3",@"title":@"充值记录",@"url":@"recharge",@"tag":@"3",@"subTitle":@"累计充值"}];
    [self.dataArray addObject:@{@"icon":@"billType4",@"title":@"提现记录",@"url":@"withdraw",@"tag":@"4",@"subTitle":@"累计提现"}];
    [self.dataArray addObject:@{@"icon":@"billType5",@"title":@"发包记录",@"url":@"send_red_packet",@"tag":@"5",@"subTitle":@"累计发包"}];
    [self.dataArray addObject:@{@"icon":@"billType6",@"title":@"抢包记录",@"url":@"rob_red_packet",@"tag":@"6",@"subTitle":@"累计抢包"}];
    [self.dataArray addObject:@{@"icon":@"billType7",@"title":@"盈亏记录",@"url":@"win_loss",@"tag":@"7",@"subTitle":@"余额"}];
    [self.dataArray addObject:@{@"icon":@"billType8",@"title":@"佣金收入",@"url":@"commission_in",@"tag":@"8",@"subTitle":@"累计收入佣金"}];
    [self.dataArray addObject:@{@"icon":@"billType9",@"title":@"水果机记录",@"url":@"fruit",@"tag":@"9",@"subTitle":@"累计盈亏"}];
    if([AppModel shareInstance].userInfo.innerNumFlag || [AppModel shareInstance].userInfo.groupowenFlag)
        [self.dataArray addObject:@{@"icon":@"billType10",@"title":@"佣金支出",@"url":@"commission_out",@"tag":@"10",@"subTitle":@"累计支出佣金"}];
    else
        [self.dataArray addObject:@{@"icon":@"billType11",@"title":@"敬请期待",@"tag":@"10"}];
}

- (UIButton *)itemWithDic:(NSDictionary *)info frame:(CGRect)rect{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = [info[@"tag"] integerValue];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = [UIImageView new];
    [btn addSubview:imgView];
    imgView.image = [UIImage imageNamed:info[@"icon"]];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn.mas_centerY).offset(-11);
    }];
    
    UILabel *label = [UILabel new];
    [btn addSubview:label];
    label.textColor = Color_3;
    label.font = [UIFont systemFontOfSize2:15];
    label.numberOfLines = 0;
    label.text = info[@"title"];
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.centerY.equalTo(btn.mas_centerY).offset(25);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =  TBSeparaColor;
    [btn addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(btn);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor =  TBSeparaColor;
    [btn addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(btn);
        make.width.equalTo(@0.5);
        make.right.equalTo(btn);
    }];
    
    return btn;
}

-(void)btnAction:(UIButton *)btn{
    NSInteger tag = btn.tag - 1;
    NSDictionary *dic = self.dataArray[tag];
    NSString *url = dic[@"url"];
    if(url == nil){
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
        return;
    }
    BillViewController *vc = [[BillViewController alloc] init];
    vc.title = dic[@"title"];
    vc.infoDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
