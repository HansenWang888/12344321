//
//  AddGroupSearchView.m
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupSearchView.h"

@interface AddGroupSearchView ()<UITextFieldDelegate>
/** 搜索*/
@property (nonatomic, strong) UITextField *searchTF;
/** 搜索*/
@property (nonatomic, strong) UIButton *searchBtn;

@end
@implementation AddGroupSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchTF];
        [self addSubview:self.searchBtn];
        
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-55);
            make.height.mas_equalTo(35);
        }];
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchTF.mas_centerY);
            make.left.equalTo(self.searchTF.mas_right).offset(10);
            make.width.height.mas_equalTo(35);
        }];
    }
    return self;
}
- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]init];
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderColor = [[UIColor colorWithRed:254.0f/255.0f green:76.0f/255.0f blue:86.0f/255.0f alpha:1.0f] CGColor];
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont boldSystemFontOfSize:14.0];
        _searchTF.placeholder = @"输入用户名或用户ID";
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _searchTF.leftView = leftV;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchTF.returnKeyType = UIReturnKeySearch;
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _searchTF.inputAccessoryView = v;
        // 设置为Yes 即可再有文字数据状态下,可以发送,没有输入状态,置灰,不可点击
        _searchTF.enablesReturnKeyAutomatically = YES;
    }
    return _searchTF;
}
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]init];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"AddGroupSearch_icon"] forState:UIControlStateNormal];
        _searchBtn.noClickInterval = 2;
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        return NO;
    }else{
        if ([self.searchDelegate respondsToSelector:@selector(addGroupSearchTitle:)]) {
            [self.searchDelegate addGroupSearchTitle:textField.text];
        }
        return YES;
    }
}

- (void)searchClick{
    [self endEditing:YES];
    if ([self.searchDelegate respondsToSelector:@selector(addGroupSearchTitle:)]) {
        [self.searchDelegate addGroupSearchTitle:self.searchTF.text];
    }
}
@end
