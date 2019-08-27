//
//  MemberCell.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MemberCell.h"

@interface MemberCell(){
    
}


@end

@implementation MemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    [_itemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@50);
    }];

    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_itemIcon.mas_right).offset(14);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _itemIcon = [UIImageView new];
    [self.contentView addSubview:_itemIcon];
    
    _itemIcon.contentMode = UIViewContentModeCenter;
    _itemLabel = [UILabel new];
    _itemLabel.font = [UIFont systemFontOfSize2:16];
    _itemLabel.textColor = Color_0;
    [self.contentView addSubview:_itemLabel];
    
    _rightLabel = [UILabel new];
    _rightLabel.font = [UIFont systemFontOfSize2:14];
    _rightLabel.textColor = Color_6;
    [self.contentView addSubview:_rightLabel];
    
    
    UIImageView *rightArrowImage = [[UIImageView alloc] init];
    rightArrowImage.image = [UIImage imageNamed:@"common_right_arrow"];
    [self.contentView addSubview:rightArrowImage];
    _rightArrowImage = rightArrowImage;
    
    [rightArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
}
@end
