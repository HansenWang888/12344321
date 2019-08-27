//
//  CreateGroupChatController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CreateGroupChatController.h"
#import "MessageNet.h"
#import "UITextPlaceholderView.h"


@interface CreateGroupChatController ()<UITextViewDelegate>
/**群名*/
@property (nonatomic, strong) UITextField *groupTf;
@property (nonatomic, strong) UILabel *groupNameLab;

/** 群简介*/
@property (nonatomic, strong) UITextPlaceholderView *groupDocTv;
@property (nonatomic, strong) UILabel *groupDocLab;

//创建
@property (nonatomic, strong) UIButton *createBtn;

@property (nonatomic, strong) UILabel *remindLab;
@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CreateGroupChatController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"创建群";
    [self initUI];
}
- (void)initUI{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.groupTf];
    [self.scrollView addSubview:self.groupNameLab];
    [self.scrollView addSubview:self.groupDocTv];
    [self.scrollView addSubview:self.groupDocLab];
    [self.scrollView addSubview:self.createBtn];
    [self.scrollView addSubview:self.remindLab];
    [self.scrollView addSubview:self.numLab];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.groupTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
        make.height.mas_equalTo(40);
    }];
    [self.groupNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupTf.mas_left);
        make.bottom.equalTo(self.groupTf.mas_top).offset(-5);
    }];
    [self.groupDocTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.mas_equalTo(self.groupTf.mas_bottom).offset(50);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
    }];
    [self.groupDocLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupDocTv.mas_left);
        make.bottom.equalTo(self.groupDocTv.mas_top).offset(-5);
    }];
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
        make.top.mas_equalTo(self.view.height * 0.6);
    }];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.createBtn.mas_top).offset(-15);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.groupDocTv.mas_bottom).offset(-5);
        make.right.equalTo(self.groupDocTv.mas_right).offset(-5);
    }];
}
- (UITextField *)groupTf{
    if (!_groupTf){
        _groupTf = [[UITextField alloc]init];
        _groupTf.font = [UIFont systemFontOfSize:12];
        _groupTf.backgroundColor = UIColor.whiteColor;
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
        _groupTf.leftView = v;
        _groupTf.layer.masksToBounds = YES;
        _groupTf.layer.cornerRadius = 4;
        _groupTf.leftViewMode = UITextFieldViewModeAlways;
        _groupTf.placeholder = @"限制为1~12个字符";
    }
    return _groupTf;
}
- (UILabel *)groupNameLab{
    if (!_groupNameLab) {
        _groupNameLab = [[UILabel alloc]init];
        _groupNameLab.text = @"群名称";
        _groupNameLab.font = [UIFont systemFontOfSize:18];
    }
    return _groupNameLab;
}
- (UILabel *)groupDocLab{
    if (!_groupDocLab) {
        _groupDocLab = [[UILabel alloc]init];
        _groupDocLab.text = @"群公告";
        _groupDocLab.font = [UIFont systemFontOfSize:18];
    }
    return _groupDocLab;
}

- (UITextPlaceholderView *)groupDocTv{
    if (!_groupDocTv) {
        _groupDocTv = [[UITextPlaceholderView alloc]init];
        _groupDocTv.placeholder = @"限制1~75个字符";
        _groupDocTv.font = [UIFont systemFontOfSize:14];
        _groupDocTv.textColor = UIColor.blackColor;
        _groupDocTv.layer.masksToBounds = YES;
        _groupDocTv.layer.cornerRadius = 4;
        _groupDocTv.delegate = self;
    }
    return _groupDocTv;
}
- (UIButton *)createBtn{
    if (!_createBtn) {
        _createBtn = [[UIButton alloc]init];
        _createBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_createBtn setTitle:@"创建群" forState:UIControlStateNormal];
       _createBtn.backgroundColor = [UIColor colorWithRed:254.0f/255.0f green:76.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
        
        [_createBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _createBtn.layer.masksToBounds = YES;
        _createBtn.layer.cornerRadius = 5;
        [_createBtn addTarget:self action:@selector(createGroupChatSuccessful) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
- (UILabel *)remindLab{
    if (!_remindLab) {
        _remindLab = [[UILabel alloc]init];
        _remindLab.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        _remindLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16.0f];
        _remindLab.text = @"提示 : 每个用户只允许创建一个群";
    }
    return _remindLab;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.font = [UIFont systemFontOfSize:12];
        _numLab.textColor = UIColor.lightGrayColor;
        _numLab.text = @"0/75";
    }
    return _numLab;
}
//创建群聊
- (void)createGroupChatSuccessful{
     [self.view endEditing:YES];
    if (self.groupTf.text.length == 0) {
        SVP_ERROR_STATUS(@"请输入群名称");
        return ;
    }
    if (self.groupTf.text.length > 12) {
        SVP_ERROR_STATUS(@"群名称输入长度超出");
        return ;
    }
    if (self.groupDocTv.text.length == 0) {
        SVP_ERROR_STATUS(@"请输入群公告");
        return ;
    }
    if (self.groupDocTv.text.length > 75) {
        SVP_ERROR_STATUS(@"群公告输入长度超出");
        return ;
    }
    NSDictionary *parameters = @{@"chatgName":self.groupTf.text,
                                 @"notice":self.groupDocTv.text,
                                 @"chatGroupId": @""
                                 };
    [MESSAGE_NET createGroup:parameters successBlock:^(NSDictionary *success) {
        NSString *msg = [NSString stringWithFormat:@"%@",success[@"alterMsg"]];
        if ([success[@"code"] integerValue] == 0) {

            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadMyMessageGroupList object:nil];
            
            SVP_SUCCESS_STATUS(msg);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SVP_ERROR_STATUS(msg);

        }
    } failureBlock:^(NSError *failure) {
        NSLog(@"%@",failure);
    }];
   
}
- (void)textViewDidChange:(UITextView *)textView{
    
    self.numLab.text = [NSString stringWithFormat:@"%ld/75",self.groupDocTv.text.length];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 75){
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:75];
        
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:75];
         //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.numLab.text = [NSString stringWithFormat:@"%lu/75",self.groupDocTv.text.length];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 75)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }
    return _scrollView;
}
@end
