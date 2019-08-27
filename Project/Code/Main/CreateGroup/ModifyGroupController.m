//
//  ModifyGroupController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ModifyGroupController.h"
#import "UITextPlaceholderView.h"
#import "MessageNet.h"
@interface ModifyGroupController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextPlaceholderView *mentTextView;
@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UIButton *determineBtn;
@property (nonatomic, strong) UILabel *numLab;
@end

@implementation ModifyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    switch (self.type) {
        case ModifyGroupTypeName:
            NSLog(@"名字");
            [self nameInitUI];
            break;
        case ModifyGroupTypeMent:
            [self mentInitUI];
            NSLog(@"公告");
            break;
        default:
            break;
    }
    [self.view addSubview:self.determineBtn];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.determineBtn];
    self.navigationItem.rightBarButtonItem = item;
//    [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(45);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
//    }];
}
- (void)nameInitUI{
    [self.view addSubview:self.nameTf];
    self.nameTf.text = self.text;
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(30);
    }];
}
- (void)mentInitUI{
    [self.view addSubview:self.mentTextView];
    [self.view addSubview:self.numLab];
    self.mentTextView.text = self.text;
    [self.mentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
        make.height.mas_equalTo(120);
        make.top.mas_equalTo(30);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.mentTextView).offset(-5);
    }];
    self.numLab.text = [NSString stringWithFormat:@"%lu/75",(unsigned long)self.text.length];
}
- (void)determineClick{
    switch (self.type) {
        case ModifyGroupTypeName:
            
         {
             if (self.nameTf.text.length == 0) {
                 SVP_ERROR_STATUS(@"群名称不可为空");
                 return;
             }
             if (self.nameTf.text.length > 12) {
                 SVP_ERROR_STATUS(@"群名称长度超出");
                 return;
             }
             NSDictionary *dict = @{
                                    @"id": self.groupID,
                                    @"chatgName": self.nameTf.text,
                                    };
            [MESSAGE_NET groupEditorName:dict successBlock:^(NSDictionary *success) {
                
                if ([success[@"code"] integerValue ] == 0) {
                    if (self.block != nil) {
                        self.block(self.nameTf.text);
                    }
                    SVP_SUCCESS_STATUS(success[@"alterMsg"]);
                     [[NSNotificationCenter defaultCenter]postNotificationName:kReloadMyMessageGroupList object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    SVP_ERROR_STATUS(success[@"alterMsg"]);
                }
            } failureBlock:^(NSError *failure) {
                
            }];
             
         }
            break;
        case ModifyGroupTypeMent:
            
        {
            if (self.mentTextView.text.length == 0) {
                SVP_ERROR_STATUS(@"群公告不可为空");
                return;
            }
            if (self.mentTextView.text.length > 75) {
                SVP_ERROR_STATUS(@"群公告长度超出");
                return;
            }
            NSLog(@"%@",self.mentTextView.text);
            NSDictionary *dict = @{
                                   @"id": self.groupID,
                                   @"notice": self.mentTextView.text
                                   };
            [MESSAGE_NET groupEditorNotice:dict successBlock:^(NSDictionary *success) {
                
                NSLog(@"%@",success);
                if ([success[@"code"] integerValue ] == 0) {
                    if (self.block != nil) {
                        self.block(self.mentTextView.text);
                    }
                    SVP_SUCCESS_STATUS(success[@"alterMsg"]);
                     [[NSNotificationCenter defaultCenter]postNotificationName:kReloadMyMessageGroupList object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    SVP_ERROR_STATUS(success[@"alterMsg"]);
                }
            } failureBlock:^(NSError *failure) {
                
            }];
        }
            break;
        default:
            break;
    }
}
- (UITextField *)nameTf{
    if (!_nameTf) {
        _nameTf = [[UITextField alloc]init];
        _nameTf.font = [UIFont systemFontOfSize:14];
        _nameTf.backgroundColor = UIColor.whiteColor;
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
        _nameTf.leftView = v;
        _nameTf.layer.masksToBounds = YES;
        _nameTf.layer.cornerRadius = 4;
        _nameTf.leftViewMode = UITextFieldViewModeAlways;
        _nameTf.placeholder = @"限制为1~12个字符";
    }
    return _nameTf;
}
- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc]init];
        [_determineBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_determineBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_determineBtn addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineBtn;
}
- (UITextPlaceholderView *)mentTextView{
    if (!_mentTextView) {
        _mentTextView = [[UITextPlaceholderView alloc]init];
        _mentTextView.delegate = self;
        _mentTextView.font = [UIFont systemFontOfSize:14];
        _mentTextView.textColor = UIColor.blackColor;
        _mentTextView.layer.masksToBounds = YES;
        _mentTextView.layer.cornerRadius = 4;
    }
    return _mentTextView;
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
- (void)textViewDidChange:(UITextView *)textView{
    
    self.numLab.text = [NSString stringWithFormat:@"%ld/75",self.mentTextView.text.length];
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
            self.numLab.text = [NSString stringWithFormat:@"%lu/75",self.mentTextView.text.length];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 75)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;
    
}
- (void)dealloc
{
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
