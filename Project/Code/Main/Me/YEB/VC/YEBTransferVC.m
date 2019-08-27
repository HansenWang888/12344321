//
//  YEBTransferInVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferVC.h"
#import "YEBTransferSuccessVC.h"
#import "YEBAccountInfoModel.h"
#import "UIAlertController+dy_extension.h"
#import "YEBNetwork.h"
#import "YEBPSWView.h"
#import "YEBTransferModel.h"
#import "SetPayPasswordController.h"
@interface YEBTransferVC ()
@property (weak, nonatomic) IBOutlet UILabel *residueMoneyLabe;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrain;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation YEBTransferVC {
    
    ///0 == in 1 == out
    int _vcType;
    
}

+ (instancetype)transferInVC {
    
    YEBTransferVC *vc = [YEBTransferVC new];
    vc.title = @"转入余额宝";
    vc->_vcType = 0;
    return vc;
}

+ (instancetype)transferOutVC {
    
    YEBTransferVC *vc = [YEBTransferVC new];
    vc.title = @"余额宝转出";
    vc->_vcType = 1;
    return vc;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_vcType == 1) {
    
        self.moneyField.placeholder = [NSString stringWithFormat:@"本次最多可以转出%@元",self.model.m_rollOutMaxMoney];
        [self.confirmBtn setTitle:@"确定转出" forState:UIControlStateNormal];
        self.descLabel.text = @"余额宝的资金若需转出至银行卡，请提前转出至红包账户提现，提现将不收取任何费用。";
        
    } else {
        
        self.moneyField.placeholder = [NSString stringWithFormat:@"建议至少%@元或以上，以便看到效益。",self.model.m_rollInMinMoney];

        
    }
    self.bottomView.hidden = YES;
    self.heightConstrain.constant = 99;
    self.residueMoneyLabe.text = [NSString stringWithFormat:@"%.2f 元",self.model.m_totalMoney];
    [self.moneyField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
       
        self.confirmBtn.enabled = x.length > 0;
        self.confirmBtn.backgroundColor = x.length > 0 ? kThemeTextColor : [UIColor grayColor];
        
    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)update {
    self.residueMoneyLabe.text = [NSString stringWithFormat:@"%.2f 元",self.model.m_totalMoney];
}
- (IBAction)allMoneyBtnClick:(id)sender {
    [self.moneyField becomeFirstResponder];
    if (_vcType == 1) {
        self.moneyField.text = [NSString stringWithFormat:@"%.2f",self.model.m_rollOutMaxMoney.doubleValue];
        return;
    }
    self.moneyField.text = [NSString stringWithFormat:@"%.2f",self.model.m_rollInMaxMoney.doubleValue];;
}


- (IBAction)confirmBtnClick:(id)sender {
    
    double money = self.moneyField.text.doubleValue;
    if (money <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的金额!"];
        return;
    }
    NSString *message = @"请输入密码";
    if (self.model.m_payPassword.length == 0) {
        message = @"请设置密码";
    }
    //跳转到支付密码
    kWeakly(self);
    YEBPSWView *view = [YEBPSWView showView:message completed:^(NSString * _Nonnull pwd) {
        
        [weakself operation:pwd];
        
    }];
    if (self.model.m_payPassword.length > 0) {
        [view showForgotPSW];
    }
    view.forgotBtnClickCallback = ^{
        [weakself.navigationController pushViewController:SetPayPasswordController.new animated:YES];
    };

}

- (void)operation:(NSString *)psw {
    double money = self.moneyField.text.doubleValue;
    [SVProgressHUD showWithStatus:nil];
    if (self->_vcType == 1) {
        
        [[YEBNetwork shiftOutWithMoney:money password:psw] dy_startRequestWithFinished:^(id  _Nonnull responseObject, DYNetworkError * _Nonnull error) {
            if (!error) {
                [SVProgressHUD dismiss];
                self.model.m_totalMoney = self.model.m_totalMoney - money;
                [self update];
                YEBTransferSuccessVC *vc = [YEBTransferSuccessVC transferOutSuccessVCWithMoney:self.moneyField.text];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:error.errorMessage];
            }
        }];
        
    } else {
        [[YEBNetwork shiftInWithMoney:money password:psw] dy_startRequestWithSuccessful:^(id  _Nonnull responseObject, DYNetworkError * _Nonnull error) {
            if (!error) {
                [SVProgressHUD dismiss];
                self.model.m_totalMoney = self.model.m_totalMoney + money;
                [self update];
                YEBTransferModel *model = [YEBTransferModel mj_objectWithKeyValues:responseObject];
                YEBTransferSuccessVC *vc = [YEBTransferSuccessVC transferInSuccessVCWithResult:model];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [SVProgressHUD showErrorWithStatus:error.errorMessage];
            }
        } failing:^(DYNetworkError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
        }];
    }
    
  
    
    
}

@end
