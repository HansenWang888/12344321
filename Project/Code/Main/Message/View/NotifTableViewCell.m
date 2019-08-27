//
//  NotifTableViewCell.m
//  Project
//
//  Created by mini on 2018/8/15.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "NotifTableViewCell.h"
#import "NotifMessage.h"

@interface NotifTableViewCell(){
    UIImageView *_icon;
    UILabel *_title;
    UILabel *_content;
    UILabel *_dateTime;
}
@end

@implementation NotifTableViewCell

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
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        //        make.height.width.equalTo(@(44));
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_icon.mas_top);
        make.left.equalTo(self->_icon.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self->_dateTime.mas_left).offset(-10);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_title.mas_left);
        make.top.equalTo(self->_title.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-22);
    }];
    
    [_dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self->_title.mas_centerY);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    _icon.image = [UIImage imageNamed:@"msg1"];
    
    _dateTime = [UILabel new];
    [self.contentView addSubview:_dateTime];
    _dateTime.font = [UIFont systemFontOfSize2:12];
    _dateTime.textColor = Color_9;
    _dateTime.numberOfLines = 2;
    
    _title = [UILabel new];
    [self.contentView addSubview:_title];
    _title.font = [UIFont systemFontOfSize2:14];
    _title.textColor = Color_3;
    
    _content = [UILabel new];
    [self.contentView addSubview:_content];
    _content.font = [UIFont systemFontOfSize2:12];
    _content.textColor = Color_6;
    _content.numberOfLines = 2;
}

- (void)setObj:(id)obj{
    NotifMessage *item = [NotifMessage mj_objectWithKeyValues:obj];
    //    _icon.image = [UIImage imageNamed:@"msg%ld",item.type];
    NSString *imageName = [NSString stringWithFormat:@"msg%ld",(long)item.type+1];
    _icon.image = [UIImage imageNamed:imageName];
    _title.text = item.title;
    _content.text = item.content;
    _dateTime.text = dateString_stamp(item.dateline,nil);
    //    _icon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:item.i]] placeholderImage:<#(UIImage *)#>
}

@end
