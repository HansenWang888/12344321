//
//  AllUserViewController.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "AllUserViewController.h"
#import "UserTableViewCell.h"
#import "GroupNet.h"
#import "BANetManager_OC.h"

// 群成员控制器
@interface AllUserViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (nonatomic ,strong)  UITableView *tableView;
@property (nonatomic ,strong) GroupNet *model;

@end

@implementation AllUserViewController
+ (AllUserViewController *)allUser:(id)obj {
    AllUserViewController *vc = [[AllUserViewController alloc]init];
    vc.model = obj;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    if (_model == nil) {
        _model = [GroupNet new];
    }
}


#pragma mark ----- Layout
- (void)initLayout{
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews {
    self.view.backgroundColor = BaseColor;
//    self.navigationItem.title = self.title;
//    self.navigationItem.title = @"所有成员";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = TBSeparaColor;
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    __weak GroupNet *weakModel = _model;
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getGroupUsersData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            if (weakModel.page < 1) {
                weakModel.page = 2;
            } else {
                weakModel.page++;
            }
            [strongSelf getGroupUsersData];
        }
    }];
}

#pragma mark -  获取群组成员数据
- (void)getGroupUsersData {
    __weak __typeof(self)weakSelf = self;
    [_model queryGroupUserGroupId:self.groupId successBlock:^(NSDictionary *info) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([info objectForKey:@"code"] && [[info objectForKey:@"code"] integerValue] == 0) {
            [strongSelf->_tableView.mj_header endRefreshing];
            [strongSelf->_tableView.mj_footer endRefreshing];
            [strongSelf->_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.isDelete = self.isDelete;
    cell.obj = _model.dataList[indexPath.row];
    __weak __typeof(self)weakSelf = self;
    cell.deleteBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf exit_group:[strongSelf.model.dataList[indexPath.row] objectForKey:@"userId"]];
        return;
    };
    
    return cell;//[tableView CDdequeueReusableCellWithIdentifier:_dataList[indexPath.row]];
}



#pragma mark -  移除群组确认
/**
 移除群组确认
 */
-(void)exit_group:(NSString *)userId {
    WEAK_OBJ(weakSelf, self);
    
    [[AlertViewCus createInstanceWithView:nil] showWithText:@"确认移除该玩家？" button1:@"取消" button2:@"确认" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1)
            [weakSelf action_exitGroup:userId];
    }];
}



/**
 删除群成员
 */
- (void)action_exitGroup:(NSString *)userId {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/delgroupMember"];

    entity.needCache = NO;
    NSDictionary *parameters = @{
                                 @"chatGroupId":self.groupId,
                                 @"userId":userId,
                                 };
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
            SVP_SUCCESS_STATUS(msg);
            strongSelf.model.page = 1;
            [strongSelf getGroupUsersData];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


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

@end
