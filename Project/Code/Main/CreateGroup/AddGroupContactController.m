//
//  AddGroupContactController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactController.h"
#import "AddGroupContactCell.h"
#import "AddGroupContactHeadeerView.h"
#import "AddGroupSearchView.h"
#import "MessageNet.h"
#import "ContactModel.h"
#import "GroupNet.h"
static NSString *const AddGroupContactCellID = @"AddGroupContactCellID";
@interface AddGroupContactController ()<UITableViewDelegate,UITableViewDataSource,AddGroupSearchDelegate>
/** 页码*/
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 搜索*/
@property (nonatomic, strong) AddGroupSearchView *searchView;

@property (nonatomic, strong) UIButton *itemBtn;
/** 选择*/
@property (nonatomic, strong) NSMutableArray <ContactModel*>*seletSource;
/** 头部*/
@property (nonatomic, strong) AddGroupContactHeadeerView *header;
@end

@implementation AddGroupContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
    }];
    
    
    [self initNav];
    __weak __typeof(self)weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
//        [self.seletSource removeAllObjects];
//        [self.dataSource removeAllObjects];
//        [self.itemBtn setTitle:@"   确认  " forState:UIControlStateNormal];
//        self.itemBtn.width = 60;
        [self getData:@""];
//    }];
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf getData:@""];
    }];
   
}
- (void)getData:(NSString *)userId{
    if (self.type == ControllerType_delete) {
        [[GroupNet alloc] getGroupMemberWithUserID:userId groupId:self.groupId pageIndex:self.page pageSize:20 successBlock:^(NSDictionary *response) {
            NSMutableArray *models = [ContactModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"records"]];
            [models enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSource addObject:obj];
            }];
            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
            if (models.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        } failureBlock:^(NSError *failure) {
//            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
        
    } else {
        
        NSDictionary *dict = @{@"current":@(self.page),
                               @"size": @20,
                               @"chatGroupId":self.groupId,
                               @"userIdOrNick":userId
                               };
        [MESSAGE_NET getNotIntoGroupPage:dict successBlock:^(NSDictionary *success) {
            NSLog(@"%@",success);
            NSMutableArray *models = [ContactModel mj_objectArrayWithKeyValuesArray:success[@"data"][@"records"]];
            if (models.count == 0) {
                SVP_ERROR_STATUS(@"暂无数据");
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                SVP_SHOW;
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    SVP_DISMISS;
                    
                    [models enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (self.seletSource.count > 0) {
                         
                            [self.seletSource enumerateObjectsUsingBlock:^(ContactModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj.userId isEqualToString:model.userId]) {
                                    obj.isSelected = model.isSelected;
                                }
                            }];
                            [self.dataSource addObject:obj];
                        }else{
                            [self.dataSource addObject:obj];
                        }
                    }];
                    [self.tableView reloadData];
                    
                    if (models.count < 20) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                });
            }
            
            
        } failureBlock:^(NSError *failure) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [[FunctionManager sharedInstance] handleFailResponse:failure];
            SVP_DISMISS;
        }];
    }
  
}
- (void)initNav{
    self.itemBtn = [[UIButton alloc]init];
    [self.itemBtn setTitle:@"   确认  " forState:UIControlStateNormal];
    self.itemBtn.titleLabel.font = [UIFont systemFontOfSize2:13];
    self.itemBtn.layer.masksToBounds = YES;
    self.itemBtn.layer.cornerRadius = 6;
    self.itemBtn.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:56.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    self.itemBtn.width = 60;
    [self.itemBtn addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.itemBtn];;
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - TableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[AddGroupContactCell class] forCellReuseIdentifier:AddGroupContactCellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
      
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
// //配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddGroupContactCell *cell = [tableView dequeueReusableCellWithIdentifier:AddGroupContactCellID];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count == 0) {
        return;
    }
    ContactModel *model = self.dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.seletSource insertObject:model atIndex:0];
//        [self.seletSource addObject:model];
    }else{
        [self.seletSource enumerateObjectsUsingBlock:^(ContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.userId isEqualToString:obj.userId]) {
                [self.seletSource removeObjectAtIndex:idx];
            }
        }];
    }
    if (self.seletSource.count == 0) {
        [self.tableView reloadData];
        
    }else{
        if (self.seletSource.count == 1) {
            //1.传入要刷新的组数
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
            //2.传入NSIndexSet进行刷新
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    self.header.dataSource = self.seletSource;
  
    if (self.seletSource.count > 0){
        if (self.seletSource.count > 99) {
            [self.itemBtn setTitle:[NSString stringWithFormat:@"   确认(99+) "] forState:UIControlStateNormal];
        }else{
            [self.itemBtn setTitle:[NSString stringWithFormat:@"   确认(%lu) ",(unsigned long)self.seletSource.count] forState:UIControlStateNormal];
            }
        self.itemBtn.width =  80;
        [self.itemBtn layoutIfNeeded];
        
    }else{
        [self.itemBtn setTitle:[NSString stringWithFormat:@"   确认 "] forState:UIControlStateNormal];
        self.itemBtn.width =  60;
        [self.itemBtn layoutIfNeeded];
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.seletSource.count > 0 ? 55 : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.header;
}
//添加通讯录好友
- (void)addContact{
    if (self.seletSource.count == 0) {
        SVP_ERROR_STATUS(@"请选择好友!");
        return;
    }
    NSMutableArray *ids = [NSMutableArray array];

    [self.seletSource enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids addObject:obj.userId];
    }];
    if (ids.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个群成员"];
        return;
    }
    if (self.type == ControllerType_delete) {
        [[GroupNet alloc] deleteGroupMembersWithGroupId:self.groupId userIds:ids successBlock:^(NSDictionary *success) {
            if ([success[@"code"]integerValue] == 0 ) {
                SVP_SUCCESS_STATUS(success[@"alterMsg"]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addGroupContact" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                SVP_ERROR_STATUS(success[@"alterMsg"]);
            }
        } failureBlock:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"操作失败"];
        }];
    } else {
        
        NSDictionary *dict = @{@"groupId":self.groupId,
                               @"userIds":ids
                               };
        [MESSAGE_NET addGroupMember:dict successBlock:^(NSDictionary *success) {
            if ([success[@"code"]integerValue] == 0 ) {
                SVP_SUCCESS_STATUS(success[@"alterMsg"]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addGroupContact" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                SVP_ERROR_STATUS(success[@"alterMsg"]);
            }
        } failureBlock:^(NSError *failure) {
            
        }];
    }
   
}
/**
 搜索的代理
 */
- (void)addGroupSearchTitle:(NSString *)title{
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimmedStr = [title stringByTrimmingCharactersInSet:set];
//    // 判断新字符串的长度是否为0
//    if (title.length == 0 ||trimmedStr.length == 0 ) {
////        SVP_ERROR_STATUS(@"搜索不能为空");
//        return;
//    }
//    [self.view endEditing:YES];
    [self.dataSource removeAllObjects];
    [self getData:title];
}
- (AddGroupContactHeadeerView *)header{
    if (!_header) {
        _header = [[AddGroupContactHeadeerView alloc]init];
    }
    return _header;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSource;
}
- (NSMutableArray <ContactModel *>*)seletSource{
    if (!_seletSource) {
        _seletSource = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _seletSource;
}
- (AddGroupSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[AddGroupSearchView alloc]init];
        _searchView.searchDelegate = self;
    }
    return _searchView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
