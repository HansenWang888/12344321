//
//  CopyViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CopyViewController.h"
#import "CopyCell.h"

@interface CopyViewController ()<UITableViewDelegate,UITableViewDataSource>{
}
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [UITableView normalTable];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WEAK_OBJ(weakSelf, self);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView = tableView;
    SVP_SHOW;
    [self getData];
}

- (void)getData{
    WEAK_OBJ(weakObj, self);
    [NET_REQUEST_MANAGER requestCopyListWithSuccess:^(id object) {
        [weakObj getDataBack:object];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)getDataBack:(NSDictionary *)dict{
    SVP_DISMISS;
    self.tableView.tableHeaderView = [self headView];
    self.dataArray = dict[@"data"];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    CopyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CopyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell initView];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell setIndex:indexPath.row + 1];
    
    NSString *s = dict[@"content"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:s];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [s length])];
    [cell.tLabel setAttributedText:attributedString1];
    
    //cell.tLabel.text = dict[@"content"];
    return cell;
}

-(UIView *)headView{
    float rate = 223/718.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * rate)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"copyBg"];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    return view;
}
@end
