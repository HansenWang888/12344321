//
//  DepositOrderController.m
//  ProjectXZHB
//
//  Created by Mike on 2019/3/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "DepositOrderController.h"
#import "UIImageView+WebCache.h"

@implementation ViewCell

-(instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = COLOR_X(80, 80, 80);
        titleLabel.font = [UIFont vvFontOfSize:16];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@90);
        }];
        self.titleLabel = titleLabel;
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rechargeInput1"] stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
        [self addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.right.equalTo(self);
        }];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont vvFontOfSize:16];
        [bgView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(bgView);
            make.right.equalTo(bgView).offset(-53);
        }];
        self.textLabel = textLabel;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"(复制)" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bgView);
            make.right.equalTo(bgView).offset(-5);
            make.width.equalTo(@48);
        }];
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)btnAction{
    if(self.copyBlock){
        self.copyBlock(self.textLabel.text);
    }
}
@end

@interface DepositOrderController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DepositOrderController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch ([_infoDic.type.value integerValue]) {
        case RechargeType_GFWX:
            self.title = @"微信支付";
            break;
        case RechargeType_GFZB:
            self.title = @"支付宝支付";
            break;
        case RechargeType_GFBC:
            self.title = @"银行卡支付";
            break;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view addSubview:self.scrollView];
    [self initUI];
}

#pragma mark - scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        NSInteger height = CGRectGetHeight(self.view.frame) + 1;
        if(height < 700)
            height = 700;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), height); // 设置UIScrollView的滚动范围
//        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        // 隐藏水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.bounces = NO; // 去掉弹簧效果
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor blueColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(CD_Scal(25, 812));
        make.right.mas_equalTo(self.view.mas_right).offset(-CD_Scal(25, 812));
        make.height.mas_equalTo(CGRectGetHeight(self.view.frame)+110);
    }];
    
    CGFloat corRadius = 8;
    
    if ([self.infoDic.type.value integerValue]!=RechargeType_GFBC) {
        UIImageView* iv = [[UIImageView alloc]init];
        [backView addSubview:iv];
        iv.userInteractionEnabled = YES;
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView).offset(35);
            make.left.mas_equalTo(backView.mas_left);
            make.right.mas_equalTo(backView.mas_right);
            make.height.equalTo(@510);
        }];
        [iv sd_setImageWithURL:[NSURL URLWithString:self.infoDic.bankNum] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
        
        
        UIButton *submitBtn = [[UIButton alloc] init];
        [submitBtn setTitle:@"提交信息" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = corRadius;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = [UIColor colorWithRed:0.992 green:0.612 blue:0.424 alpha:1.000];
        [backView addSubview:submitBtn];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iv.mas_bottom).offset(CD_Scal(20, 812));
            make.left.mas_equalTo(backView.mas_left).offset(CD_Scal(25, 812));
            make.right.mas_equalTo(backView.mas_right).offset(-CD_Scal(25, 812));
            make.height.mas_equalTo(44);
        }];
        return;
    }
    UIView *iconView = [self headIcon];
    [backView addSubview:iconView];
    

    UILabel *headTitleLabel = [[UILabel alloc] init];
    headTitleLabel.text = @"尊敬的客户您好，您的存款订单已生成，请记录以下官方账户信息以及存款金额，请尽快登录您的网上银行/手机银行/支付宝进行转账，转账完成以后请保留银行回执，以便确认转账信息；";
    headTitleLabel.font = [UIFont systemFontOfSize:15];
    headTitleLabel.textColor = [UIColor darkGrayColor];
    headTitleLabel.numberOfLines = 0;
    headTitleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:headTitleLabel];

    [headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).offset(90);
        make.left.mas_equalTo(backView.mas_left);
        make.right.mas_equalTo(backView.mas_right);
    }];


    UILabel *moneyTitLabel = [[UILabel alloc] init];
    moneyTitLabel.text = @"存款金额：";
    moneyTitLabel.font = [UIFont systemFontOfSize:16];
    moneyTitLabel.textColor = [UIColor darkGrayColor];
    moneyTitLabel.numberOfLines = 0;
    moneyTitLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:moneyTitLabel];

    [moneyTitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headTitleLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(backView.mas_centerX);
    }];

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = self.money;
    moneyLabel.font = [UIFont systemFontOfSize:16];
    moneyLabel.textColor = COLOR_X(255, 80, 80);
    moneyLabel.numberOfLines = 0;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyTitLabel.mas_right);
        make.centerY.mas_equalTo(moneyTitLabel.mas_centerY);
    }];
    

    WEAK_OBJ(weakSelf, self);
    ViewCell *cell1 = [[ViewCell alloc] init];
    [backView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(moneyTitLabel.mas_bottom).offset(15);
        make.height.equalTo(@48);
    }];
    cell1.titleLabel.text = @"收款银行";
    if(![self.infoDic.bank.name isKindOfClass:[NSNull class]])
        cell1.textLabel.text = self.infoDic.bank.name;
    cell1.copyBlock = ^(id object) {
        [weakSelf copyString:object];
    };
    
    ViewCell *cell2 = [[ViewCell alloc] init];
    [backView addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(cell1.mas_bottom).offset(10);
        make.height.equalTo(@48);
    }];
    cell2.titleLabel.text = @"收款人";
    cell2.textLabel.text = self.infoDic.payeeName;
    cell2.copyBlock = ^(id object) {
        [weakSelf copyString:object];
    };
    
    ViewCell *cell3 = [[ViewCell alloc] init];
    [backView addSubview:cell3];
    [cell3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(cell2.mas_bottom).offset(10);
        make.height.equalTo(@48);
    }];
    cell3.titleLabel.text = @"收款开户行";
    cell3.textLabel.text = self.infoDic.bankAddress;
    cell3.copyBlock = ^(id object) {
        [weakSelf copyString:object];
    };
    
    ViewCell *cell4 = [[ViewCell alloc] init];
    [backView addSubview:cell4];
    [cell4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(cell3.mas_bottom).offset(10);
        make.height.equalTo(@48);
    }];
    cell4.titleLabel.text = @"收款账号";
    cell4.textLabel.text = self.infoDic.bankNum;
    cell4.copyBlock = ^(id object) {
        [weakSelf copyString:object];
    };
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"提交信息" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = corRadius;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor colorWithRed:0.992 green:0.612 blue:0.424 alpha:1.000];
    [backView addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell4.mas_bottom).offset(CD_Scal(20, 812));
        make.left.mas_equalTo(backView.mas_left).offset(CD_Scal(25, 812));
        make.right.mas_equalTo(backView.mas_right).offset(-CD_Scal(25, 812));
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 提交信息
- (void)submitAction:(UIButton *)sender {
    WEAK_OBJ(weakSelf, self);
    SVP_SHOW;
    [NET_REQUEST_MANAGER submitOrderRechargeInfoWithId:self.infoDic.itemId money:self.money name:self.remark success:^(id object) {
        SVP_DISMISS;
        [weakSelf submitActionBack];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)submitActionBack{
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    WEAK_OBJ(weakSelf, self);
    [view showWithText:@"信息已提交，记得赶紧完成存款哦" button1:@"继续存款" button2:@"返回主页" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        NSArray *arr = weakSelf.navigationController.viewControllers;
        if(tag == 1){
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if(arr.count == 3){
                [weakSelf.navigationController popToViewController:arr[arr.count - 2] animated:YES];
            }
            else if(arr.count > 3)
                [weakSelf.navigationController popToViewController:arr[arr.count - 3] animated:YES];
            else
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - 复制方法
- (void)copyString:(NSString *)string {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = string;
    SVP_SUCCESS_STATUS(@"复制成功");
}

-(UIView *)headIcon{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"recharget%@",self.infoDic.type.value]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 50);
    
    return imgView;
}

@end
