//
//  TopupBarView.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "TopupBarView.h"
#import "PayButton.h"

#define Paytype 10000

@interface TopupBarView(){
    UIView *_inputView;
    UILabel *_iLabel;
}
@end

@implementation TopupBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (TopupBarView *)topupBar{
    return [[TopupBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Layout
- (void)initLayout{
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [_iLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_inputView.mas_left).offset(15);
        make.centerY.equalTo(self->_inputView);
    }];
    
    [_moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_inputView.mas_right).offset(-15);
        make.bottom.top.equalTo(self->_inputView);
        make.width.equalTo(@(SCREEN_WIDTH*0.65));
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _inputView = [UIView new];
    [self addSubview:_inputView];
    _inputView.backgroundColor = [UIColor whiteColor];
    
    _iLabel = [UILabel new];
    [_inputView addSubview:_iLabel];
    _iLabel.text = @"充值金额";
    _iLabel.font = [UIFont systemFontOfSize2:16];
    _iLabel.textColor = Color_0;
    
    UILabel *unit = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [self addSubview:unit];
    unit.font = [UIFont systemFontOfSize2:16];
    unit.text = @"元";
    unit.textAlignment = NSTextAlignmentRight;
    unit.textColor =  Color_0;
    
    _moneyField = [UITextField new];
    [_inputView addSubview:_moneyField];
    _moneyField.font = [UIFont systemFontOfSize2:16];
    _moneyField.placeholder = @"请输入金额";
    _moneyField.rightView = unit;
    _moneyField.rightViewMode = UITextFieldViewModeAlways;
    _moneyField.textAlignment = NSTextAlignmentRight;
    _moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyField.textColor = Color_3;
}

- (NSString *)money{
    return _moneyField.text;
}

@end
