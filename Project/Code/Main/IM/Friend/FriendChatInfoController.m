//
//  FriendChatInfoController.m
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FriendChatInfoController.h"
#import "UserTableViewCell.h"
#import "GroupNet.h"
#import "BANetManager_OC.h"
#import "RCDBaseSettingTableViewCell.h"
#import "FriendChatInfoHeadCell.h"
#import "WHC_ModelSqlite.h"


static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";


// 群成员控制器
@interface FriendChatInfoController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)  UITableView *tableView;

@end

@implementation FriendChatInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天信息";

    [self initSubviews];

}

#pragma mark ----- subView
- (void)initSubviews {
    self.view.backgroundColor = BaseColor;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = TBSeparaColor;
//    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        FriendChatInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendChatInfoHeadCell"];
        if (cell == nil) {
            cell = [[FriendChatInfoHeadCell alloc]initWithStyle:0 reuseIdentifier:@"FriendChatInfoHeadCell"];
        }
        cell.contacts = self.contacts;
        return cell;
    }
    
    RCDBaseSettingTableViewCell *cellee = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cellee) {
        cellee = [[RCDBaseSettingTableViewCell alloc] init];
    }
    if (indexPath.section == 1) {
        [cellee setCellStyle:SwitchStyle];
        cellee.leftLabel.text = @"消息免打扰";
        cellee.switchButton.on = self.contacts.isNotDisturbSound;
        
        [cellee.switchButton addTarget:self
                                action:@selector(onSwitchNotDisturb:)
                      forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 2) {
        [cellee setCellStyle:SwitchStyle];
        cellee.leftLabel.text = @"置顶聊天";
        cellee.switchButton.hidden = NO;
       
        cellee.switchButton.on = self.contacts.isTopChat;
        
        [cellee.switchButton addTarget:self
                                action:@selector(onSwitchTop:)
                      forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 100) {
//        [cellee setCellStyle:DefaultStyle];
//        cellee.leftLabel.text = @"查找聊天记录";
    } else if (indexPath.section == 3) {
        [cellee setCellStyle:DefaultStyle];
        cellee.leftLabel.text = @"清空聊天记录";
    }
    cellee.leftLabel.font = [UIFont systemFontOfSize2:15];
    return cellee;
    
    
//    cell.isDelete = self.isDelete;
//    cell.obj = _model.dataList[indexPath.row];
//    __weak __typeof(self)weakSelf = self;
//    cell.deleteBtnBlock = ^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//        [strongSelf exit_group:[strongSelf.model.dataList[indexPath.row] objectForKey:@"userId"]];
//        return;
//    };
//
//    return cell;
}

#pragma mark - UITableViewDelegate
// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 100) {
        
    } else if (indexPath.section == 3) {
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        view.textLabel.font = [UIFont systemFontOfSize2:16];
        [view showWithText:@"清空聊天记录！" button1:@"取消" button2:@"确认" callBack:^(id object) {
            NSInteger tag = [object integerValue];
            if(tag == 1){
                 SVP_SHOW;
                NSString *whereStr = [NSString stringWithFormat:@"sessionId='%@'",self.contacts.sessionId];
                [WHC_ModelSqlite delete:[FYMessage class] where:whereStr];
//                SVP_DISMISS;
                SVP_ERROR_STATUS(@"已清空聊天记录");
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatContentNotification object:nil];
            }
        }];
        
    }
}



- (void)onSwitchTop:(id)sender {
    UISwitch *swch = sender;
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'",self.contacts.sessionId,[AppModel shareInstance].userInfo.userId];
//    FYContacts *oldModel = [[WHC_ModelSqlite query:[FYContacts class] where:query] firstObject];
    
    self.contacts.isTopChat =  swch.on;
    if (swch.on) {
        self.contacts.isTopTime =  [NSDate date];
    } else {
        self.contacts.isTopTime =  nil;
    }
    [WHC_ModelSqlite update:self.contacts where:query];

}

- (void)onSwitchNotDisturb:(id)sender {
    UISwitch *swch = sender;
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'",self.contacts.sessionId,[AppModel shareInstance].userInfo.userId];
    self.contacts.isNotDisturbSound =  swch.on;
    [WHC_ModelSqlite update:self.contacts where:query];
}


#pragma mark -  移除群组确认
/**
 移除群组确认
 */
-(void)exit_group:(NSString *)userId {
    WEAK_OBJ(weakSelf, self);
    
//    [[AlertViewCus createInstanceWithView:nil] showWithText:@"确认移除该玩家？" button1:@"取消" button2:@"确认" callBack:^(id object) {
//        NSInteger tag = [object integerValue];
//        if(tag == 1)
//            [weakSelf action_exitGroup:userId];
//    }];
}






/**
 删除群成员
 */
//- (void)action_exitGroup:(NSString *)userId {
//
//    BADataEntity *entity = [BADataEntity new];
//    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/delgroupMember"];
//
//    entity.needCache = NO;
//    NSDictionary *parameters = @{
//                                 @"chatGroupId":self.groupId,
//                                 @"userId":userId,
//                                 };
//    entity.parameters = parameters;
//
//    __weak __typeof(self)weakSelf = self;
//    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
//            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
//            SVP_SUCCESS_STATUS(msg);
//            strongSelf.model.page = 1;
//        } else {
//            [[FunctionManager sharedInstance] handleFailResponse:response];
//        }
//    } failureBlock:^(NSError *error) {
//        [[FunctionManager sharedInstance] handleFailResponse:error];
//    } progressBlock:nil];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

