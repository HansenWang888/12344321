//
//  CharUserInfoCell.m
//  Project
//
//  Created by Mike on 2019/1/7.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CharUserInfoCell.h"

@interface CharUserInfoCell()

// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 昵称
@property (nonatomic,strong) UILabel *nameLabel;
// 性别
@property (nonatomic,strong) UIImageView *genderLabel;
// 用户ID
@property (nonatomic,strong) UILabel *uesrIdLabel;


@end

@implementation CharUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    CharUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CharUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    _headImageView = [UIImageView new];
    [self.contentView addSubview:_headImageView];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize2:16];
    _nameLabel.textColor = Color_0;
    
    _uesrIdLabel = [UILabel new];
    [self.contentView addSubview:_uesrIdLabel];
    _uesrIdLabel.font = [UIFont systemFontOfSize2:13];
    _uesrIdLabel.textColor = Color_6;
    
    UIView *sexBack =[UIView new];
    [self.contentView addSubview:sexBack];
    sexBack.layer.cornerRadius = 7.5;
    sexBack.layer.masksToBounds = YES;
    sexBack.backgroundColor = SexBack;
    [sexBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_nameLabel.mas_right).offset(6);
        make.centerY.equalTo(self->_nameLabel);
        make.width.height.equalTo(@(15));
    }];
    
    _genderLabel = [UIImageView new];
    [self.contentView addSubview:_genderLabel];
    
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sexBack);
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(50));
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.left.equalTo(self->_headImageView.mas_right).offset(8.1);
    }];
    
    [_uesrIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_nameLabel.mas_bottom).offset(8);
        make.left.equalTo(self->_headImageView.mas_right).offset(8.1);
    }];
    
}

- (void)setModel:(id)model {
    
    [_headImageView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    _nameLabel.text = model[@"nick"];
    NSInteger sex = [model[@"gender"] integerValue];
    _genderLabel.image = (sex==1)?[UIImage imageNamed:@"female"]:[UIImage imageNamed:@"male"];
    _uesrIdLabel.text = [NSString stringWithFormat:@"账号：%@", model[@"userId"]];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    _headImageView.frame = CGRectMake(15, 30, 20, 20);
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
