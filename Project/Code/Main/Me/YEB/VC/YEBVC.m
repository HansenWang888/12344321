//
//  YEBVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBVC.h"
#import "YEBTransferVC.h"
#import "YEBHelpVC.h"
#import "YEBInfoVC.h"
#import "YEBNetwork.h"
#import "YEBAccountInfoModel.h"
#import "UIAlertController+dy_extension.h"
#import "UIImage+dy_extension.h"
@interface YEBVC ()<UINavigationControllerDelegate>
@property (nonatomic, strong) YEBAccountInfoModel *model;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *accumulateProfit;
@property (weak, nonatomic) IBOutlet UILabel *weekProfit;
@property (nonatomic, assign) BOOL showNumber;

@end

@implementation YEBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yeb-more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClick)];
    self.showNumber = YES;
    [self loadData];
    [self.totalMoneyLabel setAdjustsFontSizeToFitWidth:YES];

    self.navigationController.navigationBar.backgroundColor = UIColor.clearColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;

    [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self update];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.delegate = nil;
//    self.navigationController.navigationBar.opaque = YES;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}
- (IBAction)seeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //隐藏
        self.showNumber = NO;
        
    } else {
        //显示
        self.showNumber = YES;
    }
    [self update];
    
}


- (void)loadData {
    [SVProgressHUD showWithStatus:nil];
    [[YEBNetwork getAccountInfo] dy_startRequestWithSuccessful:^(id  _Nonnull responseObject, DYNetworkError * _Nonnull error) {
        if (!error) {
            [SVProgressHUD dismiss];
            self.model = [YEBAccountInfoModel mj_objectWithKeyValues:responseObject];
            [self update];
        } else {
            [SVProgressHUD showInfoWithStatus:error.errorMessage];
        }
        
    } failing:^(DYNetworkError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.errorMessage];
    }];
    
}

- (void)update {
    if (self.model == nil) {
        return;
    }
    if (!self.showNumber) {
        self.totalMoneyLabel.text = @"****";
        NSMutableAttributedString *profit = [[NSMutableAttributedString alloc] initWithString:@"转入一万元，30天收益约" attributes:nil];
        [profit appendAttributedString:[[NSAttributedString alloc] initWithString:@"****" attributes:@{NSForegroundColorAttributeName: kThemeTextColor, NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
        [profit appendAttributedString:[[NSAttributedString alloc] initWithString:@"元"]];
        self.profitDescLabel.attributedText = profit.copy;
        self.accumulateProfit.text = @"****";
        self.weekProfit.text = @"****";
    } else {
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.model.m_totalMoney];
        NSMutableAttributedString *profit = [[NSMutableAttributedString alloc] initWithString:@"转入一万元，30天收益约" attributes:nil];
        [profit appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.model.m_thirtyEarnings] attributes:@{NSForegroundColorAttributeName: kThemeTextColor, NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
        [profit appendAttributedString:[[NSAttributedString alloc] initWithString:@"元"]];
        self.profitDescLabel.attributedText = profit.copy;
        self.accumulateProfit.text = [NSString stringWithFormat:@"%.2f",self.model.m_totalEarnings];
        self.weekProfit.text = [NSString stringWithFormat:@"%.2f",self.model.m_sevenDyr];
    }
   
    
}

- (IBAction)transferInBtnClick:(id)sender {
    
    YEBTransferVC *vc = [YEBTransferVC transferInVC];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)transferOutBtnClick:(id)sender {
    
    YEBTransferVC *vc = [YEBTransferVC transferOutVC];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -

#import "YEBInfoVC.h"
- (void)moreBtnClick {
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSDictionary *dict = @{@"资金明细":[YEBInfoVC finalcialInfoVC:self.model],@"收益详情":[YEBInfoVC profitInfoVC:self.model],@"新手帮助":[YEBHelpVC new]};
    [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action1) {
            UIViewController *vc = dict[action1.title];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [vc addAction:action];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
    
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
