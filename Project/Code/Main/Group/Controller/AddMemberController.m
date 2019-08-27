//
//  AddMemberController.m
//  Project
//
//  Created by Mike on 2019/2/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddMemberController.h"
#import "BANetManager_OC.h"
#import "SearchCell.h"

#define TopViewHeight 52

@interface AddMemberController ()<UITableViewDataSource, UITableViewDelegate>

//
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) id userInfo;
@property (nonatomic,assign) BOOL isSelected;


@end

@implementation AddMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ininUI];
    [self.view addSubview:self.tableView];
    [self initNotif];
}

- (void)ininUI {
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.layer.cornerRadius = 3;
    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    doneButton.frame = CGRectMake(0, 0, 53, 32);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(onDoneButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    
    
    UIView *topView = [[UIView alloc] init];
    //    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(TopViewHeight);
    }];
    
    
    
    
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"group_search"];
//    searchImage.backgroundColor = [UIColor grayColor];
    [topView addSubview:searchImage];
    
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.placeholder = @"搜索";
    searchTextField.keyboardType = UIKeyboardTypeNumberPad;
    [topView addSubview:searchTextField];
    _searchTextField = searchTextField;
    
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(searchImage.mas_right).offset(10);
        make.right.mas_equalTo(topView.mas_right).offset(-20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.906 green:0.906 blue:0.906 alpha:1.000];
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    
    
}


- (void)onDoneButton {
    if (self.isSelected) {
        [self addMember];
    } else {
         SVP_ERROR_STATUS(@"请选择成员");
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight + 2, SCREEN_WIDTH, SCREEN_HEIGHT - Height_NavBar -TopViewHeight -1) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = TBSeparaColor;
    }
    
    return _tableView;
}






/**
 添加群成员
 */
- (void)addMember {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/addgroupMember"];

    NSMutableArray *userIdArray = [NSMutableArray array];
    [userIdArray addObject: self.searchTextField.text];
    
    entity.needCache = NO;
    NSDictionary *parameters = @{
                                 @"groupId":self.groupId,
                                 @"userIds": userIdArray
                                 };
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
            SVP_SUCCESS_STATUS(msg);
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}



- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)text {
    UITextField *textField = (UITextField *)text.object;
    if (textField.text.length == 0) {
        return;
    }
    NSString *num = @"^[0-9]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    BOOL isNum = [pre evaluateWithObject:textField.text];
    if (isNum) {
         [self getUserInfoData];
    }
}


// 查询群成员
- (void)getUserInfoData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,@"social/skChatGroup/select"];
    NSDictionary *parameters = @{
                                 @"id":[NSString stringWithFormat:@"%@",self.searchTextField.text]
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SVP_DISMISS;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            strongSelf.userInfo = response[@"data"];
            [strongSelf.tableView reloadData];
        } else {
             strongSelf.userInfo = nil;
            [strongSelf.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        SVP_DISMISS;
        [[FunctionManager sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.userInfo != nil && self.userInfo != [NSNull null]) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[SearchCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.obj = self.userInfo;
    __weak __typeof(self)weakSelf = self;
    cell.selectedBtnBlock = ^(BOOL isSelected) {
        self.isSelected = isSelected;
        return;
    };
    
    return cell;
}





@end
