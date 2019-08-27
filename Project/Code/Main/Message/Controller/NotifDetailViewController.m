//
//  NotifDetailViewController.m
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "NotifDetailViewController.h"
#import "NotifMessage.h"
#import "NotifMessageNet.h"

@interface NotifDetailViewController (){///<UITableViewDelegate,UITableViewDataSource>
    UITableView *_tableView;
    UILabel *_title;
    UILabel *_dateTime;
    UIView *_line;
    UILabel *_content;
}

@property (nonatomic, strong) NotifMessage *message;

@end

@implementation NotifDetailViewController

+ (NotifDetailViewController *)detailVc:(id)obj{
    NotifDetailViewController *vc = [[NotifDetailViewController alloc] init];
    vc.message = [NotifMessage mj_objectWithKeyValues:obj];
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
    [self getData];
}


#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
   
}

#pragma mark ----- subView
- (void)initSubviews{
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"消息详情";
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    _tableView.tableHeaderView = view;
    
    _title = [UILabel new];
    [view addSubview:_title];
    _title.font = [UIFont systemFontOfSize2:15];
    _title.textColor = Color_3;
    _title.text = _message.title;
    
    _dateTime = [UILabel new];
    [view addSubview:_dateTime];
    _dateTime.font = [UIFont systemFontOfSize2:12];
    _dateTime.textColor = Color_9;
    _dateTime.text = dateString_stamp(_message.dateline,nil);
    
    _line = [UIView new];
    [view addSubview:_line];
    _line.backgroundColor = HexColor(@"#E8E8E8");
    
    _content = [UILabel new];
    [view addSubview:_content];
    _content.font = [UIFont systemFontOfSize2:12];
    _content.textColor = Color_6;
    _content.text = _message.content;
    
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(view.mas_top).offset(11);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [_dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self->_title.mas_bottom).offset(4);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self->_dateTime.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(1));
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self->_line.mas_bottom).offset(8);
        make.right.equalTo(self.view).offset(-15);
    }];
}

- (void)getData{
//    [NotifMessageNet getNotifDetailObj:@{@"message_id":_message.message_id} Success:^(NSDictionary *info) {
//    } Failure:^(NSError *error) {
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
