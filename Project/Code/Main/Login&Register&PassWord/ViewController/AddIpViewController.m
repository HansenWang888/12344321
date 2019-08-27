//
//  AddIpViewController.m
//  Project
//
//  Created by fy on 2019/1/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddIpViewController.h"

@interface AddIpViewController ()<UITextFieldDelegate>{
    UITextField *_textField;
}
@end

@implementation AddIpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"添加ip";
    self.view.backgroundColor = BaseColor;
    
    UITextField *view = [[UITextField alloc] init];
    view.backgroundColor = COLOR_X(240, 240, 240);
    view.font = [UIFont systemFontOfSize2:16];
    view.delegate = self;
    view.placeholder = @"请输入地址 如：http://10.10.95.176:8099/";
    view.text = @"http://10.10.95.";
    _textField = view;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(30);
        make.height.equalTo(@44);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_6;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSDictionary *ipDic = [AppModel shareInstance].ipArray[2];
    label.text = [NSString stringWithFormat:@"如：%@",ipDic[@"url"]];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.height.equalTo(@44);
        make.top.equalTo(view.mas_bottom).offset(8);
    }];
    
    UIButton *addBtn = [UIButton new];
    [self.view addSubview:addBtn];
    addBtn.layer.cornerRadius = 8;
    addBtn.layer.masksToBounds = YES;
    addBtn.backgroundColor = MBTNColor;
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn delayEnable];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(label.mas_bottom).offset(38);
        make.height.equalTo(@(44));
    }];
}

-(void)addAction{
    NSString *ip = _textField.text;
    if(ip.length == 0)
        return;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [ud objectForKey:@"ipArray"];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
    if(mArr.count > 1)
        [mArr removeObjectAtIndex:0];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:ip forKey:@"url"];
    NSDictionary *ipDic = [AppModel shareInstance].ipArray[2];
    [dic setObject:@"1" forKey:@"isBeta"];
    [dic setObject:@"YXBwOmFwcA==" forKey:@"baseKey"];
    [mArr addObject:dic];
    [ud setObject:mArr forKey:@"ipArray"];
    [ud synchronize];
    SVP_SUCCESS_STATUS(@"添加ip成功");
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [_textField becomeFirstResponder];
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
