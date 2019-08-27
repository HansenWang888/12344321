//
//  UserCollectionViewCell.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "UserCollectionViewCell.h"

@interface UserCollectionViewCell(){
    UIImageView *_icon;
    UILabel *_name;
}
@end

@implementation UserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap)];
        [_icon addGestureRecognizer:tap];
    }
    return self;
}


#pragma mark ----- Data
- (void)initData{
    
}
- (void)iconTap{
     NSInteger tag = _icon.tag;
    if (self.block != nil) {
        self.block(tag);
    }
}

#pragma mark ----- Layout
- (void)initLayout{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(CD_Scal(42, 667)));
        make.top.equalTo(self.contentView.mas_top).offset(CD_Scal(16, 667));
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_icon.mas_bottom).offset(CD_Scal(6, 667));
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@70);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [self.contentView addSubview:_icon];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = Color_3;
    _name.font = [UIFont systemFontOfSize2:13];
    _name.textAlignment = NSTextAlignmentCenter;
}
- (void)setModel:(GroupInfoUserModel *)model{
    _model = model;
    _name.text = _model.nick;

    if ([_model.avatar hasPrefix:@"http"]) {
        [_icon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:_model.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];

    }else{
        _icon.image = [UIImage imageNamed:_model.avatar];
        if ([_model.avatar isEqualToString:@"group_+"]) {
            _icon.tag = 100000;
        }else if ([_model.avatar isEqualToString:@"group_-"]){
            _icon.tag = 100001;
        }
    }

}


@end
