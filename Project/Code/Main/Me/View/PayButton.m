//
//  PayButton.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "PayButton.h"

@interface PayButton(){
    UIImageView *_icon;
    UILabel *_title;
    UIImageView *_botIcon;
    BOOL _state;
}
@end

@implementation PayButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    _state = NO;
}


#pragma mark ----- Layout
- (void)initLayout{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.centerY.equalTo(self);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_icon.mas_right).offset(9);
        make.centerY.equalTo(self);
    }];
    
    [_botIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _icon = [UIImageView new];
    [self addSubview:_icon];
    
    _title = [UILabel new];
    [self addSubview:_title];
    _title.font = [UIFont systemFontOfSize2:14];
    _title.textColor = Color_3;
    
    _botIcon = [UIImageView new];
    [self addSubview:_botIcon];
    _botIcon.image = [UIImage imageNamed:@"pay-arrow"];
    _botIcon.hidden = YES;
    
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = HexColor(@"#D8D8D8").CGColor;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setPayImg:(UIImage *)payImg{
    _icon.image = payImg;
    _payImg = payImg;
}

- (void)setPayTitle:(NSString *)payTitle{
    _title.text = payTitle;
    _payTitle = payTitle;
}

- (void)setSelectIcon:(UIImage *)selectIcon{
    _botIcon.image = selectIcon;
    _selectIcon = selectIcon;
}

#pragma mark setState
- (void)cd_SetState:(BOOL)state{
    self.layer.borderColor = (state)?HexColor(@"#FF4646").CGColor:HexColor(@"#D8D8D8").CGColor;
    _botIcon.hidden = (state)?NO:YES;
}

@end
