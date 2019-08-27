//
//  ContactCell.m
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYContactCell.h"

@interface FYContactCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headImage;

@end



@implementation FYContactCell

- (void)awakeFromNib {
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    FYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FYContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    headImage.image = [UIImage imageNamed:@"imageName"];
    [self addSubview:headImage];
    _headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.equalTo(@(40));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(headImage.mas_right).offset(20);
    }];
}

- (void)setModel:(FYContacts *)model {
    _model = model;
    
     [self.headImage cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"msg3"]];
    self.nameLabel.text = model.nick;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
