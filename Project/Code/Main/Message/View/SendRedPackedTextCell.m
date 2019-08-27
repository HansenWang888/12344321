//
//  SendRedPackedTextCell.m
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRedPackedTextCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRedEnvelopeController.h"

#define kTableViewMarginWidth 20

@interface SendRedPackedTextCell ()



@end

@implementation SendRedPackedTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRedPackedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRedPackedTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kTableViewMarginWidth);
        make.left.mas_equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.right.mas_equalTo(self.mas_right).offset(-kTableViewMarginWidth);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"-";
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.000];
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    _deTextField = [UITextField new];
    //    _deTextField.layer.cornerRadius = width/2;
    //    _deTextField.layer.masksToBounds = YES;
//    _deTextField.backgroundColor = [UIColor redColor];
    _deTextField.font = [UIFont systemFontOfSize2:16];
    _deTextField.keyboardType = UIKeyboardTypeNumberPad;
    _deTextField.textAlignment = NSTextAlignmentRight;
    _deTextField.clearButtonMode = UITextFieldViewModeAlways;
    
//    [_deTextField addTarget:self action:@selector(onNoButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_deTextField];
    
    [_deTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-(10 + kTableViewMarginWidth));
        make.centerY.equalTo(backView.mas_centerY);
        make.left.mas_equalTo(backView.mas_left).offset(90);
        make.height.mas_equalTo(35);
    }];
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"-";
    _unitLabel.font = [UIFont systemFontOfSize2:16];
    _unitLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.000];
    [backView addSubview:_unitLabel];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
    }];

}



- (void)setModel:(id)model {
    //    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



