//
//  YEBTransferSuccessVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferSuccessVC.h"
#import "YEBTranferSuccessCell.h"
#import "YEBTransferSuccessView.h"
#import "YEBTransferModel.h"
#import "NSDate+dy_extension.h"
@interface YEBTransferSuccessVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *datasource;
@property (nonatomic, strong) YEBTransferSuccessView *headerView;
@property (nonatomic, strong) YEBTransferModel *model;
@property (nonatomic, copy) NSString *shiftOutMoney;

@end

@implementation YEBTransferSuccessVC {
    
    ///0 == in 1 == out
    int _vcType;
    
}

+ (instancetype)transferInSuccessVCWithResult:(YEBTransferModel *)model {
    
    YEBTransferSuccessVC *vc = [YEBTransferSuccessVC new];
    vc->_vcType = 0;
    vc.model = model;
    return vc;
}

+ (instancetype)transferOutSuccessVCWithMoney:(NSString *)money {
    
    YEBTransferSuccessVC *vc = [YEBTransferSuccessVC new];
    vc->_vcType = 1;
    vc.shiftOutMoney = money;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupSubView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    
    if (_vcType) {
        
        self.title = @"结果详情";
        self.headerView = [YEBTransferSuccessView successView];
        self.tableView.tableHeaderView = self.headerView;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
        self.headerView.moneyLabel.text = self.shiftOutMoney;
        self.headerView.timeLabel.text = [NSDate dy_timeStampToDateStrWithInterval:NSDate.new.timeIntervalSince1970 * 1000 dataFormat:@"yyyy-MM-dd hh:mm:ss"];
        
    } else {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"YEBTranferSuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        if (self.model) {
            self.datasource = @[
                                @{@"upTitle":[NSString stringWithFormat:@"成功转入:  %@元",self.model.money], @"subTitle":[NSString stringWithFormat:@"操作时间：%@", self.model.createTime]},
                                @{@"upTitle":@"开始计算收益", @"subTitle":[NSString stringWithFormat:@"操作时间：%@",self.model.beginTime]},
                                @{@"upTitle":@"收益到账时间", @"subTitle":[NSString stringWithFormat:@"操作时间：%@", self.model.endTime]}
                                ];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"转入成功" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yeb-transferIn-success"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setEnabled:0];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.rowHeight = 56;

    }
    
}

- (void)doneBtnClick {

    NSMutableArray *arrayM = self.navigationController.viewControllers.mutableCopy;
    [arrayM removeLastObject];
    [arrayM removeLastObject];
    [self.navigationController setViewControllers:arrayM.copy animated:YES];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 168);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YEBTranferSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.datasource[indexPath.row];
    cell.upTitle.text = dict[@"upTitle"];
    cell.subTitle.text = dict[@"subTitle"];
    if (indexPath.row == 0) {
        cell.upLine.hidden = YES;
        cell.bottomLine.backgroundColor = kThemeTextColor;
        cell.upTitle.textColor = kThemeTextColor;
        cell.icon.backgroundColor = kThemeTextColor;
    } else {
        cell.upTitle.textColor = kColorWithHex(0x666666);
        cell.bottomLine.backgroundColor = kColorWithHex(0xe2e2e2);
        cell.upLine.backgroundColor = kColorWithHex(0xe2e2e2);
        cell.icon.backgroundColor = kColorWithHex(0xe2e2e2);
    }
    if (indexPath.row == self.datasource.count - 1) {
        cell.bottomLine.hidden = YES;
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
