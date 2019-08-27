//
//  SendRPTextCell.m
//  ProjectXZHB
//
//  Created by Mike on 2019/3/14.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRPTextCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRedEnvelopeController.h"


@interface SendRPTextCell ()



@end

@implementation SendRPTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRPTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRPTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"-";
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = Color_0;
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
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
    [self.contentView addSubview:_deTextField];
    
    [_deTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 35));
    }];
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"-";
    _unitLabel.font = [UIFont systemFontOfSize2:16];
    _unitLabel.textColor = Color_0;
    [self.contentView addSubview:_unitLabel];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1.000];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@(0.8));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setIsUpdateTextField:(BOOL)isUpdateTextField {
    _isUpdateTextField = isUpdateTextField;
    if (isUpdateTextField) {
        _deTextField.clearButtonMode = UITextFieldViewModeNever;
        [_deTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-55);
        }];
    } else {
        
        _deTextField.clearButtonMode = UITextFieldViewModeAlways;
        [_deTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-30);
        }];
    }
}
- (void)setObject:(id)object {
    _object = object;
    _deTextField.delegate = object;
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




