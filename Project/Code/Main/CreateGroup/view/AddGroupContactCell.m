//
//  AddGroupContactCell.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactCell.h"
#import <SDWebImage.h>
@interface AddGroupContactCell()
/** 头像*/
@property (nonatomic, strong) UIImageView *avatarImg;
/** 昵称*/
@property (nonatomic, strong) UILabel *nickLab;
/** 选择状态*/
@property (nonatomic, strong) UIImageView *imgSelected;

@property (nonatomic, strong) UIView *lineView;
@end
@implementation AddGroupContactCell
- (void)setModel:(ContactModel *)model{
    _model = model;
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    self.nickLab.text = _model.nick;
    if (_model.isSelected) {
        self.imgSelected.image = [UIImage imageNamed:@"AddGroupIcon_s"];
    }else{
        self.imgSelected.image = [UIImage imageNamed:@"AddGroupIcon_n"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.avatarImg];
        [self addSubview:self.nickLab];
        [self addSubview:self.imgSelected];
        [self addSubview:self.lineView];
        [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
        }];
        [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImg.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.imgSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-25);
            make.width.height.mas_equalTo(15);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickLab.mas_left);
            make.right.equalTo(self.imgSelected.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}
- (UIImageView *)avatarImg{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc]init];
        _avatarImg.layer.masksToBounds = YES;
        _avatarImg.layer.cornerRadius = 4;
    }
    return _avatarImg;
}
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = UIColor.blackColor;
        _nickLab.font = [UIFont systemFontOfSize2:16];
    }
    return _nickLab;
}
- (UIImageView *)imgSelected{
    if (!_imgSelected) {
        _imgSelected = [[UIImageView alloc]init];
        
    }
    return _imgSelected;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    }
    return _lineView;
}
@end
