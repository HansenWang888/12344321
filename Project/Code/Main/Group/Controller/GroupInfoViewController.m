//
//  GroupInfoViewController.m
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "ModifyGroupController.h"
#import "AddGroupContactController.h"
#import "MessageItem.h"
#import "GroupNet.h"
#import "GroupHeadView.h"
#import "AllUserViewController.h"
#import "BANetManager_OC.h"
#import "RCDBaseSettingTableViewCell.h"
#import "AddMemberController.h"
#import "NSString+Size.h"
#import "SqliteManage.h"
#import "ImageDetailViewController.h"

static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";

@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GroupNet *model;
@property (nonatomic, strong) GroupHeadView *headView;
@property (nonatomic, assign) BOOL enableNotification;
//@property (nonatomic, strong)  RCConversation *currentConversation;
@property (nonatomic, strong) MessageItem *groupInfo;

@property (nonatomic, strong) UILabel *value;

@property (nonatomic, strong) UILabel *right;
@end


@implementation GroupInfoViewController

+ (GroupInfoViewController *)groupVc:(id)obj{
    GroupInfoViewController *vc = [[GroupInfoViewController alloc]init];
    vc.groupInfo = obj;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initData];
    [self initSubviews];
//    [self getGroupUsersData];
    [self initLayout];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addGroupContact) name:@"addGroupContact" object:nil];
}
- (void)addGroupContact{
    [self getGroupUsersData];
}
#pragma mark ----- Data
- (void)initData {
    _model = [GroupNet new];
    _model.groupNum = self.groupInfo.groupNum;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
    [self getGroupUsersData];
}

- (void)updateGroupUser {
    __weak __typeof(self)weakSelf = self;
    
    if ([self.groupInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId] ) { //群主
        _headView = [GroupHeadView headViewWithModel:_model item:self.groupInfo  isGroupLord:YES];
    } else {//非群主
        _headView = [GroupHeadView headViewWithModel:_model item:self.groupInfo isGroupLord:NO];
       
    }
    _headView.click = ^(NSInteger index) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (index >= 100000) {
            if (strongSelf.groupInfo.officeFlag) {
                if (index == 100000) {
                    // 添加群员
                    [strongSelf addGroupMember];
                }else{
                    // 删减群员
                    [strongSelf deleteGroupMember];
                }
            }else{//自建群
                if (index == 100000) {
                    [strongSelf addGroupMemberOfficeFlag];
                }else{
                    [strongSelf deleteGroupMemberOfficeFlag];
                    
                }
            }

        }else{
             [strongSelf gotoAllGroupUsers];

        }
        
    };
    _tableView.tableHeaderView = _headView;
    
}

/**
 自建群添加群成员
 */
- (void)addGroupMemberOfficeFlag{
    
    AddGroupContactController *add = [[AddGroupContactController alloc]init];
    add.groupId = self.groupInfo.groupId;
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

/**
 自建群,群主删减群员
 */
- (void)deleteGroupMemberOfficeFlag{
    AddGroupContactController *vc = [[AddGroupContactController alloc]init];
    vc.groupId = self.groupInfo.groupId;
    vc.type = ControllerType_delete;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addGroupMember {
    AddMemberController *vc = [[AddMemberController alloc] init];
    vc.title = @"添加群成员";
    vc.groupId = self.groupInfo.groupId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
    
    
- (void)deleteGroupMember {
    AllUserViewController *vc = [AllUserViewController allUser:_model];
    vc.title = @"删除成员";
    vc.groupId = self.groupInfo.groupId;
    vc.isDelete = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 退出群组确认
 */
-(void)exit_group {
    WEAK_OBJ(weakSelf, self);
    
    NSString *message = [self.groupInfo.userId isEqualToString:AppModel.shareInstance.userInfo.userId] ? @"是否解散该群？" : @"是否退出该群？";
    
    [[AlertViewCus createInstanceWithView:nil] showWithText:message button1:@"取消" button2:@"退出" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1)
            [weakSelf action_exitGroup];
    }];
}

/**
 退出群组请求  退群
 */
- (void)action_exitGroup {
    //是否是自建群
    BOOL isOfficeFlag = self.groupInfo.officeFlag;
    //是否是群主
    BOOL isGroupManager = [self.groupInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId];
    
    SVP_SHOW;
    [[GroupNet alloc] dissolveGroupWithID:self.groupInfo.groupId isOfficeFlag:isOfficeFlag isGroupManager:isGroupManager successBlock:^(NSDictionary *response) {
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
            [SqliteManage removeGroupSql:self.groupInfo.groupId];
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
            SVP_SUCCESS_STATUS(msg);
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


#pragma mark - Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);

        if (@available(iOS 11.0, *)) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view);
        }
        
    }];
}

#pragma mark - subView
- (void)initSubviews{
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"群信息";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 50;
    _tableView.sectionFooterHeight = 8.0f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = TBSeparaColor;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    
    UIButton *exitBtn = [[UIButton alloc] init];
    [footView addSubview:exitBtn];
    
    exitBtn.layer.cornerRadius = 8;
    exitBtn.layer.masksToBounds = YES;
    exitBtn.backgroundColor = MBTNColor;
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    if ([self.groupInfo.userId isEqualToString:AppModel.shareInstance.userInfo.userId]) {
        [exitBtn setTitle:@"解散群" forState:UIControlStateNormal];
    } else {
        [exitBtn setTitle:@"退出群" forState:UIControlStateNormal];
    }
    [exitBtn addTarget:self action:@selector(exit_group) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footView.mas_centerY);
        make.centerX.equalTo(footView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -30*2, 44));
    }];
    
    _tableView.tableFooterView = footView;
    
}

#pragma mark - 获取群成员
- (void)getGroupUsersData {

    __weak __typeof(self)weakSelf = self;
    [_model queryGroupUserGroupId:_groupInfo.groupId successBlock:^(NSDictionary *info) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([info objectForKey:@"code"] && [[info objectForKey:@"code"] integerValue] == 0) {
            [strongSelf updateGroupUser];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:info];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.groupInfo.officeFlag){
        return (section == 0)?5:1;
    }else{
        return (section == 0)?2:1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        CGFloat height =  [_groupInfo.notice heightWithFont:[UIFont systemFontOfSize2:15] constrainedToWidth:SCREEN_WIDTH-(85+15)];

        return height + 15*2;
    } else if (indexPath.row == 2) {
        CGFloat height =  [_groupInfo.know heightWithFont:[UIFont systemFontOfSize2:15] constrainedToWidth:SCREEN_WIDTH-(85+15)];
        return height + 15*2;
    }
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    RCDBaseSettingTableViewCell *cellee = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cellee) {
        cellee = [[RCDBaseSettingTableViewCell alloc] init];
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"group"];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.font = [UIFont systemFontOfSize2:15];
                label.text = @"群名称";
                label.textColor = Color_0;
                cell.accessoryType = 0;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
//                    make.height.equalTo(@(48));
                    make.top.bottom.equalTo(cell.contentView);
                }];
                
                UILabel *value = [UILabel new];
                self.value = value;
                [cell.contentView addSubview:value];
                value.textColor = Color_6;
                value.text = self.groupInfo.chatgName;
                value.font = [UIFont systemFontOfSize2:15];
               
                ///判断是否是群主
                if (self.groupInfo.userId == [AppModel shareInstance].userInfo.userId && !self.groupInfo.officeFlag) {
                    UIImageView *backIcon = [[UIImageView alloc]init];
                    backIcon.image = [UIImage imageNamed:@"backIcon"];
                    [cell.contentView addSubview:backIcon];
                    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.right.mas_equalTo(-5);
                        make.width.height.mas_equalTo(20);
                    }];
                    [value mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(backIcon.mas_left).offset(-10);
                        make.centerY.equalTo(cell.contentView);
                    }];
                }else{
                    [value mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.contentView.mas_right).offset(-15);
                        make.centerY.equalTo(cell.contentView);
                    }];
                }
            } else if (indexPath.row == 1){
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.font = [UIFont systemFontOfSize2:15];
                label.text = @"群公告";
                label.textColor = Color_0;
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.top.bottom.equalTo(cell.contentView);
                }];
                
                UILabel *right = [UILabel new];
                [cell.contentView addSubview:right];
                right.font = [UIFont systemFontOfSize2:15];
                self.right = right;
                right.text = self.groupInfo.notice;
                right.textColor = Color_6;
                right.textAlignment = NSTextAlignmentRight;
                right.numberOfLines = 0;
                CGFloat height =  [_groupInfo.notice heightWithFont:[UIFont systemFontOfSize2:15] constrainedToWidth:SCREEN_WIDTH-(85+15)];
                if (height > 20) {
                    right.textAlignment = NSTextAlignmentLeft;
                } else {
                    right.textAlignment = NSTextAlignmentRight;
                }
                
              
                ///判断是否是群主
                if (self.groupInfo.userId == [AppModel shareInstance].userInfo.userId && !self.groupInfo.officeFlag) {
                    UIImageView *backIcon = [[UIImageView alloc]init];
                    backIcon.image = [UIImage imageNamed:@"backIcon"];
                    [cell.contentView addSubview:backIcon];
                    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.right.mas_equalTo(-5);
                        make.width.height.mas_equalTo(20);
                    }];
                    [right mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(backIcon.mas_left).offset(-10);
                        make.centerY.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView.mas_left).offset(85);
                    }];
                }else{
                    [right mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.contentView.mas_right).offset(-15);
                        make.left.equalTo(cell.contentView.mas_left).offset(85);
                        make.centerY.equalTo(cell.contentView);
                    }];
                }
            } else if (indexPath.row == 2 && self.groupInfo.officeFlag){
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.font = [UIFont systemFontOfSize2:15];
                label.text = @"须知";
                label.textColor = Color_0;
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(15);
                }];
                
                UILabel *bot = [UILabel new];
                [cell.contentView addSubview:bot];
                bot.font = [UIFont systemFontOfSize2:15];
                bot.text = _groupInfo.know;
                bot.numberOfLines = 0;
                
                CGFloat height =  [_groupInfo.know heightWithFont:[UIFont systemFontOfSize2:15] constrainedToWidth:SCREEN_WIDTH-(85+15)];
                if (height > 20) {
                    bot.textAlignment = NSTextAlignmentLeft;
                } else {
                    bot.textAlignment = NSTextAlignmentRight;
                }
                bot.textColor = Color_6;

                [bot mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-15);
                    make.left.equalTo(cell.contentView.mas_left).offset(85);
                    make.centerY.equalTo(label.mas_centerY);
                }];
            }
            
            else if ((indexPath.row == 3 || indexPath.row == 4) && self.groupInfo.officeFlag){
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.font = [UIFont systemFontOfSize2:16];
                if(indexPath.row == 3)
                    label.text = @"群规";
                else
                    label.text = @"玩法";
                label.textColor = Color_0;

                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.centerY.equalTo(cell.contentView);
                }];
                
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangdajing"]];
                [cell.contentView addSubview:imgView];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@18);
                    make.right.equalTo(cell.contentView.mas_right).offset(-17);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                }];
                
                UILabel *right = [UILabel new];
                [cell.contentView addSubview:right];
                right.font = [UIFont systemFontOfSize2:15];
                if(indexPath.row == 3)
                    right.text = self.groupInfo.rule;
                else if(indexPath.row == 4)
                    right.text = self.groupInfo.howplay;
                right.textColor = Color_6;
                right.textAlignment = NSTextAlignmentRight;
                
                [right mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-40);
                    make.left.equalTo(cell.contentView.mas_left).offset(85);
                    make.centerY.equalTo(label.mas_centerY);
                }];
            }
        } else if (indexPath.section == 1) {

            switch (indexPath.row) {
                case 0: {
                    [cellee setCellStyle:SwitchStyle];
                    cellee.leftLabel.text = @"消息免打扰";
                    cellee.leftLabel.font = [UIFont systemFontOfSize2:15];
                    cellee.switchButton.hidden = NO;
 
                    NSString *switchKeyStr = [NSString stringWithFormat:@"%@-%@", [AppModel shareInstance].userInfo.userId,_groupInfo.groupId];
                    // 读取
                    BOOL isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
                    
                    cellee.switchButton.on = isSwitch;
                    
                    [cellee.switchButton addTarget:self
                                            action:@selector(clickNotificationBtn:)
                                  forControlEvents:UIControlEventValueChanged];
                }
                    break;
                    
                default:
                    break;
            }
            return cellee;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && (indexPath.row == 3 || indexPath.row == 4)){
        NSString *url = nil;
        if(indexPath.row == 3)
            url = self.groupInfo.ruleImg;
        else if(indexPath.row == 4)
            url = self.groupInfo.howplayImg;
        ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
        vc.imageUrl = url;
        vc.hiddenNavBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 &&( indexPath.row == 0 || indexPath.row == 1)){
        
        ///判断是否是群主,是否自建群
        if (self.groupInfo.userId == [AppModel shareInstance].userInfo.userId && !self.groupInfo.officeFlag) {
            ModifyGroupController *mgvc = [[ModifyGroupController alloc]init];
            mgvc.groupID = self.groupInfo.groupId;
            __weak __typeof(self)weakSelf = self;
            if (indexPath.row == 0){//修改群名称
                mgvc.navigationItem.title = @"修改群名称";
                mgvc.type = ModifyGroupTypeName;
                mgvc.text = self.groupInfo.chatgName;
                mgvc.block = ^(NSString * _Nonnull text) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.groupInfo.chatgName = text;
                    if (strongSelf.block != nil) {
                        strongSelf.block(text);
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakSelf.navigationController pushViewController:mgvc animated:YES];
            }else if (indexPath.row == 1){//修改群公告
                mgvc.navigationItem.title = @"修改群公告";
                mgvc.type = ModifyGroupTypeMent;
                mgvc.text = self.groupInfo.notice;
                mgvc.block = ^(NSString * _Nonnull text) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    NSLog(@"%@",text);
                    strongSelf.groupInfo.notice = text;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                mgvc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:mgvc animated:YES];
            }
                
        }
    }
}

#pragma mark - gotoAllGroupUsers
- (void)gotoAllGroupUsers {
    AllUserViewController *vc = [AllUserViewController allUser:_model];
    vc.title = @"所有成员";
    vc.groupId = self.groupInfo.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickNotificationBtn:(id)sender {
    UISwitch *swch = sender;
    NSString *switchKeyStr = [NSString stringWithFormat:@"%@-%@", [AppModel shareInstance].userInfo.userId,_groupInfo.groupId];
    //保存
    [[NSUserDefaults standardUserDefaults] setBool:swch.on forKey:switchKeyStr];
}

@end
