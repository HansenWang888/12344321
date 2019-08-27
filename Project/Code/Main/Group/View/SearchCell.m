//
//  SearchCell.m
//  Project
//
//  Created by Mike on 2019/2/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell(){
    
}

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIImageView *sexIcon;
@property (nonatomic,strong) UILabel *count;
@property (nonatomic,strong) UIButton *deleteBtn;

@end

@implementation SearchCell

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
        make.width.height.equalTo(@(50));
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.left.equalTo(self->_icon.mas_right).offset(12);
        
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_name.mas_bottom).offset(8);
        make.left.equalTo(self->_icon.mas_right).offset(8.1);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.backgroundColor = [UIColor whiteColor];
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize2:16];
    _name.textColor = Color_0;
    
    _count = [UILabel new];
    _count.hidden = YES;
    [self.contentView addSubview:_count];
    _count.font = [UIFont systemFontOfSize2:13];
    _count.textColor = Color_6;
    
    UIView *sexBack =[UIView new];
    [self.contentView addSubview:sexBack];
    sexBack.layer.cornerRadius = 7.5;
    sexBack.layer.masksToBounds = YES;
    sexBack.backgroundColor = SexBack;
    [sexBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_name.mas_right).offset(6);
        make.centerY.equalTo(self->_name);
        make.width.height.equalTo(@(15));
    }];
    
    _sexIcon = [UIImageView new];
    [self.contentView addSubview:_sexIcon];
    
    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sexBack);
    }];
    
    
    
    _deleteBtn = [UIButton new];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(selectedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //    _deleteBtn.image = [UIImage imageNamed:@"group_delete"];
    //    _deleteBtn.backgroundColor = [UIColor redColor];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
}

- (void)setObj:(id)obj {
    [_icon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:[obj objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    _name.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"nick"]];
    _count.text = [NSString stringWithFormat:@"账号：%@",[obj objectForKey:@"userId"]];
    NSInteger sex = [[obj objectForKey:@"gender"] integerValue];
    _sexIcon.image = (sex==1)?[UIImage imageNamed:@"female"]:[UIImage imageNamed:@"male"];

    if (self.isSelected) {
         [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"group_selected"] forState:UIControlStateNormal];
    } else {
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    }
}

- (void)selectedBtnAction {
    
    self.isSelected = !self.isSelected;
    
    if (self.isSelected) {
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"group_selected"] forState:UIControlStateNormal];
    } else {
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    }
    
    if (self.selectedBtnBlock) {
        self.selectedBtnBlock(self.isSelected);
    }
}


@end
