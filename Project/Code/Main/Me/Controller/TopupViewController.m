//
//  TopupViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "TopupViewController.h"
#import "TopupBarView.h"
#import "WebViewController2.h"
#import "MemberCell.h"
#import "UIImageView+WebCache.h"

@interface TopupViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TopupBarView *_topupBar;
}
@property(nonatomic,strong)UITableView *tableView;;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)NSInteger selectIndex;
@end

@implementation TopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initData];
    [self initSubviews];
    [self initLayout];
    SVP_SHOW;
    [self getData];
}

-(void)viewDidAppear:(BOOL)animated{
    [_topupBar.moneyField becomeFirstResponder];
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestRechargeListWithSuccess:^(id object) {
        SVP_DISMISS;
        weakSelf.dataArray = object[@"data"];
        [weakSelf.tableView reloadData];
    } fail:^(id object) {
        [FUNCTION_MANAGER handleFailResponse:object];
    }];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.navigationItem.title = @"充值中心";
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.rowHeight = 50;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 61, 0, 0);
    _tableView.separatorColor = TBSeparaColor;

    _topupBar = [TopupBarView topupBar];
    _tableView.tableHeaderView = _topupBar;
    
    [self setUITwo];
}

- (void)setUITwo {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CDScreenWidth, 300)];
    _tableView.tableFooterView = footer;
    UIButton *submit = [UIButton new];
    [footer addSubview:submit];
    submit.layer.cornerRadius = 8;
    submit.backgroundColor = MBTNColor;
    submit.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [submit setTitle:@"确认支付" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [submit delayEnable];
    
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left).offset(16);
        make.right.equalTo(footer.mas_right).offset(-16);
        make.height.equalTo(@(44));
        make.top.equalTo(footer.mas_top).offset(32);
    }];
    
    UILabel *tipLabel = [UILabel new];
    [footer addSubview:tipLabel];
    tipLabel.font = [UIFont systemFontOfSize2:12];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = Color_6;
    NSString *s = [APP_MODEL.commonInfo objectForKey:@"charge.content"];
    tipLabel.text = s;
    [tipLabel setValue:@(20) forKey:@"lineSpacing"];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer.mas_left).offset(18);
        make.right.equalTo(footer.mas_right).offset(-18);
        make.top.equalTo(submit.mas_bottom).offset(0);
        make.height.equalTo(@80);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CDScreenWidth, 36)];
        view.backgroundColor = BaseColor;
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize2:13];
        label.textColor = Color_6;
        label.text = @"充值方式";
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
    if(section == 0)
        return 36;
    return 12.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,(long)row];
    MemberCell *cell =(MemberCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [self setCell:cell dict:dict cellIdentifier:cellIdentifier];
    }
    cell.rightArrowImage.hidden = YES;
    UIImageView *flagView = [cell.contentView viewWithTag:1];
    if(self.selectIndex/100 == indexPath.section && self.selectIndex%100 == indexPath.row)
        flagView.hidden = NO;
    else
        flagView.hidden = YES;
    return cell;
}



- (MemberCell *)setCell:(MemberCell *)cell dict:(NSDictionary *)dict cellIdentifier:(NSString *) cellIdentifier {
    
    cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@15);
        make.width.height.equalTo(@34);
    }];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
    
    UILabel *itemLabel = [UILabel new];
    [cell.contentView addSubview:itemLabel];
    itemLabel.font = [UIFont systemFontOfSize2:16];
    itemLabel.textColor = Color_0;
    itemLabel.text = dict[@"title"];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectIcon"]];
    flagView.tag = 1;
    [cell.contentView addSubview:flagView];
    [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.centerY.equalTo(cell.contentView);
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    self.selectIndex = indexPath.row;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:self.selectIndex forKey:@"payTypeIndex"];
    [ud synchronize];
    [tableView reloadData];
}

#pragma mark action
- (void)action_submit{
    if (_topupBar.money.length == 0 || ![FUNCTION_MANAGER checkIsNum:_topupBar.money]) {
        SVP_ERROR_STATUS(@"请输入正确的充值金额");
        return;
    }
    if (_topupBar.money.length > 8) {
        SVP_ERROR_STATUS(@"充值金额过大");
        return;
    }
    [self openByWeb];
}

-(void)openByWeb{
    //NSInteger section = self.selectIndex/100;
    NSInteger row = self.selectIndex;
    NSDictionary *dict = self.dataArray[row];

    NSString *url = [NSString stringWithFormat:@"%@%@&id=%@&amount=%@",APP_MODEL.serverUrl,dict[@"url"],APP_MODEL.userInfo.userId,_topupBar.money];
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
    WebViewController2 *vc = [[WebViewController2 alloc] init];
    vc.navigationItem.title = @"充值";
    [vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
