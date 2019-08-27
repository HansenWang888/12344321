//
//  RecommendedViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RecommendedViewController.h"
#import "RecommendNet.h"
#import "RecommendCell.h"
#import "ReportForms2ViewController.h"

@interface RecommendedViewController ()<UITableViewDelegate,UITableViewDataSource,ActionSheetDelegate>{
    UITableView *_tableView;
    RecommendNet *_model;
}
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UILabel *totalNumLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UILabel *totalNumLabel2;
@property(nonatomic,strong)UILabel *descLabel2;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UITextField *levelTextField;
@end

@implementation RecommendedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下级玩家";
    [self initData];
    [self initSubviews];
}

#pragma mark ----- Data
- (void)initData{
    _model = [[RecommendNet alloc]init];
    if (_uid == nil) {
        _uid = [AppModel shareInstance].userInfo.userId;
    }
}

#pragma mark ----- subView
- (void)initSubviews{
    
//    self.navigationItem.title = @"我的玩家";

    __weak RecommendNet *weakModel = _model;
    
    UIView *headView = [self headView];
    [self.view addSubview:headView];
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    __weak __typeof(self)weakSelf = self;

    _tableView.rowHeight = 130;
//    _tableView.separatorColor = TBSeparaColor;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData:0];
    }];
    _tableView.StateView = [StateView StateViewWithHandle:^{
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            [strongSelf getData:weakModel.page];
        }
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom);
    }];
    SVP_SHOW;
    [self getData:0];
}

#pragma mark net
- (void)getData:(NSInteger)page{
    WEAK_OBJ(weakObj, self);
    [_model getPlayerWithPage:page success:^(NSDictionary *obj){
        SVP_DISMISS;
        [weakObj reload];
    } failure:^(NSError *error) {
        [weakObj reload];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
    
    WEAK_OBJ(weakSelf, self);
    [_model requestCommonInfoWithSuccess:^(NSDictionary *obj) {
        [weakSelf updateHeadInfo];
    } failure:^(NSError *error) {
        [weakObj reload];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

-(void)updateHeadInfo{
    NSInteger agent = 0;
    if(_model.commonInfo[@"agent"])
        agent = [_model.commonInfo[@"agent"] integerValue];
    NSInteger user = 0;
    if(_model.commonInfo[@"user"])
        user = [_model.commonInfo[@"user"] integerValue];
    NSString *s = [NSString stringWithFormat:@"团队成员：代理%zd 玩家%zd",agent,user];
    self.descLabel.text = s;
    self.totalNumLabel.text = INT_TO_STR((agent + user));
    
    agent = 0;
    if(_model.commonInfo[@"pagent"])
        agent = [_model.commonInfo[@"pagent"] integerValue];
    user = 0;
    if(_model.commonInfo[@"puser"])
        user = [_model.commonInfo[@"puser"] integerValue];
    s = [NSString stringWithFormat:@"直推成员：代理%zd 玩家%zd",agent,user];
    self.descLabel2.text = s;
    self.totalNumLabel2.text = INT_TO_STR((agent + user));
}

- (void)reload{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_model.IsNetError){
        [_tableView.StateView showNetError];
    }
    else if(_model.isEmpty){
        [_tableView.StateView showEmpty];
    }else{
        [_tableView.StateView hidState];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tableView reloadData];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCell *cell = (RecommendCell *)[tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    //cell.detailButton.hidden = YES;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RecommendedViewController *vc = [[RecommendedViewController alloc]init];
//    CDTableModel *model = _model.dataList[indexPath.row];
//    vc.uid = model.obj[@"id"];
//    vc.title = [NSString stringWithFormat:@"%@的玩家",model.obj[@"nickname"]];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

-(void)detailAction:(UIButton *)btn{
    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:btn];
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    CDTableModel *model = _model.dataList[path.row];
    NSDictionary *dic = model.obj;
    ReportForms2ViewController *vc = [[ReportForms2ViewController alloc] init];
    vc.userId = dic[@"userId"];
    vc.isAgent = [dic[@"agentFlag"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 168)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"navBarBg"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:img];
    bgView.frame = view.bounds;
    [view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize2:23];
    titleLabel.textColor = COLOR_X(255, 255, 255);
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(view);
        make.right.equalTo(view.mas_centerX);
        make.height.equalTo(@35);
    }];
    titleLabel.text = @"-";
    self.totalNumLabel = titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont systemFontOfSize2:15];
    descLabel.textColor = COLOR_X(255, 255, 255);
    descLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view.mas_centerX);
        make.height.equalTo(@20);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    descLabel.text = @"-";
    self.descLabel = descLabel;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize2:23];
    titleLabel.textColor = COLOR_X(255, 255, 255);
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalNumLabel.mas_right);
        make.right.top.equalTo(view);
        make.height.equalTo(@35);
    }];
    titleLabel.text = @"-";
    self.totalNumLabel2 = titleLabel;
    
    descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont systemFontOfSize2:15];
    descLabel.textColor = COLOR_X(255, 255, 255);
    descLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.left.equalTo(self.descLabel.mas_right);
        make.height.equalTo(@20);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    descLabel.text = @"-";
    self.descLabel2 = descLabel;
    
    
    UIView *accountView = [[UIView alloc] init];
    accountView.backgroundColor = [UIColor clearColor];
    [view addSubview:accountView];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(view).multipliedBy(0.4);
        make.height.equalTo(@70);
        make.top.equalTo(descLabel.mas_bottom).offset(20);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"点击输入";
    textField.textColor = Color_0;
    textField.font = [UIFont systemFontOfSize2:15];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    [accountView addSubview:textField];;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(accountView);
        make.height.equalTo(@40);
    }];
    self.accountTextField = textField;
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.font = [UIFont systemFontOfSize2:15];
    tLabel.textColor = [UIColor whiteColor];
    tLabel.text = @"用户账号";
    [accountView addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField).offset(5);
        make.height.equalTo(@20);
        make.bottom.equalTo(textField.mas_top).offset(-3);
    }];
    
    UIView *levelView = [[UIView alloc] init];
    levelView.backgroundColor = [UIColor clearColor];
    [view addSubview:levelView];
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.mas_right).offset(10);
        make.width.equalTo(view).multipliedBy(0.4);
        make.height.equalTo(@70);
        make.top.equalTo(accountView.mas_top);
    }];
    
    textField = [[UITextField alloc] init];
    textField.text = @"全部";
    textField.textColor = Color_0;
    textField.font = [UIFont systemFontOfSize2:15];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    [levelView addSubview:textField];;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(levelView);
        make.height.equalTo(@40);
    }];
    self.levelTextField = textField;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [levelView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textField);
    }];
    [btn1 addTarget:self action:@selector(showTypes) forControlEvents:UIControlEventTouchUpInside];
    
    tLabel = [[UILabel alloc] init];
    tLabel.font = [UIFont systemFontOfSize2:15];
    tLabel.textColor = [UIColor whiteColor];
    tLabel.text = @"用户级别";
    [levelView addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField).offset(5);
        make.height.equalTo(@20);
        make.bottom.equalTo(textField.mas_top).offset(-3);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"agentSearch"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelView.mas_right);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(levelView.mas_bottom);
        make.height.equalTo(@40);
    }];
    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    CGPoint point = scrollView.contentOffset;
    CGRect rect = self.bgView.frame;
    rect.origin.y = -point.y;
    self.bgView.frame = rect;
}

-(void)searchAction{
    [self.view endEditing:YES];
    _model.userString = self.accountTextField.text;
    SVP_SHOW;
    [self getData:0];
}

-(void)showTypes{
    [self.view endEditing:YES];
    ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[@"全部",@"代理用户",@"会员用户"]];
    sheet.titleLabel.text = @"请选择用户类型";
    sheet.delegate = self;
    [sheet showWithAnimationWithAni:YES];
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    if(index == 0){
        self.levelTextField.text = @"全部";
        _model.type = -1;
    }
    else if(index == 1){
        self.levelTextField.text = @"代理用户";
        _model.type = 1;
    }
    else if(index == 2){
        self.levelTextField.text = @"会员用户";
        _model.type = 0;
    }
}

@end
