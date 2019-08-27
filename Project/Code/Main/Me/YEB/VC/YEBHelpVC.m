//
//  YEBHelpVC.m
//  Project
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBHelpVC.h"
#import "UIImage+dy_extension.h"
@interface YEBHelpVC ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy) NSArray *datasource;

@end

@implementation YEBHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新手帮助";
    [self setupSubView];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:0 target:self action:@selector(backBtnClick)];
    // Do any additional setup after loading the view from its nib.

}


- (void)setupSubView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.datasource = @[@"余额宝的收益如何计算？",
                        @"余额宝的收益如何计算？",
                        @"余额宝的收益如何计算？",
                        @"余额宝的收益如何计算？"];
    self.tableView.tableFooterView = [UIView new];
    
    

}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];

}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.datasource[indexPath.row];
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
