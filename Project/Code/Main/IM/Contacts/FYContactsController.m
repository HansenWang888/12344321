//
//  FYContactsController.m
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYContactsController.h"
#import "CreateGroupChatController.h"
#import <QuartzCore/QuartzCore.h>
#import "FYContactsTableView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "FYContacts.h"
#import "FYContactCell.h"
#import "PinYinForObjc.h"
#import "CreateGroupChatController.h"
#import "BANetManager_OC.h"
#import "ChatViewController.h"
#import "CreateGroupChatController.h"
#import "FYMenu.h"
#import "Recharge2ViewController.h"
#import "ShareViewController.h"
#import "BecomeAgentViewController.h"
#import "HelpCenterWebController.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "AgentCenterViewController.h"
#import "CreateGroupChatController.h"
@interface FYContactsController ()<ContactsTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchBar *contactsSearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) FYContactsTableView *contactTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *indexTitles;

@property(nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation FYContactsController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createTableView {
    self.contactTableView = [[FYContactsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-Height_NavBar-Height_TabBar)];
    self.contactTableView.delegate = self;
//    self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
    [self.view addSubview:self.contactTableView];
    
    __weak __typeof(self)weakSelf = self;
    self.contactTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf queryContactsData];
    }];
}

- (void)reloadTableView {
    self.contactTableView = [[FYContactsTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.contactTableView.delegate = self;
//    self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
    [self.view addSubview:self.contactTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    
    [self initData];
    [self queryContactsData];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_r"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIButton *redpiconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [redpiconBtn setImage:[UIImage imageNamed:@"nav_searchBar_icon"] forState:UIControlStateNormal];
    redpiconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [redpiconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redpiconBtn addTarget:self action:@selector(goto_searchBar:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *exItem = [[UIBarButtonItem alloc]initWithCustomView:redpiconBtn];
    UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [info setImage:[UIImage imageNamed:@"nav_add_r"] forState:UIControlStateNormal];
    [info addTarget:self action:@selector(rightBarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
    
    self.navigationItem.rightBarButtonItems = @[infoItem,exItem];
    
    
    self.contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, Height_TabBar, self.view.bounds.size.width, 40)];
    self.contactsSearchBar.delegate = self;
    [self.contactsSearchBar setPlaceholder:@"搜索联系人"];
    self.contactsSearchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.contactsSearchBar contentsController:self];
    
    self.searchDisplayController.active = NO;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    
    [self createTableView];
    [self parsingLocalData];
}

- (void)initData {
    self.dataSource = [[NSMutableArray alloc] init];
    self.indexTitles = [NSMutableArray array];
}

#pragma mark - 下拉菜单
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        __weak __typeof(self)weakSelf = self;
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_recharge"]
                                          title:@"快速充值"
                                         action:^(FYMenuItem *item) {
                                             UIViewController *vc = [[Recharge2ViewController alloc]init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      //                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_share"]
                      //                                          title:@"分享赚钱"
                      //                                         action:^(FYMenuItem *item) {
                      //                                             ShareViewController *vc = [[ShareViewController alloc] init];
                      //                                             vc.hidesBottomBarWhenPushed = YES;
                      //                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                      //                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_agent"]
                                          title:@"代理中心"
                                         action:^(FYMenuItem *item) {
                                             AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_help"]
                                          title:@"帮助中心"
                                         action:^(FYMenuItem *item) {
                                             HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_redp_play"]
                                          title:@"玩法规则"
                                         action:^(FYMenuItem *item) {
                                             WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
                                             vc.navigationItem.title = @"玩法规则";
                                             vc.hidesBottomBarWhenPushed = YES;
                                             //[vc loadWithURL:url];
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_createGroupIcon"]
                                          title:@"创建群组"
                                         action:^(FYMenuItem *item) {
                                             CreateGroupChatController *vc = [[CreateGroupChatController alloc]
                                                                              init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],
                      
                      nil];
    }
    return _menuItems;
}


//导航栏弹出
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    FYMenu *menu = [[FYMenu alloc] initWithItems:self.menuItems];
    menu.menuCornerRadiu = 5;
    menu.showShadow = NO;
    menu.minMenuItemHeight = 48;
    menu.titleColor = [UIColor darkGrayColor];
    menu.menuBackGroundColor = [UIColor whiteColor];
    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
}


/**
 查询通讯录数据
 */
- (void)queryContactsData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/friend/getContact"];
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.contactTableView.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"code"] != nil && [[response objectForKey:@"code"] integerValue] == 0) {
            [strongSelf loadLocalData:[response objectForKey:@"data"]];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.contactTableView.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)loadLocalData:(NSDictionary *)dataDict
{
    [self initData];
    
    NSArray *serviceMembersArray = (NSArray *)[dataDict objectForKey:@"serviceMembers"];
    NSArray *superiorArray = (NSArray *)[dataDict objectForKey:@"superior"];
    
    NSArray *subordinateArray = (NSArray *)[dataDict objectForKey:@"subordinate"];
    
    NSMutableDictionary *myFriendListDictTemp = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *myServiceListDictTemp = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *serviceMembersArrayTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < serviceMembersArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:serviceMembersArray[i]];
        contact.contactsType = 3;
        [serviceMembersArrayTemp addObject:contact];
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
        [myServiceListDictTemp setObject:contact forKey:contact.userId];
    }
    [AppModel shareInstance].myCustomerServiceListDict = [myServiceListDictTemp copy];
    
    NSMutableArray *superiorArrayTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < superiorArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:superiorArray[i]];
        contact.contactsType = 4;
        [superiorArrayTemp addObject:contact];
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
    }
    
    NSMutableArray *subordinateArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < subordinateArray.count; i++) {
        FYContacts *contact = [[FYContacts alloc] initWithPropertiesDictionary:subordinateArray[i]];
        contact.contactsType = 2;
        [subordinateArraytemp addObject:contact];
        [myFriendListDictTemp setObject:contact forKey:contact.sessionId];
    }
    
    [AppModel shareInstance].myFriendListDict = myFriendListDictTemp;
    
    [self.dataSource addObject:serviceMembersArrayTemp];
    [self.dataSource addObject:superiorArrayTemp];
    [self.dataSource addObject:[NSArray array]];
    
    [self.indexTitles addObject:@"官"];
    [self.indexTitles addObject:@"上"];
    if (subordinateArray.count > 0) {
        [self.indexTitles addObject:@"下"];
    }
    
    [self subordinateDataArray:subordinateArraytemp];
}

- (void)parsingLocalData {
    if ([AppModel shareInstance].myFriendListDict.count > 0) {
        
        NSMutableArray *serviceMembersArray = [[NSMutableArray alloc] init];
        NSMutableArray *superiorArray = [[NSMutableArray alloc] init];
        NSMutableArray *subordinateArray = [[NSMutableArray alloc] init];
        
        NSArray *myFriendListArray = [[AppModel shareInstance].myFriendListDict allValues];
        for (NSInteger index = 0; index < myFriendListArray.count; index++) {
            FYContacts *model = (FYContacts *)myFriendListArray[index];
            if (model.contactsType == 2) {
                [subordinateArray addObject:model];
            } else if (model.contactsType == 3) {
                [serviceMembersArray addObject:model];
            } else if (model.contactsType == 4) {
                [superiorArray addObject:model];
            } else {
                NSLog(@"未知类型");
            }
        }
        
        [self.dataSource addObject:serviceMembersArray];
        [self.dataSource addObject:superiorArray];
        [self.dataSource addObject:[NSArray array]];
        [self.dataSource addObject:subordinateArray];
        
        [self.indexTitles addObject:@"官"];
        [self.indexTitles addObject:@"上"];
        if (subordinateArray.count > 0) {
            [self.indexTitles addObject:@"下"];
        }
        
        [self subordinateDataArray:subordinateArray];
    }
}





- (void)subordinateDataArray:(NSMutableArray *)subArray {
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (FYContacts *contact in subArray) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (FYContacts *contact in subArray) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    for (int index = 0; index < sectionArrays.count; index++) {
        NSMutableArray *sectionArray = (NSMutableArray *)sectionArrays[index];
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        
        if (sortedSection.count) {
            [self.dataSource addObject:sortedSection];
            [self.indexTitles addObject:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:index]];
        }
    }
    [self.contactTableView.tableView.mj_header endRefreshing];
    [self.contactTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)sectionIndexTitlesForABELTableView:(FYContactsTableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    } else {
        return self.indexTitles;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else {
        if (section >= self.indexTitles.count) {
            return nil;
        }
        if (section == 0) {
            return @"官方指定客服";
        } else if (section == 1) {
            return @"邀请我的好友";
        } if (section == 2 && [[self.indexTitles objectAtIndex:section] isEqualToString:@"下"]) {
            return @"我邀请的好友";
        }
        return [self.indexTitles objectAtIndex:section];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else{
        return self.dataSource.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return self.searchResults.count;
    }
    else{
        return [[self.dataSource objectAtIndex:section] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    FYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [FYContactCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    
    if (tableView == self.self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        FYContacts *contact = self.searchResults[indexPath.row];
        cell.model = contact;
        
    } else {
        
        FYContacts *contact = (FYContacts *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.model = contact;
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FYContacts *model;
    if (tableView == self.self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        model = self.searchResults[indexPath.row];
        
    } else {
        NSArray *models = [self.dataSource objectAtIndex:indexPath.section];
        if (indexPath.row >= models.count) {
            return;
        }
        model = (FYContacts *)[models objectAtIndex:indexPath.row];
    }
    [self goto_groupChat:model];
}

#pragma mark - goto好友聊天界面
- (void)goto_groupChat:(FYContacts *)model {
    ChatViewController *vc = [ChatViewController privateChatWithModel:model];
    vc.toContactsModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchResults = [[NSMutableArray alloc]init];
    if (self.contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.contactsSearchBar.text]) {
        for (NSArray *section in self.dataSource) {
            for (FYContacts *contact in section)
            {
                if ([ChineseInclude isIncludeChineseInString:contact.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        [self.searchResults addObject:contact];
                    } else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [self.searchResults  addObject:contact];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        if (![self.searchResults containsObject:contact]) {
                            [self.searchResults  addObject:contact];
                        } 
                    }
                } else {
                    NSRange titleResult=[contact.name rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResults  addObject:contact];
                    }
                }
            }
        }
    } else if (self.contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.contactsSearchBar.text]) {
        
        for (NSArray *section in self.dataSource) {
            for (FYContacts *contact in section)
            {
                NSString *tempStr = contact.name;
                NSRange titleResult=[tempStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResults addObject:contact];
                }
                
            }
        }
    }
    
}


// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
//    [UIView animateWithDuration:1.0 animations:^{
//        self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
//        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//
//    }];
    return YES;
}
//-(void) setCorrectFocus {
//    [self.contactsSearchBar becomeFirstResponder];
//}
// 搜索
- (void)goto_searchBar:(UIBarButtonItem *)sender {
 
    self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
    self.searchDisplayController.active = YES;
    [self.contactsSearchBar becomeFirstResponder];
    
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
//    [UIView animateWithDuration:1.0 animations:^{
//        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//
//    }];
//    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜索结束后，恢复原状
//    [UIView animateWithDuration:1.0 animations:^{
//        self.contactTableView.tableView.tableHeaderView = nil;
//        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    }];
    
    if (self.contactsSearchBar.text.length == 0) {
        self.contactTableView.tableView.tableHeaderView = nil;
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.contactTableView.tableView.tableHeaderView = nil;
    self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

@end

