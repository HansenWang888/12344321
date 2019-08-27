//
//  AddGroupContactHeadeerViewCell.m
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactHeadeerViewCell.h"
#import <SDWebImage.h>
@interface AddGroupContactHeadeerViewCell()
/** 头像*/
@property (nonatomic, strong) UIImageView *avatarImg;
@end
@implementation AddGroupContactHeadeerViewCell
- (void)setModel:(ContactModel *)model{
    _model = model;
    
     [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"addGroupContactAvatar_icon"]];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.avatarImg];
        [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
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
@end
